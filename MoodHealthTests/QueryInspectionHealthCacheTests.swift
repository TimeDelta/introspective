import XCTest
import CoreData
import HealthKit
import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
import Samples

private final class InspectionHealthReadProbe: HealthKitUtil, InjectionProvider {
	let types: [Any.Type] = [HealthKitUtil.self]
	let anchor: Date
	var values: [Double]? = [10, 100]
	var readError: Error?
	var authorizationError: Error?
	var unitError: Error?
	var pressureSamples: [HKSample] = []
	var holdRead = false
	var readStarted: (() -> Void)?
	private var pending: (([HKSample]?, Error?) -> Void)?
	private var pendingType: HealthKitSample.Type?
	private(set) var requests = 0
	private(set) var authorizationRequests = 0
	private(set) var unitRequests = 0
	private(set) var stopRequests = 0
	init(anchor: Date) { self.anchor = anchor }
	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func getAuthorization(callback: @escaping (Error?) -> Void) {
		XCTAssertFalse(Thread.isMainThread)
		authorizationRequests += 1; callback(authorizationError)
	}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		XCTAssertFalse(Thread.isMainThread)
		XCTAssertEqual(QueryReadScope.date, anchor)
		unitRequests += 1
		if let error = unitError { QueryReadScope.recordFailure(error); return nil }
		if typeId == .bloodPressureSystolic { return .millimeterOfMercury() }
		if typeId == .bloodPressureDiastolic { return .pascalUnit(with: .kilo) }
		return typeId == .bodyMass ? HKUnit(from: "kg") : .count()
	}
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {
		XCTAssertEqual(QueryReadScope.date, anchor)
		XCTAssertEqual(QueryReadScope.convertTimeZones, false)
	}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		XCTAssertFalse(Thread.isMainThread); XCTAssertTrue(type == Steps.self || type == Weight.self || type == BloodPressure.self)
		XCTAssertEqual(QueryReadScope.date, anchor)
		requests += 1
		if holdRead { pending = callback; pendingType = type }
		else { callback(samples(for: type), readError) }
		readStarted?()
		return { self.stopRequests += 1 }
	}
	func deliver() {
		let callback = pending; pending = nil
		XCTAssertNotNil(callback)
		guard let type = pendingType else { XCTFail("No pending Health type"); return }
		pendingType = nil
		callback?(samples(for: type), readError)
	}
	private func samples(for type: HealthKitSample.Type) -> [HKSample]? {
		if type == BloodPressure.self { return pressureSamples }
		return values?.enumerated().map { index, value in
			let date = anchor.addingTimeInterval(-Double(index + 1))
			let isWeight = type == Weight.self
			return HKQuantitySample(type: isWeight ? Weight.quantityType : Steps.quantityType,
				quantity: HKQuantity(unit: isWeight ? HKUnit(from: "kg") : .count(), doubleValue: value),
				start: date, end: date)
		}
	}
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("Inspection must use raw sample reads")
		callback(nil, GenericError("Unexpected aggregate read"))
	}
}

private final class InspectionThrowingHealthFilter: BooleanExpression {
	var description: String { "Test filter" }
	func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool { throw NSError(domain: "InspectionFilter", code: 9) }
	func isValid() -> Bool { true }
	func copy() -> BooleanExpression { InspectionThrowingHealthFilter() }
	func equalTo(_ other: BooleanExpression) -> Bool { other is InspectionThrowingHealthFilter }
	func predicate() -> NSPredicate? { nil }
}

final class QueryInspectionHealthCacheTests: XCTestCase {
	private let anchor = Date(timeIntervalSince1970: 1_700_000_000.123456)
	private var probe: InspectionHealthReadProbe!

	override func setUp() {
		super.setUp()
		probe = InspectionHealthReadProbe(anchor: anchor)
		DependencyInjector.register([CommonInjectionProvider(), probe])
	}

