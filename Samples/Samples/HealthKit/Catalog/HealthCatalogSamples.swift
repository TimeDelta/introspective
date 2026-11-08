import Foundation
import HealthKit
import Attributes
import Common

/// Attribute identifiers are permanent within each catalog sample type. They
/// intentionally do not depend on the number or order of available Health types.
private enum CatalogAttributes {
    static let lock = NSLock()
    static var values: [Int16: DoubleAttribute] = [:]
    static var units: [Int16: HKUnit] = [:]
    static let quantityDuration = DurationAttribute(id: 1)
    static let unit = TextAttribute(id: 2, name: "Display Unit")
    static let category = TextAttribute(id: 0, name: "Category", pluralName: "Categories")
    static let rawCategory = IntegerAttribute(id: 1, name: "Raw Health Category Code",
        description: "The code stored by Health. Category codes are identifiers, not a continuous clinical score.")
    static let categoryDuration = DurationAttribute(id: 2)
    static let uuid = TextAttribute(id: 3, name: "Health Record UUID")
    static let sourceBundle = TextAttribute(id: 4, name: "Source App Identifier")
    static let sourceName = TextAttribute(id: 5, name: "Source App")
    static let device = TextAttribute(id: 6, name: "Device", optional: true)
    static let metadata = TextAttribute(id: 7, name: "Health Metadata", optional: true)
    static let provenance: [Attribute] = [uuid, sourceBundle, sourceName, device, metadata]

    static func quantityValue(for descriptor: HealthTypeDescriptor) -> DoubleAttribute {
        lock.lock(); defer { lock.unlock() }
        if let attribute = values[descriptor.id] { return attribute }
        let unit = descriptor.canonicalUnit ?? "count"
        let unitLabel = unit == "%" ? "fraction; 1 = 100%" : unit
        let attribute = DoubleAttribute(id: 0, name: "Value (\(unitLabel))", pluralName: "Values (\(unitLabel))",
            description: "Measured in the catalog's fixed \(unitLabel) unit, so saved query thresholds do not change with display preferences.",
            variableName: HKPredicateKeyPathQuantity)
        values[descriptor.id] = attribute
        return attribute
    }

    static func quantityUnit(for descriptor: HealthTypeDescriptor) -> HKUnit {
        lock.lock(); defer { lock.unlock() }
        if let unit = units[descriptor.id] { return unit }
        // The generator accepts only the documented unit spellings in the
        // versioned manifest; native tests check compatibility with every type.
        let unit = HKUnit(from: descriptor.canonicalUnit ?? "count")
        units[descriptor.id] = unit
        return unit
    }

    static func provenanceValue(_ attribute: Attribute, sample: HKSample) throws -> Any? {
        if attribute.equalTo(uuid) { return sample.uuid.uuidString }
        if attribute.equalTo(sourceBundle) { return sample.sourceRevision.source.bundleIdentifier }
        if attribute.equalTo(sourceName) { return sample.sourceRevision.source.name }
        if attribute.equalTo(device) { return sample.device?.name }
        if attribute.equalTo(metadata) {
            guard let values = sample.metadata, !values.isEmpty else { return nil }
            return values.keys.sorted().map { "\($0): \(String(describing: values[$0]!))" }.joined(separator: "\n")
        }
        throw HealthCatalogError.unexpectedSample("attribute")
    }
}

