import XCTest
import HealthKit
import Samples

private final class HealthAuthorizationStoreProbe: HealthReadAuthorizationStore {
	struct Request {
		let types: Set<HKObjectType>
		let perObject: Bool
		let predicate: NSPredicate?
		let completion: (Bool, Error?) -> Void
	}
	var isHealthDataAvailable = true
	var supportsHealthRecords = true
	var perObjectIdentifiers = Set<String>()
	var onRequest: ((Request) -> Void)?
	private let lock = NSLock()
	private var storedRequests: [Request] = []
	private var classificationCounts: [String: Int] = [:]

	func requests() -> [Request] {
		lock.lock(); defer { lock.unlock() }; return storedRequests
	}
	func classificationCount(for type: HKObjectType) -> Int {
		lock.lock(); defer { lock.unlock() }; return classificationCounts[type.identifier] ?? 0
	}
	func requiresPerObjectAuthorization(for type: HKObjectType) -> Bool {
		lock.lock(); defer { lock.unlock() }
		classificationCounts[type.identifier, default: 0] += 1
		return perObjectIdentifiers.contains(type.identifier)
	}
	func requestReadAuthorization(for types: Set<HKObjectType>, completion: @escaping (Bool, Error?) -> Void) {
		record(Request(types: types, perObject: false, predicate: nil, completion: completion))
	}
	func requestPerObjectReadAuthorization(for type: HKObjectType, predicate: NSPredicate?, completion: @escaping (Bool, Error?) -> Void) {
		record(Request(types: [type], perObject: true, predicate: predicate, completion: completion))
	}
	private func record(_ request: Request) {
		lock.lock(); storedRequests.append(request); let callback = onRequest; lock.unlock()
		callback?(request)
	}
}

private class LegacyHealthAuthorizationProbe: HealthKitUtil {
	private(set) var authorizationCalls = 0
	var authorizationError: Error?
	func getAuthorization(callback: @escaping (Error?) -> Void) {
		authorizationCalls += 1; callback(authorizationError)
	}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? { nil }
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		XCTFail("Authorization must not read records")
		callback(nil, NSError(domain: "UnexpectedAuthorizationRead", code: 1)); return {}
	}
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("Authorization must not calculate statistics")
		callback(nil, NSError(domain: "UnexpectedAuthorizationCalculation", code: 1))
	}
}

private final class SelectedHealthAuthorizationProbe: LegacyHealthAuthorizationProbe, HealthReadAuthorizationProviding {
	private(set) var selectedTypes = Set<HKObjectType>()
	private(set) var selectedPredicate: NSPredicate?
	func requestReadAuthorization(for types: Set<HKObjectType>, predicate: NSPredicate?, callback: @escaping (Error?) -> Void) {
		selectedTypes = types; selectedPredicate = predicate; callback(nil)
	}
}

private final class HealthUnitLookupProbe {
	typealias Completion = ([HKQuantityType: HKUnit], Error?) -> Void
	private let lock = NSLock()
	private var requests: [(Set<HKQuantityType>, Completion)] = []
	var onRequest: (@Sendable () -> Void)?
	func lookup(_ types: Set<HKQuantityType>, completion: @escaping Completion) {
		lock.lock(); requests.append((types, completion)); let callback = onRequest; lock.unlock()
		callback?()
	}
	func snapshot() -> [(Set<HKQuantityType>, Completion)] {
		lock.lock(); defer { lock.unlock() }; return requests
	}
}

final class HealthReadAuthorizationTests: XCTestCase {
	private let steps = HKObjectType.quantityType(forIdentifier: .stepCount)!
	private let mass = HKObjectType.quantityType(forIdentifier: .bodyMass)!

	func testEmptySelectionCompletesWithoutOpeningHealthOrCheckingAvailability() {
		let store = HealthAuthorizationStoreProbe(); store.isHealthDataAvailable = false
		var completions = 0
		HealthReadAuthorizationClient(authorizationStore: store).request(types: []) { error in
			XCTAssertNil(error); completions += 1
		}
		XCTAssertEqual(completions, 1)
		XCTAssertTrue(store.requests().isEmpty)
	}

