import XCTest
import CoreData
import Common
import DependencyInjection
import Samples
@testable import Persistence

private final class DatabaseRefreshContextProbe: NSManagedObjectContext {
	struct Call {
		let operation: String
		let onMainThread: Bool
		let ownsObject: Bool
	}
	private let callsLock = NSLock()
	private var calls: [Call] = []
	func snapshot() -> [Call] {
		callsLock.lock(); defer { callsLock.unlock() }
		return calls
	}
	func clearCalls() {
		callsLock.lock(); defer { callsLock.unlock() }
		calls = []
	}
	private func record(_ operation: String, ownsObject: Bool = true) {
		let call = Call(operation: operation, onMainThread: Thread.isMainThread, ownsObject: ownsObject)
		callsLock.lock(); defer { callsLock.unlock() }
		calls.append(call)
	}
	override func refresh(_ object: NSManagedObject, mergeChanges flag: Bool) {
		let ownsObject = object.managedObjectContext === self
		record("refresh", ownsObject: ownsObject)
		// Record an invalid entry without deliberately provoking Core Data's
		// wrong-queue or wrong-context exception in a regression test.
		guard ownsObject else { return }
		if Thread.isMainThread { refreshOnOwningQueue(object, mergeChanges: flag) }
		else { performAndWait { self.refreshOnOwningQueue(object, mergeChanges: flag) } }
	}
	private func refreshOnOwningQueue(_ object: NSManagedObject, mergeChanges flag: Bool) {
		super.refresh(object, mergeChanges: flag)
	}
	override func refreshAllObjects() {
		record("refreshAllObjects")
		if Thread.isMainThread { refreshAllOnOwningQueue() }
		else { performAndWait { self.refreshAllOnOwningQueue() } }
	}
	private func refreshAllOnOwningQueue() { super.refreshAllObjects() }
	override func save() throws {
		record("save")
		if Thread.isMainThread { try saveOnOwningQueue() }
		else { try performAndWait { try self.saveOnOwningQueue() } }
	}
	private func saveOnOwningQueue() throws { try super.save() }
}

private final class DatabaseRefreshContainer: NSPersistentContainer {
	let probe = DatabaseRefreshContextProbe(concurrencyType: .mainQueueConcurrencyType)
	override var viewContext: NSManagedObjectContext { probe }
	init(model: NSManagedObjectModel) {
		super.init(name: "DatabaseRefreshTests", managedObjectModel: model)
		probe.persistentStoreCoordinator = persistentStoreCoordinator
		probe.undoManager = nil
	}
}

private final class DatabaseRefreshNotificationProbe: NotificationUtil {
	struct Call {
		let name: Notification.Name
		let onMainThread: Bool
		let qos: DispatchQoS.QoSClass?
	}
	private let callsLock = NSLock()
	private var calls: [Call] = []
	func snapshot() -> [Call] {
		callsLock.lock(); defer { callsLock.unlock() }
		return calls
	}
	func clearCalls() {
		callsLock.lock(); defer { callsLock.unlock() }
		calls = []
	}
	func post(_ name: NotificationName, object: Any?, userInfo: [UserInfoKey: Any]?, qos: DispatchQoS.QoSClass?) {
		post(name.toName(), object: object, userInfo: userInfo, qos: qos)
	}
	func post(_ name: Notification.Name, object: Any?, userInfo: [UserInfoKey: Any]?, qos: DispatchQoS.QoSClass?) {
		let call = Call(name: name, onMainThread: Thread.isMainThread, qos: qos)
		callsLock.lock(); defer { callsLock.unlock() }
		calls.append(call)
	}
}

private final class DatabaseRefreshProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, NotificationUtil.self]
	let database: Database
	let notifications: NotificationUtil
	init(database: Database, notifications: NotificationUtil) {
		self.database = database; self.notifications = notifications
	}
	func get<Value>(_ type: Value.Type) throws -> Value {
		if type == Database.self { return database as! Value }
		if type == NotificationUtil.self { return notifications as! Value }
		throw GenericError("Unexpected refresh-test dependency")
	}
}

final class DatabaseRefreshConcurrencyTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: DatabaseRefreshConcurrencyTests.self)])!
	private var directory: URL!
	private var container: DatabaseRefreshContainer!
	private var database: DatabaseImpl!
	private var notifications: DatabaseRefreshNotificationProbe!
	private var tag: Tag!

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = DatabaseRefreshContainer(model: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("refresh.sqlite"))
		description.shouldAddStoreAsynchronously = false
		container.persistentStoreDescriptions = [description]
		var failure: Error?
		container.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		database = DatabaseImpl(container)
		notifications = DatabaseRefreshNotificationProbe()
		DependencyInjector.register([CommonInjectionProvider(), DatabaseRefreshProvider(database: database, notifications: notifications)])
		let entity = try XCTUnwrap(Self.model.entitiesByName[Tag.entityName])
		tag = Tag(entity: entity, insertInto: container.viewContext)
		tag.name = "Stored name"
		try container.viewContext.save()
		container.probe.clearCalls()
	}

	override func tearDownWithError() throws {
		tag = nil
		if let container = container {
			container.viewContext.performAndWait { container.viewContext.reset() }
			for store in container.persistentStoreCoordinator.persistentStores {
				try container.persistentStoreCoordinator.remove(store)
			}
		}
		database = nil; container = nil; notifications = nil
		if let directory = directory { try FileManager.default.removeItem(at: directory) }
	}

	@MainActor func testBackgroundRefreshWithNoExternalChangesUsesTheMainQueueAndPreservesPendingEdits() throws {
		try storeSync(modified: false)
		tag.name = "Pending UI edit"
		try refreshFromBackground()
		assertRootQueueSafety()
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "refreshAllObjects" }.count, 0)
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "save" }.count, 0)
		XCTAssertTrue(notifications.snapshot().isEmpty)
		XCTAssertEqual(tag.name, "Pending UI edit")
		XCTAssertTrue(tag.hasChanges)
		XCTAssertEqual(try storedTagName(), "Stored name")
		XCTAssertEqual(try storedSyncFlags(), [false])
	}

	@MainActor func testBackgroundExternalRefreshReturnsWithUpdatedValuesClearedMetadataAndOrderedNotifications() throws {
		try storeSync(modified: false)
		XCTAssertEqual(tag.name, "Stored name")
		try externallyChangeTagAndMarkModified()
		XCTAssertEqual(tag.name, "Stored name", "This view context has not merged the writer's update")
		try refreshFromBackground {
			// Check completion at the caller, before it can enqueue any follow-up
			// work on the main queue; refreshContext remains synchronous.
			self.assertRefreshNotifications()
			XCTAssertEqual(try self.storedSyncFlags(), [false])
		}
		assertRootQueueSafety()
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "refreshAllObjects" }.count, 1)
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "save" }.count, 0)
		XCTAssertEqual(tag.name, "Changed by extension")
		XCTAssertFalse(tag.hasChanges)
	}

	@MainActor func testBackgroundMetadataWriteIsDurableWithoutSavingUnrelatedViewEdits() throws {
		tag.name = "Pending UI edit"
		let complete = expectation(description: "Metadata write returned")
		let subject = database!
		DispatchQueue.global(qos: .userInteractive).async {
			subject.setModifiedExternally(true)
			do { XCTAssertEqual(try self.storedSyncFlags(), [true]) }
			catch { XCTFail("Reading metadata after the synchronous setter failed: \(error)") }
			complete.fulfill()
		}
		wait(for: [complete], timeout: 5)
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "save" }.count, 0)
		XCTAssertEqual(tag.name, "Pending UI edit")
		XCTAssertTrue(tag.hasChanges)
		XCTAssertEqual(try storedTagName(), "Stored name")
		XCTAssertTrue(notifications.snapshot().isEmpty)
	}

	@MainActor func testColdBackgroundRefreshCreatesOneViewOwnedSyncRecordWithoutSavingUIEdits() throws {
		XCTAssertEqual(try storedSyncFlags(), [])
		tag.name = "Pending UI edit"
		try refreshFromBackground()
		assertRootQueueSafety()
		XCTAssertEqual(try storedSyncFlags(), [false])
		let syncs = try container.viewContext.fetch(NSFetchRequest<CoreDataSync>(entityName: CoreDataSync.entityName))
		XCTAssertEqual(syncs.count, 1)
		XCTAssertTrue(syncs.allSatisfy { $0.managedObjectContext === container.viewContext })
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "save" }.count, 0)
		XCTAssertTrue(notifications.snapshot().isEmpty)
		XCTAssertEqual(tag.name, "Pending UI edit"); XCTAssertTrue(tag.hasChanges)
		XCTAssertEqual(try storedTagName(), "Stored name")
	}

	@MainActor func testReentrantMainQueueRefreshPreservesPendingEditsWhileClearingStoredMetadata() throws {
		try storeSync(modified: true)
		tag.name = "Pending UI edit"
		container.viewContext.performAndWait { database.refreshContext() }
		assertRootQueueSafety()
		assertRefreshNotifications()
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "refreshAllObjects" }.count, 1)
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "save" }.count, 0)
		XCTAssertEqual(try storedSyncFlags(), [false])
		XCTAssertEqual(tag.name, "Pending UI edit"); XCTAssertTrue(tag.hasChanges)
		XCTAssertEqual(try storedTagName(), "Stored name")
	}

	@MainActor func testLaterForegroundRefreshSkipsTheFullRefreshAfterTheFlagWasCleared() throws {
		try storeSync(modified: true)
		try refreshFromBackground()
		XCTAssertEqual(try storedSyncFlags(), [false])
		container.probe.clearCalls(); notifications.clearCalls()
		try refreshFromBackground()
		assertRootQueueSafety()
		XCTAssertEqual(container.probe.snapshot().filter { $0.operation == "refreshAllObjects" }.count, 0)
		XCTAssertTrue(notifications.snapshot().isEmpty)
		XCTAssertEqual(try storedSyncFlags(), [false])
	}

	private func refreshFromBackground(afterReturn: @escaping @Sendable () throws -> Void = {}) throws {
		let complete = expectation(description: "Background foreground-refresh returned")
		let subject = database!
		DispatchQueue.global(qos: .userInteractive).async {
			XCTAssertFalse(Thread.isMainThread)
			subject.refreshContext()
			do { try afterReturn() }
			catch { XCTFail("Post-refresh check failed: \(error)") }
			complete.fulfill()
		}
		XCTAssertEqual(XCTWaiter.wait(for: [complete], timeout: 5), .completed)
	}

	private func assertRootQueueSafety(file: StaticString = #file, line: UInt = #line) {
		let calls = container.probe.snapshot()
		XCTAssertTrue(calls.contains { $0.operation == "refresh" }, "The real sync-record refresh must be exercised", file: file, line: line)
		XCTAssertTrue(calls.allSatisfy { $0.onMainThread }, "Every view-context refresh/save must enter on its owning main queue", file: file, line: line)
		XCTAssertTrue(calls.allSatisfy { $0.ownsObject }, "The view context must never receive a writer-owned sync record", file: file, line: line)
	}

	private func assertRefreshNotifications(file: StaticString = #file, line: UInt = #line) {
		let calls = notifications.snapshot()
		XCTAssertEqual(calls.map { $0.name }, [NotificationName.persistenceLayerWillRefresh.toName(), NotificationName.persistenceLayerDidRefresh.toName()], file: file, line: line)
		XCTAssertTrue(calls.allSatisfy { $0.onMainThread }, file: file, line: line)
		XCTAssertNil(calls.first?.qos, file: file, line: line)
		XCTAssertEqual(calls.last?.qos, .userInteractive, file: file, line: line)
	}

	private func storeSync(modified: Bool) throws {
		let entity = try XCTUnwrap(Self.model.entitiesByName[CoreDataSync.entityName])
		let sync = CoreDataSync(entity: entity, insertInto: container.viewContext)
		sync.externallyModified = modified
		try container.viewContext.save()
		container.probe.clearCalls()
	}

	private func externallyChangeTagAndMarkModified() throws {
		let writer = container.newBackgroundContext()
		let id = tag.objectID
		try writer.performAndWait {
			let externalTag = try XCTUnwrap(try writer.existingObject(with: id) as? Tag)
			externalTag.name = "Changed by extension"
			let sync = try XCTUnwrap(try writer.fetch(NSFetchRequest<CoreDataSync>(entityName: CoreDataSync.entityName)).first)
			sync.externallyModified = true
			try writer.save()
		}
	}

	private func storedSyncFlags() throws -> [Bool] {
		let reader = container.newBackgroundContext()
		return try reader.performAndWait {
			try reader.fetch(NSFetchRequest<CoreDataSync>(entityName: CoreDataSync.entityName)).map { $0.externallyModified }
		}
	}

	private func storedTagName() throws -> String {
		let reader = container.newBackgroundContext()
		let id = tag.objectID
		return try reader.performAndWait { try XCTUnwrap(try reader.existingObject(with: id) as? Tag).name }
	}
}
