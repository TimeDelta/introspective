import XCTest
import Foundation
import HealthKit
import Attributes
@testable import Samples

final class HealthCatalogTests: XCTestCase {
    private let factory = SampleFactoryImpl()

    func testLegacySavedSampleIdentifiersKeepTheirExactMetatypes() throws {
        let legacy: [Sample.Type] = [Activity.self, BloodPressure.self, BodyMassIndex.self, DietarySugar.self,
            FatigueImpl.self, HeartRate.self, LeanBodyMass.self, MedicationDose.self, MoodImpl.self, PainImpl.self,
            RestingHeartRate.self, SexualActivity.self, Sleep.self, Weight.self, Steps.self, ActiveEnergy.self,
            Workout.self, LostItemEvent.self, MetricContextEntry.self, StressCheckIn.self, StressorResponse.self]
        for (index, type) in legacy.enumerated() {
            XCTAssertEqual(factory.sampleTypeId(for: type), Int16(index))
            XCTAssertTrue(try factory.sampleType(for: Int16(index)) == type)
        }
        XCTAssertThrowsError(try factory.sampleType(for: -1))
        XCTAssertThrowsError(try factory.sampleType(for: Int16.max))
    }

    func testTheCatalogHasUniquePermanentIdentifiersAndEveryPublicSDKFamily() {
        let descriptors = HealthCatalog.descriptors
        XCTAssertEqual(descriptors.count, 221)
        XCTAssertEqual(Set(descriptors.map { $0.id }).count, descriptors.count)
        XCTAssertEqual(Set(descriptors.map { $0.identifier }).count, descriptors.count)
        XCTAssertEqual(Set(descriptors.map { $0.family }), Set(HealthTypeFamily.allCases))
        XCTAssertEqual(descriptors.filter { $0.id >= 21 }.map { $0.id }.sorted(), (21...229).map { Int16($0) })
        XCTAssertEqual(descriptors.filter { $0.family == .quantity }.count, 120)
        XCTAssertEqual(descriptors.filter { $0.family == .category }.count, 69)
    }