/// A quantity is converted to one explicit unit and keeps that unit alongside
/// its value. Its original immutable Health record remains available unchanged.
public final class HealthQuantity<D: HealthCatalogDefinition>: HealthKitQuantitySample, HealthCatalogSample, SearchableSample {
    public static var catalogEntry: HealthTypeDescriptor { D.catalogEntry }
    public static var name: String { catalogEntry.name }
    public static var description: String { "\(name) recorded in Apple Health" }
    public static var quantityType: HKQuantityType {
        guard let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: catalogEntry.identifier)) else {
            preconditionFailure("Unavailable catalog quantity must not be queried")
        }
        return type
    }
    public static var sampleType: HKSampleType { quantityType }
    public static var readPermissions: Set<HKObjectType> { [sampleType] }
    public static var writePermissions: Set<HKSampleType> { [] }
    public static var unit: HKUnit { CatalogAttributes.quantityUnit(for: catalogEntry) }
    public static func initUnits() {}
    public static var valueAttribute: DoubleAttribute { CatalogAttributes.quantityValue(for: catalogEntry) }
    public static var attributes: [Attribute] {
        [valueAttribute, CatalogAttributes.quantityDuration, CatalogAttributes.unit,
            CommonSampleAttributes.healthKitStartDate, CommonSampleAttributes.healthKitEndDate] + CatalogAttributes.provenance
    }
    public static var dateAttributes: [DateType: DateAttribute] {
        [.start: CommonSampleAttributes.healthKitStartDate, .end: CommonSampleAttributes.healthKitEndDate]
    }
    public static var defaultDependentAttribute: Attribute { valueAttribute }
    public static var defaultIndependentAttribute: Attribute { CommonSampleAttributes.healthKitStartDate }

    public let sample: HKQuantitySample
    public let capturedUnit: HKUnit
    private let capturedValue: Double
    private let canonicalValue: Double
    public var originalHealthSample: HKSample? { sample }
    public var sourceIdentifier: UUID? { sample.uuid }
    public var attributedName: String { Self.name }
    public var description: String { "\(Self.name): \(capturedValue) \(unitString)" }
    public var attributes: [Attribute] { Self.attributes }
    public var unitString: String { capturedUnit == HKUnit.percent() ? "fraction (1 = 100%)" : capturedUnit.unitString }

    public required convenience init(_ sample: HKQuantitySample) { self.init(sample, unit: Self.unit) }
    public required init(_ sample: HKQuantitySample, unit: HKUnit) {
        self.sample = sample; capturedUnit = unit
        // This nonthrowing initializer is required by the legacy quantity
        // protocol. Never ask HealthKit to convert incompatible units: the
        // validating entry point below reports that error to query callers.
        capturedValue = sample.quantityType.identifier == Self.catalogEntry.identifier && sample.quantity.is(compatibleWith: unit)
            ? sample.quantity.doubleValue(for: unit) : .nan
        canonicalValue = sample.quantityType.identifier == Self.catalogEntry.identifier && sample.quantity.is(compatibleWith: Self.unit)
            ? sample.quantity.doubleValue(for: Self.unit) : .nan
    }
    public required convenience init(validating sample: HKSample) throws {
        guard Self.catalogEntry.isAvailableOnCurrentOS,
            let quantity = sample as? HKQuantitySample,
            quantity.quantityType.identifier == Self.catalogEntry.identifier else {
            throw HealthCatalogError.unexpectedSample(Self.name)
        }
        guard quantity.quantity.is(compatibleWith: Self.unit) else { throw HealthCatalogError.incompatibleUnit(Self.name) }
        self.init(quantity, unit: Self.unit)
    }
    public func quantityValue() -> Double { capturedValue }
    public func hkSample() -> HKSample { sample }
    public func dates() -> [DateType: Date] { [.start: sample.startDate, .end: sample.endDate] }
    public func value(of attribute: Attribute) throws -> Any? {
        if attribute.equalTo(Self.valueAttribute) {
            guard canonicalValue.isFinite else { throw HealthCatalogError.incompatibleUnit(Self.name) }
            return canonicalValue
        }
        if attribute.equalTo(CatalogAttributes.quantityDuration) { return TimeDuration(sample.endDate.timeIntervalSince(sample.startDate)) }
        if attribute.equalTo(CatalogAttributes.unit) { return unitString }
        if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) { return sample.startDate }
        if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) { return sample.endDate }
        if CatalogAttributes.provenance.contains(where: { $0.equalTo(attribute) }) {
            return try CatalogAttributes.provenanceValue(attribute, sample: sample)
        }
        throw UnknownAttributeError(attribute: attribute, for: self)
    }
    public func set(attribute: Attribute, to value: Any?) throws { throw HealthCatalogError.readOnly }
    public func equalTo(_ other: Sample) -> Bool { (other as? Self)?.sample.uuid == sample.uuid }
    public func equalTo(_ other: Attributed) -> Bool { (other as? Self)?.sample.uuid == sample.uuid }
    public func matchesSearchString(_ text: String) -> Bool {
        [Self.name, description, sample.sourceRevision.source.name].contains {
            $0.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
    }
}

