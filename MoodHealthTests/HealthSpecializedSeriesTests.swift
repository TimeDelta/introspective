import XCTest
import HealthKit
import CoreLocation
@testable import Samples

final class HealthSpecializedSeriesTests: XCTestCase {
	func testECGOffsetsOptionalVoltageAndOrderSurviveCompletion() throws {
		let values = [
			HealthECGMeasurement(timeSinceSampleStart: 0.000125, voltageInMillivolts: 0.875),
			HealthECGMeasurement(timeSinceSampleStart: 0.0078125, voltageInMillivolts: nil),
			HealthECGMeasurement(timeSinceSampleStart: 0.01171875, voltageInMillivolts: -0.125),
		]
		var result: Result<HealthSeriesSnapshot, Error>?
		let state = HealthSeriesReadState(kind: .ecg) { result = $0 }
		for value in values { XCTAssertTrue(state.appendECG(value)) }
		state.finish()
		guard case let .ecg(actual) = try XCTUnwrap(result).get() else { return XCTFail("Wrong series kind") }
		XCTAssertEqual(actual, values)
		XCTAssertNil(actual[1].voltageInMillivolts, "Missing voltages must not become zero")
	}

	func testHeartbeatGapsAndRecordedOrderAreNotInterpolated() throws {
		let beats = [
			HealthHeartbeatMeasurement(timeSinceSeriesStart: 0.875, precededByGap: false),
			HealthHeartbeatMeasurement(timeSinceSeriesStart: 1.625, precededByGap: false),
			HealthHeartbeatMeasurement(timeSinceSeriesStart: 5.125, precededByGap: true),
		]
		var result: Result<HealthSeriesSnapshot, Error>?
		let state = HealthSeriesReadState(kind: .heartbeat) { result = $0 }
		for beat in beats { XCTAssertTrue(state.appendHeartbeat(beat)) }
		state.finish()
		guard case let .heartbeat(actual) = try XCTUnwrap(result).get() else { return XCTFail("Wrong series kind") }
		XCTAssertEqual(actual, beats)
		XCTAssertEqual(actual.count, 3, "A collection gap must not create estimated heartbeats")
		XCTAssertTrue(actual[2].precededByGap)
	}

