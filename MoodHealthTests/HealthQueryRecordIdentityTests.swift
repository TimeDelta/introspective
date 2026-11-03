import XCTest
import HealthKit

import Attributes
import Common
import DependencyInjection
import Samples

private final class RecordIdentityHealthProvider: HealthKitUtil, InjectionProvider {
	let types: [Any.Type] = [HealthKitUtil.self]
	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {}
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("Reading a record identity must not request Health data")
		callback(nil, GenericError("Unexpected Health calculation"))
	}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		XCTFail("Reading a record identity must not request Health data")
		callback(nil, GenericError("Unexpected Health read")); return {}
	}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		XCTFail("Reading a record identity must not request Health units"); return nil
	}
	func getAuthorization(callback: @escaping (Error?) -> Void) {
		XCTFail("Reading a record identity must not request Health authorization")
		callback(GenericError("Unexpected Health authorization"))
	}
}

final class HealthQueryRecordIdentityTests: XCTestCase {
	private let start = Date(timeIntervalSince1970: 1_700_000_000.123456)

	override func setUp() {
		super.setUp()
		DependencyInjector.register([RecordIdentityHealthProvider()])
	}

	private func quantityIdentity<Wrapped: HealthKitQuantitySample>(_ type: Wrapped.Type,
		file: StaticString = #file, line: UInt = #line) throws {
		let original = HKQuantitySample(type: type.quantityType, quantity: HKQuantity(unit: type.unit, doubleValue: 25),
			start: start, end: start.addingTimeInterval(30))
		let wrapped = type.init(original)
		assertIdentity(wrapped, original: original, file: file, line: line)
		try wrapped.set(attribute: type.defaultDependentAttribute, to: 26.0)
		XCTAssertEqual(wrapped.sourceIdentifier, original.uuid, file: file, line: line)
		XCTAssertEqual(wrapped.quantityValue(), 26, file: file, line: line)
		XCTAssertNotEqual(wrapped.hkSample().uuid, original.uuid, file: file, line: line)
	}

	private func assertIdentity(_ wrapped: HealthKitSample, original: HKSample,
		file: StaticString = #file, line: UInt = #line) {
		// Exercise protocol dispatch, not only a concrete wrapper property.
		XCTAssertEqual(wrapped.sourceIdentifier, original.uuid, file: file, line: line)
		let firstExport = wrapped.hkSample(), secondExport = wrapped.hkSample()
		XCTAssertNotEqual(firstExport.uuid, original.uuid, file: file, line: line)
		XCTAssertNotEqual(secondExport.uuid, firstExport.uuid, file: file, line: line)
		XCTAssertEqual(wrapped.sourceIdentifier, original.uuid, file: file, line: line)
	}

