import Foundation
import HealthKit
import Attributes
import Common

/// Public HealthKit factories are kept behind the manifest's OS availability
/// check. Profile and one-time share records intentionally have no HKSampleType.
public enum HealthCatalogObjectTypes {
	public static func objectType(for descriptor: HealthTypeDescriptor) -> HKObjectType? {
		guard descriptor.isAvailableOnCurrentOS else { return nil }
		switch descriptor.family {
		case .quantity: return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: descriptor.identifier))
		case .category: return HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: descriptor.identifier))
		case .correlation: return HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier(rawValue: descriptor.identifier))
		case .clinical: return HKObjectType.clinicalType(forIdentifier: HKClinicalTypeIdentifier(rawValue: descriptor.identifier))
		case .document: return HKObjectType.documentType(forIdentifier: HKDocumentTypeIdentifier(rawValue: descriptor.identifier))
		case .characteristic: return HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier(rawValue: descriptor.identifier))
		case .activitySummary: return HKObjectType.activitySummaryType()
		case .workout: return HKObjectType.workoutType()
		case .workoutRoute: return HKSeriesType.workoutRoute()
		case .heartbeatSeries: return HKSeriesType.heartbeat()
		case .electrocardiogram: return HKObjectType.electrocardiogramType()
		case .audiogram: return HKObjectType.audiogramSampleType()
		case .visionPrescription: return HKObjectType.visionPrescriptionType()
		case .stateOfMind: return HKObjectType.stateOfMindType()
		case .scoredAssessment:
			return HKScoredAssessmentType(HKScoredAssessmentTypeIdentifier(rawValue: descriptor.identifier))
		case .medicationDose:
			if #available(iOS 26.0, *) { return HKObjectType.medicationDoseEventType() }
			return nil
		case .userAnnotatedMedication:
			if #available(iOS 26.0, *) { return HKObjectType.userAnnotatedMedicationType() }
			return nil
		case .verifiableClinical, .attachment: return nil
		}
	}
}

private enum HealthSpecializedAttributes {
	static let valence = DoubleAttribute(id: 0, name: "Valence (-1 to 1)", pluralName: "Valences", optional: true)
	static let score = DoubleAttribute(id: 0, name: "Recorded assessment score", pluralName: "Recorded assessment scores", optional: true)
	static let heartRate = DoubleAttribute(id: 0, name: "Average heart rate (count/min)", pluralName: "Average heart rates", optional: true)
	static let frequencyCount = DoubleAttribute(id: 0, name: "Recorded frequency count", pluralName: "Recorded frequency counts", optional: true)
	static let heartbeatCount = DoubleAttribute(id: 0, name: "Recorded heartbeat count", pluralName: "Recorded heartbeat counts", optional: true)
	static let summary = TextAttribute(id: 1, name: "Summary", pluralName: "Summaries")
	static let duration = DurationAttribute(id: 2)
	static let kind = TextAttribute(id: 3, name: "Kind", pluralName: "Kinds", optional: true)
	static let labels = TextAttribute(id: 4, name: "Labels", pluralName: "Labels", optional: true)
	static let associations = TextAttribute(id: 5, name: "Associations", pluralName: "Associations", optional: true)
}

