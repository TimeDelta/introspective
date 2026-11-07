import XCTest
import CoreData
import HealthKit
import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import Samples
@testable import Persistence
@testable import Queries

private enum QueryHeightDefinition: HealthCatalogDefinition {
	static let catalogEntry = HealthTypeDescriptor(id: 30_000,
		identifier: HKQuantityTypeIdentifier.height.rawValue, name: "Query height", group: "Measurements",
		family: .quantity, minimumOS: "8.0", canonicalUnit: "m")
}
private enum QueryFutureDefinition: HealthCatalogDefinition {
	static let catalogEntry = HealthTypeDescriptor(id: 30_001,
		identifier: HKQuantityTypeIdentifier.height.rawValue, name: "Future measurement", group: "Measurements",
		family: .quantity, minimumOS: "9999.0", canonicalUnit: "m")
}
private enum QueryIncompatibleUnitDefinition: HealthCatalogDefinition {
	static let catalogEntry = HealthTypeDescriptor(id: 30_002,
		identifier: HKQuantityTypeIdentifier.height.rawValue, name: "Malformed height unit", group: "Measurements",
		family: .quantity, minimumOS: "8.0", canonicalUnit: "kg")
}
private enum QueryMindfulDefinition: HealthCatalogDefinition {
	static let catalogEntry = HealthTypeDescriptor(id: 30_003,
		identifier: HKCategoryTypeIdentifier.mindfulSession.rawValue, name: "Mindful session", group: "Mindfulness",
		family: .category, minimumOS: "10.0", categoryValues: [0: "Recorded"])
}

private class CatalogQueryReadProbe: HealthKitUtil, InjectionProvider {
	let types: [Any.Type] = [HealthKitUtil.self]
	var authorizationCallbacks: [(Error?) -> Void] = []
	var sampleCallbacks: [([HKSample]?, Error?) -> Void] = []
	var requestedTypes: [HealthKitSample.Type] = []
	var requestedPredicates: [NSPredicate?] = []
	var stopCounts: [Int] = []
	var automaticallyAuthorizes = true
	var legacyAuthorizationCount = 0
	var preferredUnit: HKUnit? = .meter()
	var onRead: (() -> Void)?
	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func getAuthorization(callback: @escaping (Error?) -> Void) {
		legacyAuthorizationCount += 1
		authorizationCallbacks.append(callback)
		if automaticallyAuthorizes { callback(nil) }
	}
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? { preferredUnit }
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("A catalog query must read records, not a lossy aggregate")
		callback(nil, GenericError("Unexpected aggregate read"))
	}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		XCTAssertNil(startDate); XCTAssertNil(endDate)
		let index = sampleCallbacks.count
		requestedTypes.append(type); requestedPredicates.append(predicate)
		sampleCallbacks.append(callback); stopCounts.append(0)
		onRead?()
		return { self.stopCounts[index] += 1 }
	}
}

private final class CatalogSelectedReadProbe: CatalogQueryReadProbe, HealthReadAuthorizationProviding {
	private(set) var permissions: [Set<HKObjectType>] = []
	private(set) var authorizationPredicates: [NSPredicate?] = []
	func requestReadAuthorization(for types: Set<HKObjectType>, predicate: NSPredicate?, callback: @escaping (Error?) -> Void) {
		permissions.append(types); authorizationPredicates.append(predicate)
		authorizationCallbacks.append(callback)
		if automaticallyAuthorizes { callback(nil) }
	}
}

private final class CatalogQueryThrowingFilter: BooleanExpression {
	var description: String { "A failing local filter" }
	func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool { throw GenericError("Filter failed") }
	func isValid() -> Bool { true }
	func copy() -> BooleanExpression { CatalogQueryThrowingFilter() }
	func equalTo(_ other: BooleanExpression) -> Bool { other is CatalogQueryThrowingFilter }
	func predicate() -> NSPredicate? { nil }
}

