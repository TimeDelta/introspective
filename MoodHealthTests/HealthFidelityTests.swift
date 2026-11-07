import XCTest
import HealthKit
import Attributes
import Common
import DependencyInjection
import Samples

private final class HealthFidelityProvider: HealthKitUtil, InjectionProvider {
	let types: [Any.Type] = [HealthKitUtil.self]
	var dateOffset: TimeInterval = 0
	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) { date.addTimeInterval(dateOffset) }
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("Inspecting stored Health records must not start a calculation"); callback(nil, nil)
	}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		XCTFail("Inspecting stored Health records must not query Health"); callback([], nil); return {}
	}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		XCTFail("Inspecting a captured record must not read current unit preferences"); return nil
	}
	func getAuthorization(callback: @escaping (Error?) -> Void) {
		XCTFail("Inspecting stored records must not request authorization"); callback(nil)
	}
}

final class HealthFidelityTests: XCTestCase {
	private let start = Date(timeIntervalSinceReferenceDate: 700_000_000.1234567)
	private var provider: HealthFidelityProvider!

	override func setUp() {
		super.setUp()
		provider = HealthFidelityProvider()
		DependencyInjector.register([provider])
	}

	private var device: HKDevice {
		HKDevice(name: "Fixture watch", manufacturer: "Fixture", model: "Test device",
			hardwareVersion: "1", firmwareVersion: "2", softwareVersion: "3",
			localIdentifier: "health-fidelity-device", udiDeviceIdentifier: nil)
	}
	private var metadata: [String: Any] {
		[HKMetadataKeyTimeZone: "America/New_York", "IntrospectiveFidelityNote": "Original café 🫀",
			HKMetadataKeyWasUserEntered: true]
	}

	private func assertOriginal(_ wrapped: HealthKitSample, is original: HKSample,
		file: StaticString = #file, line: UInt = #line) throws {
		let retained = try XCTUnwrap(wrapped.originalHealthSample, file: file, line: line)
		XCTAssertTrue(retained === original, "Keep the immutable source record instead of reconstructing its provenance", file: file, line: line)
		XCTAssertEqual(wrapped.sourceIdentifier, original.uuid, file: file, line: line)
		XCTAssertEqual(retained.startDate.timeIntervalSinceReferenceDate.bitPattern,
			original.startDate.timeIntervalSinceReferenceDate.bitPattern, file: file, line: line)
		XCTAssertEqual(retained.endDate.timeIntervalSinceReferenceDate.bitPattern,
			original.endDate.timeIntervalSinceReferenceDate.bitPattern, file: file, line: line)
		XCTAssertEqual(retained.metadata?["IntrospectiveFidelityNote"] as? String, "Original café 🫀", file: file, line: line)
		XCTAssertEqual(retained.metadata?[HKMetadataKeyTimeZone] as? String, "America/New_York", file: file, line: line)
		XCTAssertEqual(retained.device?.localIdentifier, "health-fidelity-device", file: file, line: line)
		// Identity also preserves sourceRevision; Health assigns that provenance
		// when saving, so these synthetic unsaved records do not invent a source.
	}

	func testAllExistingQuantityFamiliesKeepOriginalMetadataDeviceAndRawDateBits() throws {
		provider.dateOffset = 3600.25
		let types: [HealthKitQuantitySample.Type] = [Steps.self, ActiveEnergy.self, Weight.self, LeanBodyMass.self,
			BodyMassIndex.self, DietarySugar.self, HeartRate.self, RestingHeartRate.self]
		for type in types {
			let original = HKQuantitySample(type: type.quantityType, quantity: HKQuantity(unit: type.unit, doubleValue: 25.5),
				start: start, end: start.addingTimeInterval(17.875), device: device, metadata: metadata)
			let wrapped = type.init(original, unit: type.unit)
			try assertOriginal(wrapped, is: original)
			XCTAssertEqual(wrapped.quantityValue(), 25.5, accuracy: 1e-9)
			XCTAssertNotEqual(wrapped.dates()[.start], original.startDate,
				"Display-time conversion may change wrapper dates, but must leave source dates untouched")
		}
	}