	func testStepsRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(Steps.self) }
	func testActiveEnergyRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(ActiveEnergy.self) }
	func testWeightRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(Weight.self) }
	func testLeanBodyMassRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(LeanBodyMass.self) }
	func testBodyMassIndexRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(BodyMassIndex.self) }
	func testDietarySugarRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(DietarySugar.self) }
	func testHeartRateRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(HeartRate.self) }
	func testRestingHeartRateRetainsOriginalIdentityAcrossExportAndEdits() throws { try quantityIdentity(RestingHeartRate.self) }

	func testSleepRetainsOriginalIdentityAcrossExportAndEdits() throws {
		let sample = HKCategorySample(type: Sleep.categoryType, value: HKCategoryValueSleepAnalysis.awake.rawValue,
			start: start, end: start.addingTimeInterval(60))
		let wrapped = Sleep(sample)
		assertIdentity(wrapped, original: sample)
		try wrapped.set(attribute: Sleep.stateAttribute, to: Sleep.State.inBed)
		XCTAssertEqual(wrapped.sourceIdentifier, sample.uuid)
		XCTAssertEqual(wrapped.state, .inBed)
	}

	func testSexualActivityRetainsOriginalIdentityAcrossExportAndEdits() throws {
		let sample = HKCategorySample(type: SexualActivity.categoryType, value: 0, start: start, end: start)
		let wrapped = SexualActivity(sample)
		assertIdentity(wrapped, original: sample)
		try wrapped.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: start.addingTimeInterval(60))
		XCTAssertEqual(wrapped.sourceIdentifier, sample.uuid)
		XCTAssertEqual(wrapped.timestamp, start.addingTimeInterval(60))
	}

	func testBloodPressureRetainsCorrelationIdentityAcrossExportAndEdits() throws {
		let systolic = HKQuantitySample(type: BloodPressure.systolicQuantityType,
			quantity: HKQuantity(unit: BloodPressure.systolicUnit, doubleValue: 120), start: start, end: start)
		let diastolic = HKQuantitySample(type: BloodPressure.diastolicQuantityType,
			quantity: HKQuantity(unit: BloodPressure.diastolicUnit, doubleValue: 80), start: start, end: start)
		let sample = HKCorrelation(type: BloodPressure.correlationType, start: start, end: start, objects: [systolic, diastolic])
		let wrapped = BloodPressure(sample)
		assertIdentity(wrapped, original: sample)
		XCTAssertNotEqual(wrapped.sourceIdentifier, systolic.uuid)
		XCTAssertNotEqual(wrapped.sourceIdentifier, diastolic.uuid)
		try wrapped.set(attribute: BloodPressure.systolic, to: 125.0)
		XCTAssertEqual(wrapped.sourceIdentifier, sample.uuid)
		XCTAssertEqual(wrapped.systolic, 125)
	}

	func testWorkoutRetainsItsOriginalReadOnlyRecordAndIdentity() {
		let sample = HKWorkout(activityType: .walking, start: start, end: start.addingTimeInterval(60), duration: 60,
			totalEnergyBurned: nil, totalDistance: nil, metadata: nil)
		let wrapped: HealthKitSample = Workout(sample)
		XCTAssertEqual(wrapped.sourceIdentifier, sample.uuid)
		XCTAssertTrue(wrapped.hkSample() === sample)
		XCTAssertEqual(wrapped.hkSample().uuid, wrapped.sourceIdentifier)
	}

	func testLocallyConstructedWrappersHaveNoClaimedHealthRecordIdentity() {
		let samples: [HealthKitSample] = [Steps(), ActiveEnergy(), Weight(), LeanBodyMass(), BodyMassIndex(),
			DietarySugar(), HeartRate(), RestingHeartRate(), Sleep(), SexualActivity(), BloodPressure()]
		for sample in samples {
			XCTAssertNil(sample.sourceIdentifier)
			_ = sample.hkSample()
			XCTAssertNil(sample.sourceIdentifier, "Export must not pretend the sample was read from Health")
		}
	}

	func testIdenticalHealthValuesRemainDistinctRecordsAndRepeatedReadsKeepIdentity() {
		let first = HKQuantitySample(type: Steps.quantityType, quantity: HKQuantity(unit: Steps.unit, doubleValue: 25),
			start: start, end: start)
		let second = HKQuantitySample(type: Steps.quantityType, quantity: HKQuantity(unit: Steps.unit, doubleValue: 25),
			start: start, end: start)
		let firstRead = Steps(first), sameRecordReadAgain = Steps(first), secondRead = Steps(second)
		XCTAssertEqual(firstRead.steps, secondRead.steps)
		XCTAssertEqual(firstRead.dates(), secondRead.dates())
		XCTAssertEqual(firstRead.sourceIdentifier, sameRecordReadAgain.sourceIdentifier)
		XCTAssertNotEqual(firstRead.sourceIdentifier, secondRead.sourceIdentifier)
	}

	private func capturedQuantity<Wrapped: HealthKitQuantitySample>(_ type: Wrapped.Type, unit: HKUnit,
		value: Double, legacyValue: Double, file: StaticString = #file, line: UInt = #line) {
		let original = HKQuantitySample(type: type.quantityType, quantity: HKQuantity(unit: unit, doubleValue: value),
			start: start, end: start.addingTimeInterval(60))
		// Calling through the protocol's generic metatype checks the initializer
		// witness, including the public compatibility default on the protocol.
		let captured = type.init(original, unit: unit)
		XCTAssertEqual(captured.quantityValue(), value, accuracy: 1e-8, file: file, line: line)
		XCTAssertEqual(captured.sourceIdentifier, original.uuid, file: file, line: line)
		XCTAssertEqual(captured.dates()[.start], original.startDate, file: file, line: line)
		let legacy = type.init(original)
		XCTAssertEqual(legacy.quantityValue(), legacyValue, accuracy: 1e-5, file: file, line: line)
		XCTAssertEqual(legacy.sourceIdentifier, original.uuid, file: file, line: line)
	}

	func testWeightMapsCapturedKilogramsDespiteGlobalPounds() {
		let old = Weight.unit; defer { Weight.unit = old }
		Weight.unit = .pound()
		capturedQuantity(Weight.self, unit: .gramUnit(with: .kilo), value: 1, legacyValue: 2.20462262185)
	}

	func testLeanBodyMassMapsCapturedKilogramsDespiteGlobalPounds() {
		let old = LeanBodyMass.unit; defer { LeanBodyMass.unit = old }
		LeanBodyMass.unit = .pound()
		capturedQuantity(LeanBodyMass.self, unit: .gramUnit(with: .kilo), value: 1, legacyValue: 2.20462262185)
	}

	func testSugarMapsCapturedMilligramsDespiteGlobalGrams() {
		let old = DietarySugar.unit; defer { DietarySugar.unit = old }
		DietarySugar.unit = .gram()
		capturedQuantity(DietarySugar.self, unit: .gramUnit(with: .milli), value: 25_000, legacyValue: 25)
	}

	func testHeartRateMapsCapturedCountPerSecondDespiteGlobalCountPerMinute() {
		let old = HeartRate.unit; defer { HeartRate.unit = old }
		HeartRate.unit = HKUnit.count().unitDivided(by: .minute())
		capturedQuantity(HeartRate.self, unit: HKUnit.count().unitDivided(by: .second()), value: 2, legacyValue: 120)
	}

	func testRestingHeartRateMapsCapturedCountPerSecondDespiteGlobalCountPerMinute() {
		let old = RestingHeartRate.unit; defer { RestingHeartRate.unit = old }
		RestingHeartRate.unit = HKUnit.count().unitDivided(by: .minute())
		capturedQuantity(RestingHeartRate.self, unit: HKUnit.count().unitDivided(by: .second()), value: 1, legacyValue: 60)
	}

	func testActiveEnergyMapsCapturedJoulesDespiteFixedKilocalorieDefault() {
		capturedQuantity(ActiveEnergy.self, unit: .joule(), value: 4184, legacyValue: 1)
	}

	func testStepsSupportsCapturedCountInitializerAndIdentity() {
		let old = Steps.unit; defer { Steps.unit = old }
		Steps.unit = .count()
		capturedQuantity(Steps.self, unit: .count(), value: 25, legacyValue: 25)
	}

	func testBodyMassIndexSupportsCapturedCountInitializerAndIdentity() {
		let old = BodyMassIndex.unit; defer { BodyMassIndex.unit = old }
		BodyMassIndex.unit = .count()
		capturedQuantity(BodyMassIndex.self, unit: .count(), value: 25, legacyValue: 25)
	}

	func testBloodPressureMapsBothCapturedComponentUnitsDespiteDifferentGlobals() {
		let oldSystolic = BloodPressure.systolicUnit, oldDiastolic = BloodPressure.diastolicUnit
		defer { BloodPressure.systolicUnit = oldSystolic; BloodPressure.diastolicUnit = oldDiastolic }
		BloodPressure.systolicUnit = .pascalUnit(with: .kilo)
		BloodPressure.diastolicUnit = .pascal()
		let systolic = HKQuantitySample(type: BloodPressure.systolicQuantityType,
			quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 120), start: start, end: start)
		let diastolic = HKQuantitySample(type: BloodPressure.diastolicQuantityType,
			quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 80), start: start, end: start)
		let sample = HKCorrelation(type: BloodPressure.correlationType, start: start, end: start, objects: [systolic, diastolic])
		let captured = BloodPressure(sample, systolicUnit: .millimeterOfMercury(), diastolicUnit: .millimeterOfMercury())
		XCTAssertEqual(captured.systolic, 120, accuracy: 1e-8)
		XCTAssertEqual(captured.diastolic, 80, accuracy: 1e-8)
		XCTAssertEqual(captured.sourceIdentifier, sample.uuid)
		XCTAssertEqual(captured.timestamp, start)
		let legacy = BloodPressure(sample)
		XCTAssertEqual(legacy.systolic, 15.9986864898, accuracy: 1e-5)
		XCTAssertEqual(legacy.diastolic, 10665.7909932, accuracy: 1e-3)
		XCTAssertEqual(legacy.sourceIdentifier, sample.uuid)
	}
}