private final class CatalogThrowingCategoryQuery: HealthKitQuery<HealthCategory<QueryMindfulDefinition>> {
	private(set) var decodeCount = 0
	override func initFromHKSample(_ sample: HKSample) throws -> HealthCategory<QueryMindfulDefinition> {
		decodeCount += 1
		throw GenericError("The recorded category could not be decoded")
	}
}

private final class CatalogThrowingQuantityQuery: HealthKitQuery<HealthQuantity<QueryHeightDefinition>> {
	private(set) var decodeCount = 0
	override func initFromHKSample(_ sample: HKSample) throws -> HealthQuantity<QueryHeightDefinition> {
		decodeCount += 1
		throw GenericError("The recorded quantity could not be decoded")
	}
}

private final class CatalogQueryDatabaseProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self]
	let database: Database
	init(_ database: Database) { self.database = database }
	func get<Value>(_ type: Value.Type) throws -> Value { database as! Value }
}

final class HealthCatalogQueryTests: XCTestCase {
	private typealias Height = HealthQuantity<QueryHeightDefinition>
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: HealthCatalogQueryTests.self)])!
	private let instant = Date(timeIntervalSinceReferenceDate: 700_000_000.875)
	private var probe: CatalogSelectedReadProbe!
	override func setUp() {
		super.setUp()
		probe = CatalogSelectedReadProbe()
		DependencyInjector.register([CommonInjectionProvider(), probe])
	}
	private func height(_ value: Double = 1.75, date: Date? = nil) -> HKQuantitySample {
		HKQuantitySample(type: HKObjectType.quantityType(forIdentifier: .height)!,
			quantity: HKQuantity(unit: .meter(), doubleValue: value), start: date ?? instant,
			end: (date ?? instant).addingTimeInterval(0.125), metadata: ["Synthetic source note": "Unmodified record"])
	}

	func testCatalogReadRequestsOnlyItsSelectedPermissionsAndPreservesTheOriginalRecord() {
		let original = height()
		let query = CatalogHealthKitQuery<Height>()
		var completions = 0
		query.runQuery { (result: QueryResult?, error: Error?) in
			completions += 1; XCTAssertNil(error)
			let wrapped = result?.samples.first as? Height
			XCTAssertEqual(wrapped?.sourceIdentifier, original.uuid)
			XCTAssertTrue(wrapped?.originalHealthSample === original)
			XCTAssertEqual(wrapped?.dates()[.start], original.startDate)
			XCTAssertEqual(wrapped?.dates()[.end], original.endDate)
			XCTAssertEqual(wrapped?.originalHealthSample?.metadata?["Synthetic source note"] as? String, "Unmodified record")
		}
		XCTAssertEqual(probe.permissions, [Height.readPermissions])
		XCTAssertEqual(probe.legacyAuthorizationCount, 0)
		XCTAssertTrue(probe.authorizationPredicates.allSatisfy { $0 == nil })
		XCTAssertEqual(probe.requestedTypes.count, 1)
		XCTAssertTrue(probe.requestedTypes.first == Height.self)
		probe.sampleCallbacks[0]([original], nil)
		XCTAssertEqual(completions, 1)
	}

	func testLegacyInjectedUtilitiesStillAuthorizeThroughTheirOriginalCallbackInterface() {
		let legacy = CatalogQueryReadProbe()
		DependencyInjector.register([CommonInjectionProvider(), legacy])
		let query = CatalogHealthKitQuery<Height>()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in completed = true; XCTAssertNil(error) }
		XCTAssertEqual(legacy.legacyAuthorizationCount, 1)
		legacy.sampleCallbacks[0]([height()], nil)
		XCTAssertTrue(completed)
	}

	func testDuplicateAuthorizationCallbacksCannotStartDuplicateReadsOrReplaceTheFirstDecision() {
		probe.automaticallyAuthorizes = false
		let query = CatalogHealthKitQuery<Height>()
		var completions = 0
		query.runQuery { (result: QueryResult?, error: Error?) in completions += 1; XCTAssertNil(error) }
		probe.authorizationCallbacks[0](nil)
		probe.authorizationCallbacks[0](nil)
		probe.authorizationCallbacks[0](GenericError("Late authorization failure"))
		XCTAssertEqual(probe.requestedTypes.count, 1)
		XCTAssertEqual(completions, 0)
		probe.sampleCallbacks[0]([height()], nil)
		XCTAssertEqual(completions, 1)
	}

	func testAuthorizationFailureDoesNotReadRecordsOrBecomeAnEmptySuccessfulResult() {
		probe.automaticallyAuthorizes = false
		let query = CatalogHealthKitQuery<Height>()
		let failure = NSError(domain: "SelectedHealthAuthorization", code: 8)
		var completions = 0
		query.runQuery { (result: QueryResult?, error: Error?) in
			completions += 1; XCTAssertNil(result); XCTAssertEqual(error as NSError?, failure)
		}
		probe.authorizationCallbacks[0](failure)
		probe.authorizationCallbacks[0](nil)
		XCTAssertTrue(probe.sampleCallbacks.isEmpty)
		XCTAssertEqual(completions, 1)
	}

	func testStoppingWhileAuthorizationIsPendingPreventsAHealthReadAndClientCompletion() {
		probe.automaticallyAuthorizes = false
		let query = CatalogHealthKitQuery<Height>()
		query.runQuery { (result: QueryResult?, error: Error?) in XCTFail("A stopped query must not complete") }
		query.stop(); probe.authorizationCallbacks[0](nil)
		XCTAssertTrue(probe.sampleCallbacks.isEmpty)
	}

	func testStoppingAPendingReadStopsItsStoreOperationOnceAndIgnoresLateDelivery() {
		let query = CatalogHealthKitQuery<Height>()
		query.runQuery { (result: QueryResult?, error: Error?) in XCTFail("A stopped query must not complete") }
		query.stop(); query.stop()
		XCTAssertEqual(probe.stopCounts, [1])
		probe.sampleCallbacks[0]([height()], nil)
		XCTAssertEqual(probe.stopCounts, [1])
	}

	func testStopDuringSynchronousReadStartupStillStopsTheReturnedHandleExactlyOnce() {
		let query = CatalogHealthKitQuery<Height>()
		probe.onRead = { query.stop() }
		query.runQuery { (result: QueryResult?, error: Error?) in XCTFail("A stopped query must not complete") }
		XCTAssertEqual(probe.stopCounts, [1])
		probe.onRead = nil
	}

	func testDuplicateAndLateRecordCallbacksDoNotCompleteTwice() {
		let query = CatalogHealthKitQuery<Height>()
		var completions = 0
		query.runQuery { (result: QueryResult?, error: Error?) in completions += 1; XCTAssertNil(error) }
		probe.sampleCallbacks[0]([height()], nil)
		probe.sampleCallbacks[0](nil, GenericError("Late read failure"))
		probe.sampleCallbacks[0]([], nil)
		XCTAssertEqual(completions, 1)
	}

	func testRestartingAQueryStopsTheOldOperationAndIgnoresItsOldRecords() {
		let query = CatalogHealthKitQuery<Height>()
		query.runQuery { (result: QueryResult?, error: Error?) in XCTFail("The replaced run must not complete") }
		var completions = 0
		query.runQuery { (result: QueryResult?, error: Error?) in
			completions += 1; XCTAssertNil(error)
			XCTAssertEqual((result?.samples.first as? Height)?.quantityValue() ?? .nan, 1.9, accuracy: 1e-12)
		}
		XCTAssertEqual(probe.stopCounts, [1, 0])
		probe.sampleCallbacks[0]([height(1.6)], nil)
		XCTAssertEqual(completions, 0)
		probe.sampleCallbacks[1]([height(1.9)], nil)
		XCTAssertEqual(completions, 1)
	}

	func testACompletionMayStartANewRunWithoutTheOldHandleStoppingTheNewRead() {
		let query = CatalogHealthKitQuery<Height>()
		var completions = 0
		query.runQuery { (result: QueryResult?, error: Error?) in
			completions += 1
			query.runQuery { (result: QueryResult?, error: Error?) in completions += 1; XCTAssertNil(error) }
		}
		probe.sampleCallbacks[0]([height()], nil)
		XCTAssertEqual(probe.sampleCallbacks.count, 2)
		probe.sampleCallbacks[0]([height()], nil)
		probe.sampleCallbacks[1]([height()], nil)
		XCTAssertEqual(completions, 2)
		XCTAssertEqual(probe.stopCounts, [0, 0])
	}

	func testWrongHealthRecordTypeFailsWithoutForcedCastingOrPartialResults() {
		let query = CatalogHealthKitQuery<Height>()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in completed = true; XCTAssertNil(result); XCTAssertNotNil(error) }
		let weight = HKQuantitySample(type: Weight.quantityType, quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 70),
			start: instant, end: instant)
		probe.sampleCallbacks[0]([height(), weight], nil)
		XCTAssertTrue(completed)
	}

	func testIncompatibleCapturedUnitFailsBeforeHealthKitQuantityConversion() {
		let query = CatalogHealthKitQuery<HealthQuantity<QueryIncompatibleUnitDefinition>>()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in completed = true; XCTAssertNil(result); XCTAssertNotNil(error) }
		probe.sampleCallbacks[0]([height()], nil)
		XCTAssertTrue(completed)
	}

	func testFutureTypeFailsBeforeConstructingAnUnavailableHealthObjectOrRequestingAccess() {
		let query = CatalogHealthKitQuery<HealthQuantity<QueryFutureDefinition>>()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in
			completed = true; XCTAssertNil(result)
			guard let failure = error as? HealthCatalogError, case .unavailable = failure else {
				XCTFail("Expected an availability error"); return
			}
		}
		XCTAssertTrue(completed); XCTAssertTrue(probe.permissions.isEmpty); XCTAssertTrue(probe.sampleCallbacks.isEmpty)
	}

	func testReadableEmptySelectionIsSuccessfulAndDoesNotClaimReadPermissionWasDenied() {
		let query = CatalogHealthKitQuery<Height>()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in
			completed = true; XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 0)
		}
		probe.sampleCallbacks[0]([], nil)
		XCTAssertTrue(completed)
	}

	func testStoreFailureAndMissingResponseRemainDistinctFromAnEmptySuccessfulRead() {
		for useError in [false, true] {
			let query = CatalogHealthKitQuery<Height>()
			var completed = false
			query.runQuery { (result: QueryResult?, error: Error?) in
				completed = true; XCTAssertNil(result); XCTAssertNotNil(error)
				XCTAssertEqual(error is NoHealthKitSamplesFoundQueryError, !useError)
			}
			probe.sampleCallbacks.last?(nil, useError ? GenericError("Health read failed") : nil)
			XCTAssertTrue(completed)
		}
	}

	func testThrowingLocalFilterDoesNotTurnAnInvalidEvaluationIntoPartialResults() {
		let query = CatalogHealthKitQuery<Height>(); query.expression = CatalogQueryThrowingFilter()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in completed = true; XCTAssertNil(result); XCTAssertNotNil(error) }
		probe.sampleCallbacks[0]([height()], nil)
		XCTAssertTrue(completed)
	}

	func testCategoryQueryPreservesItsOriginalRecordAndUsesItsTypedDecoder() throws {
		typealias Mindful = HealthCategory<QueryMindfulDefinition>
		let original = HKCategorySample(type: HKObjectType.categoryType(forIdentifier: .mindfulSession)!, value: 0,
			start: instant, end: instant.addingTimeInterval(120))
		let query = CatalogHealthKitQuery<Mindful>()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in
			completed = true; XCTAssertNil(error)
			let wrapped = result?.samples.first as? Mindful
			XCTAssertTrue(wrapped?.originalHealthSample === original)
			XCTAssertEqual(wrapped?.sourceIdentifier, original.uuid)
		}
		probe.sampleCallbacks[0]([original], nil)
		XCTAssertTrue(completed)
	}

	func testWrongCategoryTypeIsRejectedBeforeTheCatalogDecoder() {
		let query = CatalogHealthKitQuery<HealthCategory<QueryMindfulDefinition>>()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in completed = true; XCTAssertNil(result); XCTAssertNotNil(error) }
		let wrong = HKCategorySample(type: Sleep.categoryType, value: HKCategoryValueSleepAnalysis.awake.rawValue,
			start: instant, end: instant)
		probe.sampleCallbacks[0]([wrong], nil)
		XCTAssertTrue(completed)
	}

	func testThrowingCatalogDecoderFailsTheWholeReadRatherThanReturningPartialRecords() {
		let query = CatalogThrowingCategoryQuery()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in completed = true; XCTAssertNil(result); XCTAssertNotNil(error) }
		let original = HKCategorySample(type: HKObjectType.categoryType(forIdentifier: .mindfulSession)!, value: 0,
			start: instant, end: instant.addingTimeInterval(120))
		probe.sampleCallbacks[0]([original, original], nil)
		XCTAssertTrue(completed); XCTAssertEqual(query.decodeCount, 1)
	}

	func testQuantityCatalogQueryUsesItsThrowingDecoderRatherThanTheLegacyInitializer() {
		let query = CatalogThrowingQuantityQuery()
		var completed = false
		query.runQuery { (result: QueryResult?, error: Error?) in completed = true; XCTAssertNil(result); XCTAssertNotNil(error) }
		probe.sampleCallbacks[0]([height(), height()], nil)
		XCTAssertTrue(completed); XCTAssertEqual(query.decodeCount, 1)
	}

	func testSharedReadContextKeepsTheCompleteTypeSnapshotForDifferentLocalConditions() throws {
		let context = QueryReadContext(context: NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType),
			date: instant, convertTimeZones: false, cacheHealthResults: true)
		let restricted = CatalogHealthKitQuery<Height>(), complete = CatalogHealthKitQuery<Height>()
		restricted.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: Height.defaultDependentAttribute, value: 1.8)
		try configureReadContext(restricted, context: context); try configureReadContext(complete, context: context)
		let done = expectation(description: "Both conditions use the full captured records")
		probe.onRead = { self.probe.sampleCallbacks[0]([self.height(1.7), self.height(1.9)], nil) }
		context.perform {
			restricted.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 1)
				complete.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 2)
					XCTAssertEqual(self.probe.sampleCallbacks.count, 1)
					XCTAssertTrue(self.probe.requestedPredicates.allSatisfy { $0 == nil })
					done.fulfill()
				}
			}
		}
		wait(for: [done], timeout: 5)
		probe.onRead = nil
	}

	func testPendingSharedReadCoalescesLeavesWithDifferentDateConditions() throws {
		let context = QueryReadContext(context: NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType),
			date: instant, convertTimeZones: false, cacheHealthResults: true)
		let before = CatalogHealthKitQuery<Height>(), after = CatalogHealthKitQuery<Height>()
		let boundary = instant.addingTimeInterval(60)
		before.expression = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: Height.defaultIndependentAttribute, date: boundary)
		after.expression = AfterDateAndTimeAttributeRestriction(restrictedAttribute: Height.defaultIndependentAttribute, date: boundary)
		try configureReadContext(before, context: context); try configureReadContext(after, context: context)
		let early = height(date: instant), late = height(date: instant.addingTimeInterval(120))
		let done = expectation(description: "Pending date conditions share a complete record set")
		done.expectedFulfillmentCount = 2
		probe.onRead = {
			after.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 1)
				XCTAssertEqual(result?.samples.first?.dates()[.start], late.startDate)
				done.fulfill()
			}
			self.probe.sampleCallbacks[0]([early, late], nil)
		}
		context.perform {
			before.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 1)
				XCTAssertEqual(result?.samples.first?.dates()[.start], early.startDate)
				done.fulfill()
			}
		}
		wait(for: [done], timeout: 5)
		probe.onRead = nil
		XCTAssertEqual(probe.permissions, [Height.readPermissions])
		XCTAssertEqual(probe.sampleCallbacks.count, 1)
		XCTAssertTrue(probe.requestedPredicates.allSatisfy { $0 == nil })
		XCTAssertTrue(probe.authorizationPredicates.allSatisfy { $0 == nil })
	}

	func testEveryAvailableNewCatalogTypeHasAnUnambiguousForwardAndReverseQueryFactoryMapping() throws {
		let queryFactory = QueryFactoryImpl()
		let sampleFactory = SampleFactoryImpl()
		let entries = HealthCatalog.availableEntries.filter { $0.descriptor.id >= 21 }
		XCTAssertGreaterThan(entries.count, 100)
		for entry in entries {
			let query = try queryFactory.queryFor(entry.sampleType)
			XCTAssertTrue(try queryFactory.sampleTypeFor(query) == entry.sampleType)
			XCTAssertEqual(sampleFactory.sampleTypeId(for: entry.sampleType), entry.descriptor.id)
			XCTAssertTrue(try sampleFactory.sampleType(for: entry.descriptor.id) == entry.sampleType)
			XCTAssertTrue((query as? CatalogHealthQueryIdentifying)?.catalogSampleType == entry.sampleType)
		}
	}

	@MainActor func testCatalogQueryRoundTripsThroughSQLiteWithItsPermanentTypeIDAndNumericRestriction() throws {
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		defer { try? FileManager.default.removeItem(at: directory) }
		let container = NSPersistentContainer(name: "HealthCatalogQueryPersistence", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("query.sqlite"))
		description.shouldAddStoreAsynchronously = false
		container.persistentStoreDescriptions = [description]
		var loadError: Error?
		container.loadPersistentStores { _, error in loadError = error }
		if let loadError = loadError { throw loadError }
		defer {
			container.viewContext.reset()
			for store in container.persistentStoreCoordinator.persistentStores { try? container.persistentStoreCoordinator.remove(store) }
		}
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(),
			SamplesInjectionProvider(), QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider(),
			CatalogQueryDatabaseProvider(DatabaseImpl(container)), probe])
		let descriptor = try XCTUnwrap(HealthCatalog.availableDescriptors.first { $0.identifier == HKQuantityTypeIdentifier.height.rawValue })
		let type = try injected(SampleFactory.self).sampleType(for: descriptor.id)
		let query = try injected(QueryFactory.self).queryFor(type)
		query.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: type.defaultDependentAttribute, value: 1.23456789012345)
		query.mostRecentEntryOnly = true
		let stored = try query.stored(withName: "Height records above my threshold")
		let id = stored.objectID
		XCTAssertEqual(stored.sampleTypeId, descriptor.id)
		XCTAssertGreaterThanOrEqual(stored.sampleTypeId, 21)
		container.viewContext.reset()
		let reloaded = try XCTUnwrap(try container.viewContext.existingObject(with: id) as? StoredQuery)
		let restored = try reloaded.convert()
		XCTAssertTrue(try injected(QueryFactory.self).sampleTypeFor(restored) == type)
		XCTAssertTrue(restored.equalTo(query), "Restoring the saved catalog query must retain its exact typed condition and flags")
		XCTAssertTrue(probe.permissions.isEmpty, "Saving or restoring a query must not request Health access")
		XCTAssertTrue(probe.sampleCallbacks.isEmpty)
	}
}