	func testSelectedTypesAreDeduplicatedAndUnrelatedCatalogTypesAreNeverRequested() {
		let store = HealthAuthorizationStoreProbe()
		var completions = 0
		HealthReadAuthorizationClient(authorizationStore: store).request(types: [steps, steps]) { error in
			XCTAssertNil(error); completions += 1
		}
		let requests = store.requests()
		XCTAssertEqual(requests.count, 1)
		XCTAssertEqual(requests.first?.types, [steps])
		XCTAssertFalse(requests.first?.types.contains(mass) ?? true)
		XCTAssertEqual(store.classificationCount(for: steps), 1)
		XCTAssertEqual(completions, 0)
		requests.first?.completion(true, nil)
		XCTAssertEqual(completions, 1, "Success describes the authorization interaction, not disclosure of read access")
	}

	func testStandardAuthorizationCompletesBeforePerObjectSelectionAndPreservesItsPredicate() throws {
		let vision = HKObjectType.visionPrescriptionType()
		let store = HealthAuthorizationStoreProbe(); store.perObjectIdentifiers = [vision.identifier]
		let predicate = NSPredicate(value: true)
		var completed = false
		HealthReadAuthorizationClient(authorizationStore: store).request(types: [vision, steps], predicate: predicate) { error in
			XCTAssertNil(error); completed = true
		}
		let first = try XCTUnwrap(store.requests().first)
		XCTAssertEqual(first.types, [steps]); XCTAssertFalse(first.perObject)
		XCTAssertFalse(completed)
		first.completion(true, nil)
		let requests = store.requests()
		XCTAssertEqual(requests.count, 2)
		let second = try XCTUnwrap(requests.last)
		XCTAssertEqual(second.types, [vision]); XCTAssertTrue(second.perObject)
		XCTAssertTrue(second.predicate === predicate)
		XCTAssertFalse(completed)
		second.completion(true, nil)
		XCTAssertTrue(completed)
		XCTAssertEqual(store.classificationCount(for: steps), 1)
		XCTAssertEqual(store.classificationCount(for: vision), 1)
	}

	func testUnavailableHealthFailsBeforeAnyAuthorizationSheet() {
		let store = HealthAuthorizationStoreProbe(); store.isHealthDataAvailable = false
		var failure: HealthReadAuthorizationError?
		HealthReadAuthorizationClient(authorizationStore: store).request(types: [steps]) { failure = $0 as? HealthReadAuthorizationError }
		XCTAssertEqual(failure, .healthUnavailable)
		XCTAssertTrue(store.requests().isEmpty)
	}

	func testClinicalRecordsRequireDeviceSupportWithoutBlockingOrdinaryQuantities() throws {
		let clinical = try XCTUnwrap(HKObjectType.clinicalType(forIdentifier: .allergyRecord))
		let store = HealthAuthorizationStoreProbe(); store.supportsHealthRecords = false
		let client = HealthReadAuthorizationClient(authorizationStore: store)
		var failure: HealthReadAuthorizationError?
		client.request(types: [clinical]) { failure = $0 as? HealthReadAuthorizationError }
		XCTAssertEqual(failure, .healthRecordsUnavailable)
		XCTAssertTrue(store.requests().isEmpty)
		client.request(types: [steps]) { XCTAssertNil($0) }
		XCTAssertEqual(store.requests().count, 1)
		XCTAssertEqual(store.requests().first?.types, [steps])
		store.requests().first?.completion(true, nil)
	}

	func testCanceledInteractionStopsBeforeLaterObjectSelection() throws {
		let vision = HKObjectType.visionPrescriptionType()
		let store = HealthAuthorizationStoreProbe(); store.perObjectIdentifiers = [vision.identifier]
		var failures: [HealthReadAuthorizationError?] = []
		HealthReadAuthorizationClient(authorizationStore: store).request(types: [steps, vision]) { failures.append($0 as? HealthReadAuthorizationError) }
		let first = try XCTUnwrap(store.requests().first)
		first.completion(false, nil)
		first.completion(true, nil)
		XCTAssertEqual(failures, [.requestCanceled])
		XCTAssertEqual(store.requests().count, 1)
	}

	func testStoreFailureIsForwardedOnceAndLateSuccessDoesNotOverwriteIt() throws {
		let store = HealthAuthorizationStoreProbe(), expected = NSError(domain: "HealthAuthorizationTest", code: 17)
		var failures: [NSError?] = []
		HealthReadAuthorizationClient(authorizationStore: store).request(types: [steps]) { failures.append($0 as NSError?) }
		let first = try XCTUnwrap(store.requests().first)
		first.completion(false, expected); first.completion(true, nil)
		XCTAssertEqual(failures.count, 1)
		XCTAssertTrue(failures.first! === expected)
	}