	private func capturedUnit<Wrapped: HealthKitQuantitySample>(_ type: Wrapped.Type, unit: HKUnit,
		changeGlobal: () -> Void, file: StaticString = #file, line: UInt = #line) throws {
		let original = HKQuantitySample(type: type.quantityType, quantity: HKQuantity(unit: unit, doubleValue: 25),
			start: start, end: start.addingTimeInterval(60), device: device, metadata: metadata)
		let wrapped = type.init(original, unit: unit)
		changeGlobal()
		XCTAssertEqual(wrapped.unitString, unit.unitString, "A changed preference cannot relabel a captured numeric value", file: file, line: line)
		XCTAssertEqual(wrapped.quantityValue(), 25, accuracy: 1e-9, file: file, line: line)
		let exported = try XCTUnwrap(wrapped.hkSample() as? HKQuantitySample, file: file, line: line)
		XCTAssertEqual(exported.quantity.doubleValue(for: unit), 25, accuracy: 1e-9, file: file, line: line)
		try assertOriginal(wrapped, is: original, file: file, line: line)
	}

	func testCapturedMassUnitsRemainCorrectForDisplayAndReconstructionAfterPreferenceChanges() throws {
		let weight = Weight.unit, lean = LeanBodyMass.unit
		defer { Weight.unit = weight; LeanBodyMass.unit = lean }
		try capturedUnit(Weight.self, unit: .gramUnit(with: .kilo), changeGlobal: { Weight.unit = .pound() })
		try capturedUnit(LeanBodyMass.self, unit: .gramUnit(with: .kilo), changeGlobal: { LeanBodyMass.unit = .pound() })
	}

	func testCapturedRateAndNutritionUnitsRemainCorrectAfterPreferenceChanges() throws {
		let heart = HeartRate.unit, resting = RestingHeartRate.unit, sugar = DietarySugar.unit
		defer { HeartRate.unit = heart; RestingHeartRate.unit = resting; DietarySugar.unit = sugar }
		let perSecond = HKUnit.count().unitDivided(by: .second())
		let perMinute = HKUnit.count().unitDivided(by: .minute())
		try capturedUnit(HeartRate.self, unit: perSecond, changeGlobal: { HeartRate.unit = perMinute })
		try capturedUnit(RestingHeartRate.self, unit: perSecond, changeGlobal: { RestingHeartRate.unit = perMinute })
		try capturedUnit(DietarySugar.self, unit: .gramUnit(with: .milli), changeGlobal: { DietarySugar.unit = .gram() })
	}

	func testExplicitCapturedEnergyUnitMatchesItsDisplayedAndReconstructedNumber() throws {
		try capturedUnit(ActiveEnergy.self, unit: .joule(), changeGlobal: {})
	}

	func testLocalQuantitiesCaptureTheirConstructionUnitWithoutClaimingHealthProvenance() throws {
		let old = Weight.unit; defer { Weight.unit = old }
		Weight.unit = .gramUnit(with: .kilo)
		let local = Weight(70, start)
		Weight.unit = .pound()
		XCTAssertEqual(local.unitString, HKUnit.gramUnit(with: .kilo).unitString)
		XCTAssertNil(local.originalHealthSample); XCTAssertNil(local.sourceIdentifier)
		let exported = try XCTUnwrap(local.hkSample() as? HKQuantitySample)
		XCTAssertEqual(exported.quantity.doubleValue(for: .gramUnit(with: .kilo)), 70, accuracy: 1e-9)
	}