	func testRouteRetainsOriginalLocationDateAccuracyAndUnknownMotionValues() throws {
		let date = Date(timeIntervalSinceReferenceDate: 123456789.875)
		let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 40.125, longitude: -73.875),
			altitude: 12.5, horizontalAccuracy: 3.75, verticalAccuracy: 5.25,
			course: -1, speed: -1, timestamp: date)
		var result: Result<HealthSeriesSnapshot, Error>?
		let state = HealthSeriesReadState(kind: .route) { result = $0 }
		XCTAssertTrue(state.appendRoute(HealthRouteLocation(location: location)))
		state.finish()
		guard case let .route(locations) = try XCTUnwrap(result).get() else { return XCTFail("Wrong series kind") }
		let value = try XCTUnwrap(locations.first)
		XCTAssertTrue(value.location === location)
		XCTAssertEqual(value.timestamp, date)
		XCTAssertEqual(value.latitude, 40.125); XCTAssertEqual(value.longitude, -73.875)
		XCTAssertEqual(value.altitude, 12.5)
		XCTAssertEqual(value.horizontalAccuracy, 3.75); XCTAssertEqual(value.verticalAccuracy, 5.25)
		XCTAssertNil(value.speed); XCTAssertNil(value.course)
		XCTAssertEqual(value.location.speed, -1, "Original unavailable-value flags remain accessible")
	}

	func testRouteBatchesRemainInDeliveryOrderWithRecordedMotionValues() throws {
		let first = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 2),
			altitude: 3, horizontalAccuracy: 4, verticalAccuracy: 5, course: 6, speed: 7,
			timestamp: Date(timeIntervalSinceReferenceDate: 8.875))
		let second = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 9, longitude: 10),
			altitude: 11, horizontalAccuracy: 12, verticalAccuracy: 13, course: 14, speed: 15,
			timestamp: Date(timeIntervalSinceReferenceDate: 16.125))
		var result: Result<HealthSeriesSnapshot, Error>?
		let state = HealthSeriesReadState(kind: .route) { result = $0 }
		state.appendRoute(HealthRouteLocation(location: first))
		state.appendRoute(HealthRouteLocation(location: second))
		state.finish()
		guard case let .route(actual) = try XCTUnwrap(result).get() else { return XCTFail("Wrong series kind") }
		XCTAssertEqual(actual.map { $0.timestamp }, [first.timestamp, second.timestamp])
		XCTAssertEqual(actual.map { $0.speed }, [7, 15]); XCTAssertEqual(actual.map { $0.course }, [6, 14])
	}

	func testEmptySeriesCompletesWithItsActualKind() throws {
		for kind in [HealthSeriesReadState.Kind.ecg, .route, .heartbeat, .quantity] {
			var result: Result<HealthSeriesSnapshot, Error>?
			HealthSeriesReadState(kind: kind) { result = $0 }.finish()
			switch (kind, try XCTUnwrap(result).get()) {
			case let (.ecg, .ecg(values)): XCTAssertTrue(values.isEmpty)
			case let (.route, .route(values)): XCTAssertTrue(values.isEmpty)
			case let (.heartbeat, .heartbeat(values)): XCTAssertTrue(values.isEmpty)
			case let (.quantity, .quantity(values)): XCTAssertTrue(values.isEmpty)
			default: XCTFail("Empty results must not change the requested series kind")
			}
		}
	}

	func testCompletionRunsOnceAndIgnoresLateValuesErrorsAndCancellation() {
		var completions = 0, stops = 0
		let state = HealthSeriesReadState(kind: .heartbeat) { _ in completions += 1 }
		state.installCancellation { stops += 1 }
		state.finish(); state.finish()
		XCTAssertFalse(state.appendHeartbeat(HealthHeartbeatMeasurement(timeSinceSeriesStart: 1, precededByGap: false)))
		state.fail(NSError(domain: "Late", code: 1)); state.cancel()
		XCTAssertEqual(completions, 1); XCTAssertEqual(stops, 0)
	}

	func testCancellationStopsOnceAndSuppressesBufferedAndLateResults() {
		var completions = 0, stops = 0
		let state = HealthSeriesReadState(kind: .ecg) { _ in completions += 1 }
		state.installCancellation { stops += 1 }
		state.appendECG(HealthECGMeasurement(timeSinceSampleStart: 0, voltageInMillivolts: 0.5))
		state.cancel(); state.cancel()
		XCTAssertFalse(state.appendECG(HealthECGMeasurement(timeSinceSampleStart: 1, voltageInMillivolts: 1)))
		state.finish(); state.fail(NSError(domain: "Cancelled", code: 1))
		XCTAssertEqual(stops, 1); XCTAssertEqual(completions, 0)
	}

	func testCancellationBeforeTaskRegistrationStopsTheRegisteredTaskImmediately() {
		var stops = 0, completions = 0
		let state = HealthSeriesReadState(kind: .route) { _ in completions += 1 }
		state.cancel()
		state.installCancellation { stops += 1 }
		state.finish()
		XCTAssertEqual(stops, 1); XCTAssertEqual(completions, 0)
	}

	func testFailureStopsReadOnceAndDoesNotReturnAPartialSuccessfulSeries() throws {
		let expected = NSError(domain: "SeriesRead", code: 42)
		var results: [Result<HealthSeriesSnapshot, Error>] = [], stops = 0
		let state = HealthSeriesReadState(kind: .heartbeat) { results.append($0) }
		state.installCancellation { stops += 1 }
		state.appendHeartbeat(HealthHeartbeatMeasurement(timeSinceSeriesStart: 1, precededByGap: false))
		state.fail(expected); state.finish(); state.fail(expected)
		XCTAssertEqual(stops, 1); XCTAssertEqual(results.count, 1)
		XCTAssertThrowsError(try XCTUnwrap(results.first).get()) { XCTAssertEqual(($0 as NSError).code, 42) }
	}

	func testFailureBeforeTaskRegistrationCancelsTheRegisteredTask() {
		var stops = 0, completions = 0
		let state = HealthSeriesReadState(kind: .ecg) { _ in completions += 1 }
		state.fail(NSError(domain: "EarlyReadFailure", code: 1))
		state.installCancellation { stops += 1 }
		state.cancel(); state.finish()
		XCTAssertEqual(stops, 1); XCTAssertEqual(completions, 1)
	}

	func testUnexpectedSeriesValuesFailInsteadOfMixingKinds() throws {
		var result: Result<HealthSeriesSnapshot, Error>?
		let state = HealthSeriesReadState(kind: .ecg) { result = $0 }
		XCTAssertFalse(state.appendHeartbeat(HealthHeartbeatMeasurement(timeSinceSeriesStart: 1, precededByGap: false)))
		XCTAssertThrowsError(try XCTUnwrap(result).get()) {
			XCTAssertEqual($0 as? HealthSeriesReadError, .unexpectedSeriesKind)
		}
	}

	func testUnsupportedSampleFailsWithoutOpeningAHealthStore() throws {
		let type = try XCTUnwrap(HKObjectType.categoryType(forIdentifier: .sleepAnalysis))
		let date = Date(timeIntervalSinceReferenceDate: 12345.875)
		let sample = HKCategorySample(type: type, value: HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue, start: date, end: date)
		var results: [Result<HealthSeriesSnapshot, Error>] = []
		let cancel = HealthSpecializedSeriesReader().read(sample: sample) { results.append($0) }
		cancel()
		XCTAssertEqual(results.count, 1)
		XCTAssertThrowsError(try XCTUnwrap(results.first).get()) {
			XCTAssertEqual($0 as? HealthSeriesReadError, .unsupportedSampleType(type.identifier))
		}
	}

	func testQuantitySeriesRetainsExactIntervalsQuantitiesAndDeliveryOrder() throws {
		let firstQuantity = HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 64.125)
		let secondQuantity = HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 65.875)
		let first = DateInterval(start: Date(timeIntervalSinceReferenceDate: 99.125),
			end: Date(timeIntervalSinceReferenceDate: 99.25))
		let second = DateInterval(start: Date(timeIntervalSinceReferenceDate: 101.875),
			end: Date(timeIntervalSinceReferenceDate: 102.75))
		var result: Result<HealthSeriesSnapshot, Error>?
		let state = HealthSeriesReadState(kind: .quantity) { result = $0 }
		state.appendQuantity(HealthQuantityMeasurement(quantity: firstQuantity, dateInterval: first))
		state.appendQuantity(HealthQuantityMeasurement(quantity: secondQuantity, dateInterval: second))
		state.finish()
		guard case let .quantity(actual) = try XCTUnwrap(result).get() else { return XCTFail("Wrong series kind") }
		XCTAssertEqual(actual.map { $0.dateInterval }, [first, second])
		XCTAssertTrue(actual[0].quantity === firstQuantity); XCTAssertTrue(actual[1].quantity === secondQuantity)
		XCTAssertEqual(actual[0].quantity.doubleValue(for: .count().unitDivided(by: .minute())), 64.125)
	}

	func testQuantitySeriesFailureDoesNotReturnEarlierPointsAsComplete() throws {
		var result: Result<HealthSeriesSnapshot, Error>?, stops = 0
		let state = HealthSeriesReadState(kind: .quantity) { result = $0 }
		state.installCancellation { stops += 1 }
		state.appendQuantity(HealthQuantityMeasurement(quantity: HKQuantity(unit: .count(), doubleValue: 1),
			dateInterval: DateInterval(start: Date(timeIntervalSinceReferenceDate: 1), duration: 0.125)))
		state.fail(HealthSeriesReadError.unexpectedQuantitySample); state.finish()
		XCTAssertThrowsError(try XCTUnwrap(result).get()) {
			XCTAssertEqual($0 as? HealthSeriesReadError, .unexpectedQuantitySample)
		}
		XCTAssertEqual(stops, 1)
	}

	func testCancellationReleasesCapturedCompletionAndStopClosures() {
		final class Probe {}
		weak var completionProbe: Probe?, stopProbe: Probe?
		var state: HealthSeriesReadState!
		autoreleasepool {
			let first = Probe(), second = Probe()
			completionProbe = first; stopProbe = second
			state = HealthSeriesReadState(kind: .ecg) { [first] _ in withExtendedLifetime(first) {} }
			state.installCancellation { [second] in withExtendedLifetime(second) {} }
		}
		XCTAssertNotNil(completionProbe); XCTAssertNotNil(stopProbe)
		state.cancel()
		XCTAssertNil(completionProbe); XCTAssertNil(stopProbe)
	}
}