    func testEveryAvailableCatalogMetatypeRoundTripsWithoutDuplicatePickerEntries() throws {
        let all = factory.allTypes()
        XCTAssertEqual(Set(all.map(ObjectIdentifier.init)).count, all.count)
        let registered = HealthCatalog.availableEntries.filter { $0.descriptor.id >= 21 }
        XCTAssertEqual(all.count, 21 + registered.count)
        if #available(iOS 26.2, *) {
            XCTAssertEqual(registered.count, 199, "Every public dated catalog type must resolve on the catalog SDK version")
            XCTAssertEqual(all.count, 220)
        }
        for entry in HealthCatalog.availableEntries {
            XCTAssertEqual(factory.sampleTypeId(for: entry.sampleType), entry.descriptor.id, entry.descriptor.name)
            XCTAssertTrue(try factory.sampleType(for: entry.descriptor.id) == entry.sampleType, entry.descriptor.name)
            XCTAssertEqual(HealthCatalog.descriptor(for: entry.sampleType), entry.descriptor)
            XCTAssertNotNil(HealthCatalogObjectTypes.objectType(for: entry.descriptor) as? HKSampleType, entry.descriptor.name)
        }
        let unavailable = HealthCatalog.registrations.filter { !$0.descriptor.isAvailableOnCurrentOS }
        for entry in unavailable {
            XCTAssertFalse(all.contains { $0 == entry.sampleType })
            XCTAssertThrowsError(try factory.sampleType(for: entry.descriptor.id))
        }
    }

    func testProfileAndDedicatedReaderRecordsAreNotInventedDatedQueryTypes() {
        let external: Set<HealthTypeFamily> = [.characteristic, .activitySummary, .userAnnotatedMedication, .verifiableClinical, .attachment]
        let rows = HealthCatalog.descriptors.filter { external.contains($0.family) }
        XCTAssertEqual(rows.count, 10)
        for descriptor in rows {
            XCTAssertFalse(HealthCatalog.registrations.contains { $0.descriptor.id == descriptor.id })
            XCTAssertThrowsError(try factory.sampleType(for: descriptor.id))
        }
    }

    func testDeprecatedAliasResolvesToItsCanonicalRecordRatherThanAnotherType() throws {
        let canonical = try XCTUnwrap(HealthCatalog.descriptor(for: "HKCategoryTypeIdentifierEnvironmentalAudioExposureEvent"))
        XCTAssertEqual(HealthCatalog.descriptor(for: "HKCategoryTypeIdentifierAudioExposureEvent"), canonical)
        XCTAssertEqual(HealthCatalog.descriptors.filter { $0.id == canonical.id }.count, 1)
        XCTAssertNil(HealthCatalog.descriptor(for: "HKNotARealHealthType"))
    }

    func testEveryAvailableQuantityHasACompatibleCanonicalUnit() throws {
        for descriptor in HealthCatalog.availableDescriptors where descriptor.family == .quantity {
            let quantity = try XCTUnwrap(HealthCatalogObjectTypes.objectType(for: descriptor) as? HKQuantityType,
                descriptor.identifier)
            let spelling = try XCTUnwrap(descriptor.canonicalUnit, descriptor.identifier)
            XCTAssertTrue(quantity.is(compatibleWith: HKUnit(from: spelling)),
                "Incompatible unit \(spelling) for \(descriptor.identifier)")
        }
    }

    func testQuantityRetainsTheOriginalRecordMetadataAndExactRawInstants() throws {
        let start = Date(timeIntervalSinceReferenceDate: 700_000_023.875)
        let end = start.addingTimeInterval(12.125)
        let source = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .height)!,
            quantity: HKQuantity(unit: HKUnit.meterUnit(with: .centi), doubleValue: 183), start: start, end: end,
            metadata: [HKMetadataKeyWasUserEntered: true, HKMetadataKeyTimeZone: "Pacific/Auckland", "Catalog Test": "retained"])
        let mapped = try HealthQuantity<HealthQuantityHeightDefinition>(validating: source)
        XCTAssertTrue(mapped.hkSample() === source)
        XCTAssertTrue(mapped.originalHealthSample === source)
        XCTAssertEqual(mapped.sourceIdentifier, source.uuid)
        XCTAssertEqual(mapped.originalHealthSample?.metadata?["Catalog Test"] as? String, "retained")
        XCTAssertEqual(mapped.dates()[.start]?.timeIntervalSinceReferenceDate.bitPattern, start.timeIntervalSinceReferenceDate.bitPattern)
        XCTAssertEqual(mapped.dates()[.end]?.timeIntervalSinceReferenceDate.bitPattern, end.timeIntervalSinceReferenceDate.bitPattern)
        XCTAssertEqual(mapped.quantityValue(), 1.83, accuracy: 0.000000000001)
        XCTAssertEqual(try XCTUnwrap(mapped.value(of: type(of: mapped).defaultDependentAttribute) as? Double), 1.83, accuracy: 0.000000000001)
        XCTAssertEqual(mapped.unitString, "m")
        let uuid = try XCTUnwrap(mapped.attributes.first { $0.id == 3 })
        XCTAssertEqual(try mapped.value(of: uuid) as? String, source.uuid.uuidString)
        let metadata = try XCTUnwrap(mapped.attributes.first { $0.id == 7 })
        XCTAssertTrue((try mapped.value(of: metadata) as? String)?.contains("Catalog Test: retained") == true)
    }

    func testCapturedDisplayUnitCannotChangeTheCanonicalSavedQueryThresholdUnit() throws {
        let source = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .height)!,
            quantity: HKQuantity(unit: .meter(), doubleValue: 1.8), start: Date(), end: Date())
        let mapped = HealthQuantity<HealthQuantityHeightDefinition>(source, unit: .meterUnit(with: .centi))
        XCTAssertEqual(mapped.quantityValue(), 180, accuracy: 0.000000000001)
        XCTAssertEqual(mapped.unitString, "cm")
        XCTAssertEqual(try XCTUnwrap(mapped.value(of: type(of: mapped).valueAttribute) as? Double), 1.8, accuracy: 0.000000000001)
        XCTAssertTrue(type(of: mapped).valueAttribute.name.contains("m"))
        XCTAssertTrue(mapped.hkSample() === source)
    }

    func testPercentFractionsAreNotMislabeledAsHundredTimesSmallerPercentages() throws {
        let source = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!,
            quantity: HKQuantity(unit: .percent(), doubleValue: 0.25), start: Date(), end: Date())
        let mapped = try HealthQuantity<HealthQuantityBodyFatPercentageDefinition>(validating: source)
        XCTAssertEqual(mapped.quantityValue(), 0.25)
        XCTAssertEqual(mapped.unitString, "fraction (1 = 100%)")
        XCTAssertTrue(type(of: mapped).valueAttribute.name.contains("1 = 100%"))
    }

    func testCategoryUsesItsMeaningAndPreservesTheSeparateRawCode() throws {
        let start = Date(timeIntervalSinceReferenceDate: 700_000_023.875)
        let source = HKCategorySample(type: HKCategoryType.categoryType(forIdentifier: .headache)!,
            value: HKCategoryValueSeverity.moderate.rawValue, start: start, end: start.addingTimeInterval(60),
            metadata: ["Catalog Test": "retained"])
        let mapped = try HealthCategory<HealthCategoryHeadacheDefinition>(validating: source)
        XCTAssertTrue(type(of: mapped).defaultDependentAttribute is TextAttribute)
        XCTAssertEqual(mapped.categoryLabel, "Moderate")
        XCTAssertEqual(mapped.rawCategoryValue, HKCategoryValueSeverity.moderate.rawValue)
        XCTAssertEqual(try mapped.value(of: type(of: mapped).defaultDependentAttribute) as? String, "Moderate")
        XCTAssertEqual(try mapped.value(of: type(of: mapped).rawCategoryAttribute) as? Int, HKCategoryValueSeverity.moderate.rawValue)
        XCTAssertTrue(mapped.hkSample() === source)
        XCTAssertEqual(mapped.sourceIdentifier, source.uuid)
        XCTAssertEqual(mapped.dates()[.start]?.timeIntervalSinceReferenceDate.bitPattern, start.timeIntervalSinceReferenceDate.bitPattern)
        XCTAssertEqual(mapped.originalHealthSample?.metadata?["Catalog Test"] as? String, "retained")
    }

    func testUnknownCategoryCodesRemainExplicitRatherThanBecomingAHealthyOrAbsentState() {
        for descriptor in HealthCatalog.descriptors where descriptor.family == .category {
            XCTAssertEqual(descriptor.categoryLabel(for: 98765), "Unknown Health category (98765)")
            for (raw, label) in descriptor.categoryValues { XCTAssertEqual(descriptor.categoryLabel(for: raw), label) }
        }
    }

    func testMismatchedRecordsThrowBeforeHealthConversionOrAttributeAccess() {
        let height = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .height)!,
            quantity: HKQuantity(unit: .meter(), doubleValue: 1.8), start: Date(), end: Date())
        XCTAssertThrowsError(try HealthQuantity<HealthQuantityBodyFatPercentageDefinition>(validating: height))
        XCTAssertThrowsError(try HealthCategory<HealthCategoryHeadacheDefinition>(validating: height))
    }

    func testAllNewHealthSamplesAreReadOnlyAndFoodRequestsOnlyItsQuantityComponents() throws {
        for entry in HealthCatalog.availableEntries where entry.descriptor.id >= 21 {
            let type = try XCTUnwrap(entry.sampleType as? HealthCatalogSample.Type)
            XCTAssertTrue(type.writePermissions.isEmpty, entry.descriptor.name)
        }
        let permissions = HealthSpecializedSample<HealthCorrelationFoodDefinition>.readPermissions
        XCTAssertFalse(permissions.isEmpty)
        XCTAssertTrue(permissions.allSatisfy { $0 is HKQuantityType && $0.identifier.hasPrefix("HKQuantityTypeIdentifierDietary") })
        let source = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .height)!,
            quantity: HKQuantity(unit: .meter(), doubleValue: 1.8), start: Date(), end: Date())
        let mapped = try HealthQuantity<HealthQuantityHeightDefinition>(validating: source)
        for attribute in mapped.attributes { XCTAssertThrowsError(try mapped.set(attribute: attribute, to: nil)) }
        XCTAssertEqual(mapped.quantityValue(), 1.8)
    }

    func testCatalogUnitsAndAttributeObjectsAreReusedWithoutGlobalPreferredUnitMutation() {
        typealias Height = HealthQuantity<HealthQuantityHeightDefinition>
        XCTAssertTrue(Height.unit === Height.unit)
        XCTAssertTrue(Height.valueAttribute === Height.valueAttribute)
        let first = Height.attributes, second = Height.attributes
        XCTAssertEqual(first.map { $0.id }, second.map { $0.id })
        XCTAssertTrue(zip(first, second).allSatisfy { ($0.0 as AnyObject) === ($0.1 as AnyObject) })
    }

    func testAvailabilityUsesMinorAndPatchVersionsAndRejectsMalformedCatalogVersions() {
        func entry(_ version: String) -> HealthTypeDescriptor {
            HealthTypeDescriptor(id: 30000, identifier: "HKTest", name: "Test", group: "Test", family: .category, minimumOS: version)
        }
        let minimum = entry("26.2")
        XCTAssertFalse(minimum.isAvailable(on: .init(majorVersion: 26, minorVersion: 1, patchVersion: 99)))
        XCTAssertTrue(minimum.isAvailable(on: .init(majorVersion: 26, minorVersion: 2, patchVersion: 0)))
        XCTAssertTrue(minimum.isAvailable(on: .init(majorVersion: 27, minorVersion: 0, patchVersion: 0)))
        XCTAssertFalse(entry("18.0.1").isAvailable(on: .init(majorVersion: 18, minorVersion: 0, patchVersion: 0)))
        XCTAssertTrue(entry("18.0.1").isAvailable(on: .init(majorVersion: 18, minorVersion: 0, patchVersion: 1)))
        for invalid in ["", "18..0", "eighteen", "18.-1", "18.0.0.1", "999999999999999999999999999"] {
            XCTAssertFalse(entry(invalid).isAvailable(on: .init(majorVersion: 99, minorVersion: 0, patchVersion: 0)), invalid)
        }
    }
}