	func testDuplicateCallbacksCannotRepeatSheetsOrCompleteAnActiveNewerStep() throws {
		let vision = HKObjectType.visionPrescriptionType()
		let store = HealthAuthorizationStoreProbe(); store.perObjectIdentifiers = [vision.identifier]
		var completions = 0
		HealthReadAuthorizationClient(authorizationStore: store).request(types: [steps, vision]) { error in
			XCTAssertNil(error); completions += 1
		}
		let first = try XCTUnwrap(store.requests().first)
		first.completion(true, nil); first.completion(false, NSError(domain: "Late", code: 1))
		XCTAssertEqual(store.requests().count, 2)
		XCTAssertEqual(completions, 0)
		let second = try XCTUnwrap(store.requests().last)
		second.completion(true, nil); second.completion(false, NSError(domain: "Late", code: 2))
		XCTAssertEqual(completions, 1)
	}

	func testConcurrentDuplicateCallbacksCompleteOnlyOnce() throws {
		let store = HealthAuthorizationStoreProbe(), completionLock = NSLock()
		var completions = 0
		HealthReadAuthorizationClient(authorizationStore: store).request(types: [steps]) { error in
			XCTAssertNil(error)
			completionLock.lock(); completions += 1; completionLock.unlock()
		}
		let request = try XCTUnwrap(store.requests().first)
		DispatchQueue.concurrentPerform(iterations: 16) { _ in request.completion(true, nil) }
		XCTAssertEqual(completions, 1)
	}

	func testCompletedAuthorizationReleasesItsStoreEvenWhenTheCallbackIsRetained() throws {
		for success in [true, false] {
			weak var releasedStore: HealthAuthorizationStoreProbe?
			var finish: ((Bool, Error?) -> Void)?
			autoreleasepool {
				let store = HealthAuthorizationStoreProbe()
				releasedStore = store
				HealthReadAuthorizationClient(authorizationStore: store).request(types: [steps]) { _ in }
				finish = store.requests().first?.completion
			}
			autoreleasepool { XCTAssertNotNil(releasedStore, "An authorization interaction retains its pending operation") }
			let callback = try XCTUnwrap(finish)
			autoreleasepool { callback(success, nil) }
			XCTAssertNil(releasedStore, "A completed request must not retain store/operation/callback cycles")
			callback(!success, nil)
			XCTAssertNil(releasedStore)
		}
	}

	func testLegacyInjectedUtilitiesKeepTheirExistingAuthorizationCallback() {
		let legacy = LegacyHealthAuthorizationProbe()
		let expected = NSError(domain: "LegacyAuthorization", code: 1); legacy.authorizationError = expected
		let utility: HealthKitUtil = legacy
		var received: NSError?
		utility.requestReadAuthorization(for: [steps]) { received = $0 as NSError? }
		XCTAssertEqual(legacy.authorizationCalls, 1)
		XCTAssertTrue(received === expected)
	}

	func testSelectedProviderTakesPrecedenceOverTheLegacyFallback() {
		let provider = SelectedHealthAuthorizationProbe(), predicate = NSPredicate(value: true)
		let utility: HealthKitUtil = provider
		var completed = false
		utility.requestReadAuthorization(for: [steps], predicate: predicate) { error in XCTAssertNil(error); completed = true }
		XCTAssertTrue(completed)
		XCTAssertEqual(provider.selectedTypes, [steps])
		XCTAssertTrue(provider.selectedPredicate === predicate)
		XCTAssertEqual(provider.authorizationCalls, 0)
	}

	@MainActor func testMainQueueUnitLookupReturnsWhileItsCallbackIsPendingAndCoalescesRequests() throws {
		let store = automaticAuthorizationStore(), lookup = HealthUnitLookupProbe()
		let utility = HealthKitUtilImpl(authorizationClient: HealthReadAuthorizationClient(authorizationStore: store), preferredUnitsLookup: lookup.lookup)
		let began = ProcessInfo.processInfo.systemUptime
		XCTAssertNil(utility.preferredUnitFor(.bodyMass))
		XCTAssertLessThan(ProcessInfo.processInfo.systemUptime - began, 1, "The main queue must not wait for a Health callback")
		XCTAssertNil(utility.preferredUnitFor(.bodyMass))
		XCTAssertEqual(lookup.snapshot().count, 1)
		let request = try XCTUnwrap(lookup.snapshot().first)
		XCTAssertEqual(request.0, [mass])
		request.1([mass: .pound()], nil)
		XCTAssertEqual(utility.preferredUnitFor(.bodyMass)?.unitString, HKUnit.pound().unitString)
		XCTAssertEqual(lookup.snapshot().count, 1)
		XCTAssertEqual(store.requests().count, 1)
	}