/// A distinct concrete metatype per generated definition, retaining the original
/// Health object rather than manufacturing a new UUID or rewriting timestamps.
public final class HealthSpecializedSample<D: HealthCatalogDefinition>: HealthCatalogSample, SearchableSample {
	public static var catalogEntry: HealthTypeDescriptor { D.catalogEntry }
	public static var name: String { catalogEntry.name }
	public static var description: String { "\(name) recorded in Apple Health" }
	public static var sampleType: HKSampleType {
		guard let type = HealthCatalogObjectTypes.objectType(for: catalogEntry) as? HKSampleType else {
			preconditionFailure("An unavailable or non-sample catalog type cannot create a Health sample query")
		}
		return type
	}
	public static var readPermissions: Set<HKObjectType> {
		if catalogEntry.family == .workoutRoute {
			return [HKSeriesType.workoutRoute(), HKObjectType.workoutType()]
		}
		if catalogEntry.family == .correlation {
			// HealthKit authorizes correlation components, not correlation types.
			let componentIDs = catalogEntry.identifier.contains("BloodPressure")
				? ["HKQuantityTypeIdentifierBloodPressureSystolic", "HKQuantityTypeIdentifierBloodPressureDiastolic"]
				: HealthCatalog.descriptors.filter { $0.family == .quantity && $0.identifier.hasPrefix("HKQuantityTypeIdentifierDietary") }.map { $0.identifier }
			return Set(componentIDs.compactMap { HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: $0)) })
		}
		return [sampleType]
	}
	public static var writePermissions: Set<HKSampleType> { [] }
	public static func initUnits() {}
	public static var attributes: [Attribute] {
		var values: [Attribute] = [CommonSampleAttributes.healthKitStartDate, CommonSampleAttributes.healthKitEndDate,
			HealthSpecializedAttributes.summary, HealthSpecializedAttributes.duration]
		if catalogEntry.family == .stateOfMind {
			values += [numericAttribute!, HealthSpecializedAttributes.kind,
				HealthSpecializedAttributes.labels, HealthSpecializedAttributes.associations]
		} else if let numeric = numericAttribute {
			values.append(numeric)
		}
		return values
	}
	public static var dateAttributes: [DateType: DateAttribute] {
		[.start: CommonSampleAttributes.healthKitStartDate, .end: CommonSampleAttributes.healthKitEndDate]
	}
	public static var defaultIndependentAttribute: Attribute { CommonSampleAttributes.healthKitStartDate }
	public static var defaultDependentAttribute: Attribute {
		if let numeric = numericAttribute { return numeric }
		// A dose of 1 tablet cannot be averaged with 1 mg or a different medicine.
		// Keep medication concept, quantity and unit together in its recorded summary.
		if catalogEntry.family == .medicationDose { return HealthSpecializedAttributes.summary }
		return HealthSpecializedAttributes.duration
	}
	private static var numericAttribute: DoubleAttribute? {
		switch catalogEntry.family {
		case .stateOfMind: return HealthSpecializedAttributes.valence
		case .scoredAssessment: return HealthSpecializedAttributes.score
		case .electrocardiogram: return HealthSpecializedAttributes.heartRate
		case .audiogram: return HealthSpecializedAttributes.frequencyCount
		case .heartbeatSeries: return HealthSpecializedAttributes.heartbeatCount
		default: return nil
		}
	}

	public let sample: HKSample
	public var originalHealthSample: HKSample? { sample }
	public var sourceIdentifier: UUID? { sample.uuid }
	public var attributedName: String { Self.name }
	public var description: String { HealthRecordDetails.summary(for: sample) }
	public var attributes: [Attribute] { Self.attributes }
	public required init(validating sample: HKSample) throws {
		guard Self.catalogEntry.isAvailableOnCurrentOS,
			let expected = HealthCatalogObjectTypes.objectType(for: Self.catalogEntry) as? HKSampleType,
			sample.sampleType == expected else { throw HealthCatalogError.unexpectedSample(Self.name) }
		self.sample = sample
	}
	public func hkSample() -> HKSample { sample }
	public func dates() -> [DateType: Date] { [.start: sample.startDate, .end: sample.endDate] }
	public func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) { return sample.startDate }
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) { return sample.endDate }
		if attribute.equalTo(HealthSpecializedAttributes.summary) { return description }
		if attribute.equalTo(HealthSpecializedAttributes.duration) { return TimeDuration(sample.endDate.timeIntervalSince(sample.startDate)) }
		if let numeric = Self.numericAttribute, attribute.equalTo(numeric) {
			if let mind = sample as? HKStateOfMind { return mind.valence }
			if let assessment = sample as? HKScoredAssessment { return Double(assessment.score) }
			if let ecg = sample as? HKElectrocardiogram { return ecg.averageHeartRate?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) }
			if let audiogram = sample as? HKAudiogramSample { return Double(audiogram.sensitivityPoints.count) }
			if let heartbeat = sample as? HKHeartbeatSeriesSample { return Double(heartbeat.count) }
			return nil
		}
		if let mind = sample as? HKStateOfMind {
			if attribute.equalTo(HealthSpecializedAttributes.kind) { return HealthRecordDetails.stateOfMindKind(mind.kind.rawValue) }
			if attribute.equalTo(HealthSpecializedAttributes.labels) { return mind.labels.map { HealthRecordDetails.stateOfMindLabel($0.rawValue) }.joined(separator: ", ") }
			if attribute.equalTo(HealthSpecializedAttributes.associations) { return mind.associations.map { HealthRecordDetails.stateOfMindAssociation($0.rawValue) }.joined(separator: ", ") }
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
	public func set(attribute: Attribute, to value: Any?) throws { throw HealthCatalogError.readOnly }
	public func equalTo(_ other: Sample) -> Bool { (other as? Self)?.sample.uuid == sample.uuid }
	public func equalTo(_ other: Attributed) -> Bool { (other as? Self)?.sample.uuid == sample.uuid }
	public func matchesSearchString(_ text: String) -> Bool {
		([Self.name, description] + HealthRecordDetails.sections(for: self).flatMap { $0.fields.map { $0.value } })
			.contains { $0.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil }
	}
}