/// Category labels remain text. Raw Health category codes are separately
/// available for exact diagnostics, not used as an implicit numeric score.
public final class HealthCategory<D: HealthCatalogDefinition>: HealthKitCategorySample, HealthCatalogSample, SearchableSample {
    public static var catalogEntry: HealthTypeDescriptor { D.catalogEntry }
    public static var name: String { catalogEntry.name }
    public static var description: String { "\(name) recorded in Apple Health" }
    public static var categoryType: HKCategoryType {
        guard let type = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: catalogEntry.identifier)) else {
            preconditionFailure("Unavailable catalog category must not be queried")
        }
        return type
    }
    public static var sampleType: HKSampleType { categoryType }
    public static var readPermissions: Set<HKObjectType> { [sampleType] }
    public static var writePermissions: Set<HKSampleType> { [] }
    public static func initUnits() {}
    public static var categoryAttribute: TextAttribute { CatalogAttributes.category }
    public static var rawCategoryAttribute: IntegerAttribute { CatalogAttributes.rawCategory }
    public static var attributes: [Attribute] {
        [categoryAttribute, rawCategoryAttribute, CatalogAttributes.categoryDuration,
            CommonSampleAttributes.healthKitStartDate, CommonSampleAttributes.healthKitEndDate] + CatalogAttributes.provenance
    }
    public static var dateAttributes: [DateType: DateAttribute] {
        [.start: CommonSampleAttributes.healthKitStartDate, .end: CommonSampleAttributes.healthKitEndDate]
    }
    public static var defaultDependentAttribute: Attribute { categoryAttribute }
    public static var defaultIndependentAttribute: Attribute { CommonSampleAttributes.healthKitStartDate }
    public static func categoryLabel(for rawValue: Int) -> String { catalogEntry.categoryLabel(for: rawValue) }

    public let sample: HKCategorySample
    public var rawCategoryValue: Int { sample.value }
    public var categoryLabel: String { Self.categoryLabel(for: sample.value) }
    public var originalHealthSample: HKSample? { sample }
    public var sourceIdentifier: UUID? { sample.uuid }
    public var attributedName: String { Self.name }
    public var description: String { "\(Self.name): \(categoryLabel)" }
    public var attributes: [Attribute] { Self.attributes }
    public required init(validating sample: HKSample) throws {
        guard Self.catalogEntry.isAvailableOnCurrentOS,
            let category = sample as? HKCategorySample,
            category.categoryType.identifier == Self.catalogEntry.identifier else {
            throw HealthCatalogError.unexpectedSample(Self.name)
        }
        self.sample = category
    }
    public func hkSample() -> HKSample { sample }
    public func dates() -> [DateType: Date] { [.start: sample.startDate, .end: sample.endDate] }
    public func value(of attribute: Attribute) throws -> Any? {
        if attribute.equalTo(Self.categoryAttribute) { return categoryLabel }
        if attribute.equalTo(Self.rawCategoryAttribute) { return sample.value }
        if attribute.equalTo(CatalogAttributes.categoryDuration) { return TimeDuration(sample.endDate.timeIntervalSince(sample.startDate)) }
        if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) { return sample.startDate }
        if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) { return sample.endDate }
        if CatalogAttributes.provenance.contains(where: { $0.equalTo(attribute) }) {
            return try CatalogAttributes.provenanceValue(attribute, sample: sample)
        }
        throw UnknownAttributeError(attribute: attribute, for: self)
    }
    public func set(attribute: Attribute, to value: Any?) throws { throw HealthCatalogError.readOnly }
    public func equalTo(_ other: Sample) -> Bool { (other as? Self)?.sample.uuid == sample.uuid }
    public func equalTo(_ other: Attributed) -> Bool { (other as? Self)?.sample.uuid == sample.uuid }
    public func matchesSearchString(_ text: String) -> Bool {
        [Self.name, categoryLabel, String(rawCategoryValue), sample.sourceRevision.source.name].contains {
            $0.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
    }
}