	@MainActor func testDuplicatePreferredUnitCallbacksCannotChangeTheCapturedCache() throws {
		let store = automaticAuthorizationStore(), lookup = HealthUnitLookupProbe()
		let utility = HealthKitUtilImpl(authorizationClient: HealthReadAuthorizationClient(authorizationStore: store), preferredUnitsLookup: lookup.lookup)
		XCTAssertNil(utility.preferredUnitFor(.bodyMass))
		let request = try XCTUnwrap(lookup.snapshot().first)
		request.1([mass: .gramUnit(with: .kilo)], nil)
		request.1([mass: .pound()], nil)
		XCTAssertEqual(utility.preferredUnitFor(.bodyMass)?.unitString, HKUnit.gramUnit(with: .kilo).unitString)
	}

	@MainActor func testBackgroundUnitLookupWaitsForItsSelectedQuantityAndPopulatesTheMainQueueCache() throws {
		let store = automaticAuthorizationStore(), lookup = HealthUnitLookupProbe()
		let utility = HealthKitUtilImpl(authorizationClient: HealthReadAuthorizationClient(authorizationStore: store), preferredUnitsLookup: lookup.lookup)
		let began = expectation(description: "Preferred unit request began"), returned = expectation(description: "Background lookup returned")
		lookup.onRequest = { began.fulfill() }
		DispatchQueue.global().async {
			XCTAssertEqual(utility.preferredUnitFor(.bodyMass)?.unitString, HKUnit.pound().unitString)
			returned.fulfill()
		}
		wait(for: [began], timeout: 2)
		let request = try XCTUnwrap(lookup.snapshot().first)
		XCTAssertEqual(request.0, [mass])
		request.1([mass: .pound()], nil)
		wait(for: [returned], timeout: 2)
		XCTAssertEqual(utility.preferredUnitFor(.bodyMass)?.unitString, HKUnit.pound().unitString)
		XCTAssertEqual(lookup.snapshot().count, 1)
	}

	@MainActor func testTimedOutUnitCallbackCannotOverwriteANewerRequest() throws {
		let store = automaticAuthorizationStore(), lookup = HealthUnitLookupProbe()
		let utility = HealthKitUtilImpl(authorizationClient: HealthReadAuthorizationClient(authorizationStore: store), preferredUnitsLookup: lookup.lookup)
		let began = expectation(description: "Timed-out request began"), returned = expectation(description: "Bounded background wait returned")
		lookup.onRequest = { began.fulfill() }
		DispatchQueue.global().async {
			XCTAssertNil(utility.preferredUnitFor(.bodyMass))
			returned.fulfill()
		}
		wait(for: [began], timeout: 2)
		wait(for: [returned], timeout: 6)
		lookup.onRequest = nil
		XCTAssertNil(utility.preferredUnitFor(.bodyMass))
		let requests = lookup.snapshot()
		XCTAssertEqual(requests.count, 2)
		let old = try XCTUnwrap(requests.first), fresh = try XCTUnwrap(requests.last)
		fresh.1([mass: .pound()], nil)
		old.1([mass: .gramUnit(with: .kilo)], nil)
		XCTAssertEqual(utility.preferredUnitFor(.bodyMass)?.unitString, HKUnit.pound().unitString)
	}

	func testStatisticsRequestsOnlyItsTypeAndDoesNotExecuteAfterCanceledAuthorization() throws {
		let store = HealthAuthorizationStoreProbe()
		let utility = HealthKitUtilImpl(authorizationClient: HealthReadAuthorizationClient(authorizationStore: store))
		let start = Date(timeIntervalSince1970: 1_700_000_000)
		var result: Double?, failure: HealthReadAuthorizationError?
		utility.calculate(.cumulativeSum, Steps.self, from: start, to: start.addingTimeInterval(60)) {
			result = $0; failure = $1 as? HealthReadAuthorizationError
		}
		let request = try XCTUnwrap(store.requests().first)
		XCTAssertEqual(request.types, Steps.readPermissions)
		request.completion(false, nil)
		XCTAssertNil(result)
		XCTAssertEqual(failure, .requestCanceled)
	}

	private func automaticAuthorizationStore() -> HealthAuthorizationStoreProbe {
		let store = HealthAuthorizationStoreProbe()
		store.onRequest = { $0.completion(true, nil) }
		return store
	}
}