	func testEditingACapturedQuantityRebuildsTheEditWithoutOverwritingItsSourceRecord() throws {
		let original = HKQuantitySample(type: Weight.quantityType, quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 70),
			start: start, end: start, device: device, metadata: metadata)
		let wrapped = Weight(original, unit: .gramUnit(with: .kilo))
		try wrapped.set(attribute: Weight.weight, to: 71.25)
		try wrapped.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: start.addingTimeInterval(90))
		let rebuilt = try XCTUnwrap(wrapped.hkSample() as? HKQuantitySample)
		XCTAssertEqual(rebuilt.quantity.doubleValue(for: .gramUnit(with: .kilo)), 71.25)
		XCTAssertEqual(rebuilt.startDate, start.addingTimeInterval(90))
		XCTAssertNotEqual(rebuilt.uuid, original.uuid)
		XCTAssertEqual(original.quantity.doubleValue(for: .gramUnit(with: .kilo)), 70)
		XCTAssertEqual(original.startDate, start)
		try assertOriginal(wrapped, is: original)
	}

	func testCorrelationRetainsOriginalComponentsAndEachCapturedPressureUnit() throws {
		let oldSystolic = BloodPressure.systolicUnit, oldDiastolic = BloodPressure.diastolicUnit
		defer { BloodPressure.systolicUnit = oldSystolic; BloodPressure.diastolicUnit = oldDiastolic }
		let high = HKQuantitySample(type: BloodPressure.systolicQuantityType,
			quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 120), start: start, end: start)
		let low = HKQuantitySample(type: BloodPressure.diastolicQuantityType,
			quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 80), start: start, end: start)
		let original = HKCorrelation(type: BloodPressure.correlationType, start: start, end: start,
			objects: [high, low], device: device, metadata: metadata)
		let wrapped = BloodPressure(original, systolicUnit: .pascalUnit(with: .kilo), diastolicUnit: .millimeterOfMercury())
		BloodPressure.systolicUnit = .millimeterOfMercury(); BloodPressure.diastolicUnit = .pascal()
		XCTAssertEqual(wrapped.systolicUnitString, HKUnit.pascalUnit(with: .kilo).unitString)
		XCTAssertEqual(wrapped.diastolicUnitString, HKUnit.millimeterOfMercury().unitString)
		let rebuilt = try XCTUnwrap(wrapped.hkSample() as? HKCorrelation)
		let rebuiltHigh = try XCTUnwrap(rebuilt.objects(for: BloodPressure.systolicQuantityType).first as? HKQuantitySample)
		let rebuiltLow = try XCTUnwrap(rebuilt.objects(for: BloodPressure.diastolicQuantityType).first as? HKQuantitySample)
		XCTAssertEqual(rebuiltHigh.quantity.doubleValue(for: .pascalUnit(with: .kilo)), wrapped.systolic, accuracy: 1e-9)
		XCTAssertEqual(rebuiltLow.quantity.doubleValue(for: .millimeterOfMercury()), wrapped.diastolic, accuracy: 1e-9)
		XCTAssertEqual(original.objects.map { $0.uuid }.sorted { $0.uuidString < $1.uuidString },
			[high.uuid, low.uuid].sorted { $0.uuidString < $1.uuidString })
		try assertOriginal(wrapped, is: original)
	}

	func testCategoryAndWorkoutWrappersKeepTheCompleteOriginalRecord() throws {
		provider.dateOffset = -1800.5
		let sleep = HKCategorySample(type: Sleep.categoryType, value: HKCategoryValueSleepAnalysis.asleepREM.rawValue,
			start: start, end: start.addingTimeInterval(300.875), device: device, metadata: metadata)
		let sexual = HKCategorySample(type: SexualActivity.categoryType, value: HKCategoryValue.notApplicable.rawValue,
			start: start, end: start, device: device, metadata: metadata)
		let workout = HKWorkout(activityType: .walking, start: start, end: start.addingTimeInterval(60), duration: 60,
			totalEnergyBurned: nil, totalDistance: nil, device: device, metadata: metadata)
		try assertOriginal(Sleep(sleep), is: sleep)
		try assertOriginal(SexualActivity(sexual), is: sexual)
		try assertOriginal(Workout(workout), is: workout)
	}

	func testAllRecognizedSleepStagesDecodeAndKeepLegacySelectionIndexes() throws {
		let cases: [(HKCategoryValueSleepAnalysis, Sleep.State, Bool)] = [
			(.awake, .awake, false), (.inBed, .inBed, false), (.asleepUnspecified, .asleep, true),
			(.asleepCore, .asleepCore, true), (.asleepDeep, .asleepDeep, true), (.asleepREM, .asleepREM, true),
		]
		for (raw, state, asleep) in cases {
			let original = HKCategorySample(type: Sleep.categoryType, value: raw.rawValue,
				start: start, end: start.addingTimeInterval(60))
			let sleep = Sleep(original)
			XCTAssertEqual(sleep.state, state)
			XCTAssertEqual(sleep.isAsleep, asleep)
			XCTAssertEqual(try sleep.value(of: Sleep.stateCodeAttribute) as? Int, raw.rawValue)
			XCTAssertEqual(try sleep.value(of: Sleep.isAsleepAttribute) as? Bool, asleep)
			XCTAssertEqual((sleep.hkSample() as? HKCategorySample)?.value, raw.rawValue)
		}
		XCTAssertEqual(Array(Sleep.State.allValues.prefix(3)), [.awake, .inBed, .asleep])
		XCTAssertEqual(Sleep.stateAttribute.indexOf(possibleValue: Sleep.State.asleep), 2)
		XCTAssertEqual(Sleep.stateAttribute.id, 0); XCTAssertEqual(Sleep.durationAttribute.id, 1)
		XCTAssertEqual(Sleep.stateCodeAttribute.id, 2); XCTAssertEqual(Sleep.isAsleepAttribute.id, 3)
	}

	func testFutureSleepCodesRemainUnknownAndNeverBecomeAwakeOrAsleep() throws {
		for raw in [-1, 99, Int.max] {
			let state = Sleep.State(rawValue: raw)
			XCTAssertEqual(state, .unknown(raw)); XCTAssertEqual(state.rawValue, raw)
			let sleep = Sleep(state, startDate: start, endDate: start.addingTimeInterval(60))
			XCTAssertNil(sleep.isAsleep)
			XCTAssertNil(try sleep.value(of: Sleep.isAsleepAttribute))
			XCTAssertEqual(try sleep.value(of: Sleep.stateCodeAttribute) as? Int, raw)
			XCTAssertTrue(sleep.matchesSearchString("unknown"))
			XCTAssertTrue(sleep.state.description.contains(String(raw)))
		}
	}

	func testSleepRawCodesAndSummariesAreReadOnlyAndUnknownCodesCannotBeWrittenAsStages() throws {
		let sleep = Sleep(.asleepCore, startDate: start, endDate: start.addingTimeInterval(60))
		XCTAssertThrowsError(try sleep.set(attribute: Sleep.stateCodeAttribute, to: 99))
		XCTAssertThrowsError(try sleep.set(attribute: Sleep.isAsleepAttribute, to: false))
		XCTAssertThrowsError(try sleep.set(attribute: Sleep.stateAttribute, to: Sleep.State.unknown(99)))
		XCTAssertEqual(sleep.state, .asleepCore)
		try sleep.set(attribute: Sleep.stateAttribute, to: Sleep.State.asleepREM)
		XCTAssertEqual(sleep.state, .asleepREM)
	}

	func testLegacyAsleepSearchStillMatchesTheUnspecifiedStage() {
		let sleep = Sleep(.asleep, startDate: start, endDate: start.addingTimeInterval(60))
		XCTAssertTrue(sleep.matchesSearchString("asleep"))
		XCTAssertEqual(sleep.state, .asleep)
		XCTAssertTrue(sleep.state.description.localizedCaseInsensitiveContains("unspecified"))
	}
}