	private func environment(cache: Bool = true, cancelled: @escaping () -> Bool = { false }) -> QueryReadContext {
		QueryReadContext(context: NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType),
			date: anchor, convertTimeZones: false, cacheHealthResults: cache, isCancelled: cancelled)
	}
	private func query(_ expression: BooleanExpression? = nil, in environment: QueryReadContext) throws -> StepsQueryImpl {
		let query = StepsQueryImpl(); query.expression = expression
		try configureReadContext(query, context: environment)
		return query
	}
	private func counts(_ result: QueryResult?) -> [Double] {
		(result?.samples.compactMap { ($0 as? Steps)?.steps } ?? []).sorted()
	}

	func testInspectionReusesUnfilteredSamplesAcrossDifferentConditionsAndLaterHealthChanges() throws {
		let environment = environment()
		let first = try query(GreaterThanDoubleAttributeRestriction(restrictedAttribute: Steps.stepCount, value: 50), in: environment)
		let second = try query(in: environment)
		let done = expectation(description: "Both filters use one captured read")
		environment.perform {
			XCTAssertNil(environment.capturedHealthUnit(for: Steps.self))
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(self.counts(result), [100])
				XCTAssertEqual(environment.capturedHealthUnit(for: Steps.self), HKUnit.count().unitString)
				self.probe.values = [999]
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertEqual(self.counts(result), [10, 100])
					XCTAssertEqual(self.probe.requests, 1)
					XCTAssertEqual(self.probe.authorizationRequests, 1); XCTAssertEqual(self.probe.unitRequests, 1)
					XCTAssertEqual(environment.capturedHealthUnit(for: Steps.self), HKUnit.count().unitString)
					XCTAssertFalse(Thread.isMainThread); XCTAssertEqual(QueryReadScope.date, self.anchor)
					done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testCapturedQuantityUnitSurvivesGlobalUnitChangesBeforeHealthDeliveryAndCachedFiltering() throws {
		let environment = environment()
		let first = WeightQueryImpl(), second = WeightQueryImpl()
		second.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: 100)
		try configureReadContext(first, context: environment); try configureReadContext(second, context: environment)
		let done = expectation(description: "Quantity mapping uses its captured unit")
		environment.perform {
			let previousUnit = Weight.unit
			self.probe.holdRead = true; self.probe.values = [70]
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error)
				let weight = result?.samples.first as? Weight
				XCTAssertEqual(weight?.weight ?? .nan, 70, accuracy: 1e-10)
				XCTAssertEqual(environment.capturedHealthUnit(for: Weight.self), HKUnit(from: "kg").unitString)
				XCTAssertEqual(Weight.unit.unitString, HKUnit(from: "lb").unitString)
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertNotNil(result); XCTAssertEqual(result?.samples.count, 0)
					XCTAssertEqual(self.probe.requests, 1); XCTAssertEqual(self.probe.unitRequests, 1)
					XCTAssertEqual(environment.capturedHealthUnit(for: Weight.self), HKUnit(from: "kg").unitString)
					Weight.unit = previousUnit; done.fulfill()
				}
			}
			environment.perform {
				XCTAssertEqual(environment.capturedHealthUnit(for: Weight.self), HKUnit(from: "kg").unitString)
				// Simulate another query or a Health preferred-unit update during
				// the asynchronous raw read. 70 kg must never become 154.3 pounds
				// while the inspector labels and compares the value as kilograms.
				Weight.unit = HKUnit(from: "lb")
				self.probe.deliver()
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testBloodPressureCapturesBothPreferredUnitsBeforePendingDeliveryAndCachedConditions() throws {
		let oldSystolic = BloodPressure.systolicUnit, oldDiastolic = BloodPressure.diastolicUnit
		defer { BloodPressure.systolicUnit = oldSystolic; BloodPressure.diastolicUnit = oldDiastolic }
		let systolic = HKQuantitySample(type: BloodPressure.systolicQuantityType,
			quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 120), start: anchor, end: anchor)
		let diastolic = HKQuantitySample(type: BloodPressure.diastolicQuantityType,
			quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 80), start: anchor, end: anchor)
		let correlation = HKCorrelation(type: BloodPressure.correlationType, start: anchor, end: anchor, objects: [systolic, diastolic])
		let environment = environment()
		let first = BloodPressureQueryImpl(), second = BloodPressureQueryImpl()
		second.expression = AndExpression(
			GreaterThanDoubleAttributeRestriction(restrictedAttribute: BloodPressure.systolic, value: 100),
			LessThanDoubleAttributeRestriction(restrictedAttribute: BloodPressure.diastolic, value: 20))
		try configureReadContext(first, context: environment); try configureReadContext(second, context: environment)
		let done = expectation(description: "Both pressure values keep independent read units")
		environment.perform {
			self.probe.holdRead = true; self.probe.pressureSamples = [correlation]
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error)
				let pressure = result?.samples.first as? BloodPressure
				XCTAssertEqual(pressure?.systolic ?? .nan, 120, accuracy: 1e-8)
				XCTAssertEqual(pressure?.diastolic ?? .nan,
					diastolic.quantity.doubleValue(for: .pascalUnit(with: .kilo)), accuracy: 1e-8)
				XCTAssertEqual(pressure?.sourceIdentifier, correlation.uuid)
				XCTAssertNil(environment.capturedHealthUnit(for: BloodPressure.self), "A two-value correlation must not claim a single shared unit")
				XCTAssertEqual(environment.capturedHealthUnit(for: BloodPressure.self, attributeID: BloodPressure.systolic.id), HKUnit.millimeterOfMercury().unitString)
				XCTAssertEqual(environment.capturedHealthUnit(for: BloodPressure.self, attributeID: BloodPressure.diastolic.id), HKUnit.pascalUnit(with: .kilo).unitString)
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 1)
					XCTAssertEqual(self.probe.requests, 1); XCTAssertEqual(self.probe.unitRequests, 2)
					XCTAssertEqual(environment.capturedHealthUnit(for: BloodPressure.self, attributeID: BloodPressure.systolic.id), HKUnit.millimeterOfMercury().unitString)
					XCTAssertEqual(environment.capturedHealthUnit(for: BloodPressure.self, attributeID: BloodPressure.diastolic.id), HKUnit.pascalUnit(with: .kilo).unitString)
					done.fulfill()
				}
			}
			environment.perform {
				BloodPressure.systolicUnit = .pascal(); BloodPressure.diastolicUnit = .millimeterOfMercury()
				self.probe.deliver()
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testBloodPressureReadWithoutPressureComponentsFailsSafelyAndDoesNotRetry() throws {
		let oldSystolic = BloodPressure.systolicUnit, oldDiastolic = BloodPressure.diastolicUnit
		defer { BloodPressure.systolicUnit = oldSystolic; BloodPressure.diastolicUnit = oldDiastolic }
		let sugarType = HKQuantityType.quantityType(forIdentifier: .dietarySugar)!
		let sugar = HKQuantitySample(type: sugarType, quantity: HKQuantity(unit: .gram(), doubleValue: 3), start: anchor, end: anchor)
		let food = HKCorrelation(type: HKCorrelationType.correlationType(forIdentifier: .food)!, start: anchor, end: anchor, objects: [sugar])
		let environment = environment()
		let first = BloodPressureQueryImpl(), second = BloodPressureQueryImpl()
		try configureReadContext(first, context: environment); try configureReadContext(second, context: environment)
		let done = expectation(description: "Malformed pressure read remains an error")
		environment.perform {
			self.probe.pressureSamples = [food]
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(result); XCTAssertNotNil(error); XCTAssertFalse(error is NoSamplesFoundQueryError)
				self.probe.pressureSamples = []
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(result); XCTAssertNotNil(error); XCTAssertFalse(error is NoSamplesFoundQueryError)
					XCTAssertEqual(self.probe.requests, 1); done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testDefaultReadContextStillFetchesFreshHealthDataForEachQuery() throws {
		let environment = environment(cache: false)
		let first = try query(in: environment), second = try query(in: environment)
		let done = expectation(description: "Caching remains opt in")
		environment.perform {
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(self.counts(result), [10, 100]); self.probe.values = [999]
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertEqual(self.counts(result), [999])
					XCTAssertEqual(self.probe.requests, 2); XCTAssertEqual(self.probe.authorizationRequests, 2)
					XCTAssertNil(environment.capturedHealthUnit(for: Steps.self), "Unit labels are inspection scoped, just like the cached values")
					done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testANewInspectionContextCapturesFreshDataInsteadOfSharingAnotherSnapshotsCache() throws {
		let old = environment(), fresh = environment()
		let first = try query(in: old), second = try query(in: fresh)
		let done = expectation(description: "Independent inspections take independent snapshots")
		old.perform {
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(self.counts(result), [10, 100])
				self.probe.values = [999]
				fresh.perform {
					second.runQuery { (result: QueryResult?, error: Error?) in
						XCTAssertNil(error); XCTAssertEqual(self.counts(result), [999])
						XCTAssertEqual(self.probe.requests, 2); done.fulfill()
					}
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testSameTypeRootAndSubqueryCoalescePendingReadsBeforeEitherFinishes() throws {
		let environment = environment()
		let root = try query(in: environment)
		let child = try query(GreaterThanDoubleAttributeRestriction(restrictedAttribute: Steps.stepCount, value: 50), in: environment)
		root.subQuery = (SameStartDatesSubQueryMatcher(), child)
		let done = expectation(description: "One pending read supplies both query nodes")
		environment.perform {
			self.probe.holdRead = true
			root.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(self.counts(result), [100])
				XCTAssertEqual(self.probe.requests, 1); XCTAssertEqual(self.probe.authorizationRequests, 1)
				done.fulfill()
			}
			// Authorization and raw-result delivery intentionally return through
			// this context, so queue a delivery after the authorization work.
			environment.perform { self.probe.deliver() }
		}
		wait(for: [done], timeout: 5)
	}

	func testReadFailureIsStableAcrossConditionsInsteadOfRetryingAgainstChangedData() throws {
		let environment = environment()
		let first = try query(in: environment), second = try query(in: environment)
		let done = expectation(description: "Read error reused")
		environment.perform {
			self.probe.readError = NSError(domain: "InspectionRead", code: 17)
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(result); XCTAssertEqual((error as NSError?)?.code, 17); self.probe.readError = nil
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(result); XCTAssertEqual((error as NSError?)?.domain, "InspectionRead")
					XCTAssertEqual((error as NSError?)?.code, 17); XCTAssertEqual(self.probe.requests, 1)
					done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testMissingHealthVisibilityRemainsAmbiguousAndIsNotReplacedByALaterRead() throws {
		let environment = environment()
		let first = try query(in: environment), second = try query(in: environment)
		let done = expectation(description: "Nil Health sample visibility captured")
		environment.perform {
			self.probe.values = nil
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(result); XCTAssertTrue(error is NoHealthKitSamplesFoundQueryError); self.probe.values = [999]
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(result); XCTAssertTrue(error is NoHealthKitSamplesFoundQueryError)
					XCTAssertEqual(self.probe.requests, 1); done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testAnEmptySuccessfulReadIsCachedAsEmptyRatherThanAnError() throws {
		let environment = environment()
		let first = try query(in: environment), second = try query(in: environment)
		let done = expectation(description: "Empty captured result")
		environment.perform {
			self.probe.values = []
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertNotNil(result); XCTAssertEqual(result?.samples.count, 0); self.probe.values = [999]
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertNotNil(result); XCTAssertEqual(result?.samples.count, 0)
					XCTAssertEqual(self.probe.requests, 1); done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testAConditionEvaluationFailureDoesNotPoisonTheUnfilteredCapture() throws {
		let environment = environment()
		let first = try query(InspectionThrowingHealthFilter(), in: environment), second = try query(in: environment)
		let done = expectation(description: "Failed filter does not replace successful capture")
		environment.perform {
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(result); XCTAssertEqual((error as NSError?)?.domain, "InspectionFilter")
				second.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertEqual(self.counts(result), [10, 100])
					XCTAssertEqual(self.probe.requests, 1); done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testAuthorizationAndUnitFailuresAreCachedWithoutStartingASampleRead() throws {
		for unitFailure in [false, true] {
			let environment = environment()
			let first = try query(in: environment), second = try query(in: environment)
			let done = expectation(description: "Pre-read failure captured")
			environment.perform {
				self.probe.authorizationError = unitFailure ? nil : NSError(domain: "InspectionAuthorization", code: 18)
				self.probe.unitError = unitFailure ? NSError(domain: "InspectionUnit", code: 19) : nil
				first.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(result); XCTAssertEqual((error as NSError?)?.code, unitFailure ? 19 : 18)
					XCTAssertNil(environment.capturedHealthUnit(for: Steps.self), "Failed unit reads cannot claim a captured unit")
					self.probe.authorizationError = nil; self.probe.unitError = nil
					second.runQuery { (result: QueryResult?, error: Error?) in
						XCTAssertNil(result); XCTAssertEqual((error as NSError?)?.code, unitFailure ? 19 : 18)
						XCTAssertEqual(self.probe.requests, 0); done.fulfill()
					}
				}
			}
			wait(for: [done], timeout: 5)
		}
	}

	func testCancellationBeforeCachedReuseDoesNotPublishOrStartAnotherRead() throws {
		let lock = NSLock(); var cancelled = false
		let environment = environment(cancelled: { lock.lock(); defer { lock.unlock() }; return cancelled })
		let first = try query(in: environment), second = try query(in: environment)
		let done = expectation(description: "Cancelled cached query rejected")
		environment.perform {
			first.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(self.counts(result), [10, 100])
				lock.lock(); cancelled = true; lock.unlock()
				var callbacks = 0
				second.runQuery { (result: QueryResult?, error: Error?) in callbacks += 1 }
				XCTAssertEqual(callbacks, 0); XCTAssertEqual(self.probe.requests, 1); done.fulfill()
			}
		}
		wait(for: [done], timeout: 5)
	}

	func testCancellationOfPendingReadStopsItAndDiscardsItsLateResult() throws {
		let lock = NSLock(); var cancelled = false
		let environment = environment(cancelled: { lock.lock(); defer { lock.unlock() }; return cancelled })
		let first = try query(in: environment)
		let done = expectation(description: "Pending cancelled read drained")
		environment.perform {
			self.probe.holdRead = true
			var callbacks = 0
			first.runQuery { (result: QueryResult?, error: Error?) in callbacks += 1 }
			environment.perform {
				lock.lock(); cancelled = true; lock.unlock()
				first.stop(); self.probe.deliver()
				environment.perform {
					XCTAssertEqual(callbacks, 0); XCTAssertEqual(self.probe.requests, 1)
					XCTAssertEqual(self.probe.stopRequests, 1); done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
	}
}
