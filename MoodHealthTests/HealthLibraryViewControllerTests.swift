import XCTest
import UIKit
import HealthKit
import Attributes
import Samples

private final class HealthLibrarySampleFixture: HealthKitSample {
	static let name = "Fixture Health records"
	static let attributes: [Attribute] = []
	static let dateAttributes: [DateType: DateAttribute] = [:]
	static let defaultDependentAttribute: Attribute = CommonSampleAttributes.timestamp
	static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	static var sampleType: HKSampleType { HKQuantityType.quantityType(forIdentifier: .height)! }
	static var readPermissions: Set<HKObjectType> { [sampleType] }
	static var writePermissions: Set<HKSampleType> { [] }
	static func initUnits() {}
	let record: HKQuantitySample
	let displayDate: Date
	let attributedName = "Fixture Health records"
	let attributes: [Attribute] = []
	var description: String { "Height fixture" }
	var sourceIdentifier: UUID? { record.uuid }
	private let lock = NSLock()
	private var workerRead = false
	var wasReadOnWorker: Bool { lock.lock(); defer { lock.unlock() }; return workerRead }
	var originalHealthSample: HKSample? {
		lock.lock(); workerRead = workerRead || !Thread.isMainThread; lock.unlock()
		return record
	}
	init(at instant: Date, displayDate: Date? = nil) {
		record = HKQuantitySample(type: Self.sampleType as! HKQuantityType,
			quantity: HKQuantity(unit: .meter(), doubleValue: 1.75), start: instant, end: instant.addingTimeInterval(12.125),
			metadata: ["Library fixture": "Retain original"])
		self.displayDate = displayDate ?? instant
	}
	func hkSample() -> HKSample { record }
	func dates() -> [DateType: Date] { [.start: displayDate] }
	func value(of attribute: Attribute) throws -> Any? { nil }
	func set(attribute: Attribute, to value: Any?) throws { throw HealthCatalogError.readOnly }
}

private final class HealthLibraryNonHealthFixture: Sample {
	static let name = "Local fixture"
	static let attributes: [Attribute] = []
	static let dateAttributes: [DateType: DateAttribute] = [:]
	static let defaultDependentAttribute: Attribute = CommonSampleAttributes.timestamp
	static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	let attributedName = "Local fixture"
	let description = "This is not a Health record"
	let attributes: [Attribute] = []
	func dates() -> [DateType: Date] { [:] }
	func value(of attribute: Attribute) throws -> Any? { nil }
	func set(attribute: Attribute, to value: Any?) throws {}
}

private final class HealthLibraryLoaderProbe {
	final class SampleRequest {
		let type: Sample.Type
		let completion: (Result<[Sample], Error>) -> Void
		var cancellationCount = 0
		init(type: Sample.Type, completion: @escaping (Result<[Sample], Error>) -> Void) {
			self.type = type; self.completion = completion
		}
	}
	final class ExternalRequest {
		let descriptor: HealthTypeDescriptor
		let completion: (Result<[HealthExternalRecord], Error>) -> Void
		var cancellationCount = 0
		init(descriptor: HealthTypeDescriptor, completion: @escaping (Result<[HealthExternalRecord], Error>) -> Void) {
			self.descriptor = descriptor; self.completion = completion
		}
	}
	var sampleRequests: [SampleRequest] = []
	var externalRequests: [ExternalRequest] = []
	var sampleLoader: HealthLibrarySampleLoader {
		{ [self] type, completion in
			let request = SampleRequest(type: type, completion: completion)
			sampleRequests.append(request)
			return { request.cancellationCount += 1 }
		}
	}
	var externalLoader: HealthLibraryExternalLoader {
		{ [self] descriptor, completion in
			let request = ExternalRequest(descriptor: descriptor, completion: completion)
			externalRequests.append(request)
			return { request.cancellationCount += 1 }
		}
	}
}

final class HealthLibraryViewControllerTests: XCTestCase {
	private let anchor = Date(timeIntervalSinceReferenceDate: 700_000_023.875)
	private let quantity = HealthTypeDescriptor(id: 30000, identifier: "HKLibraryFixtureHeight", name: "Alpha Height",
		group: "Measurements", family: .quantity, minimumOS: "18.0")
	private let profile = HealthTypeDescriptor(id: 30001, identifier: "HKLibraryFixtureProfile", name: "Zebra Profile",
		group: "Profile", family: .characteristic, minimumOS: "18.0")

	@MainActor private func records(_ descriptor: HealthTypeDescriptor? = nil,
		probe: HealthLibraryLoaderProbe) -> HealthLibraryRecordsViewController {
		let selected = descriptor ?? quantity
		let controller = HealthLibraryRecordsViewController(descriptor: selected,
			sampleType: selected.family == .quantity ? HealthLibrarySampleFixture.self : nil,
			sampleLoader: probe.sampleLoader, externalLoader: probe.externalLoader)
		controller.loadViewIfNeeded()
		return controller
	}

	@MainActor private func ready(_ controller: HealthLibraryRecordsViewController,
		file: StaticString = #filePath, line: UInt = #line) {
		let finished = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in !controller.isLoading }, object: nil)
		XCTAssertEqual(XCTWaiter.wait(for: [finished], timeout: 3), .completed,
			"The library read did not finish", file: file, line: line)
	}

	@MainActor private func drainMainQueue() {
		let drained = expectation(description: "Queued UI updates finished")
		DispatchQueue.main.async { DispatchQueue.main.async { drained.fulfill() } }
		XCTAssertEqual(XCTWaiter.wait(for: [drained], timeout: 3), .completed)
	}

	@MainActor private func indexPath(_ descriptor: HealthTypeDescriptor,
		in controller: HealthLibraryViewController) throws -> IndexPath {
		for section in 0..<controller.numberOfSections(in: controller.tableView) {
			for row in 0..<controller.tableView(controller.tableView, numberOfRowsInSection: section) {
				let path = IndexPath(row: row, section: section)
				if controller.tableView(controller.tableView, cellForRowAt: path).textLabel?.text == descriptor.name { return path }
			}
		}
		throw NSError(domain: "HealthLibraryTests.MissingRow", code: Int(descriptor.id))
	}

	@MainActor func testBrowsingContainsEveryAvailableDescriptorWithoutRequestingHealthAccess() {
		let probe = HealthLibraryLoaderProbe()
		let controller = HealthLibraryViewController(sampleLoader: probe.sampleLoader, externalLoader: probe.externalLoader)
		controller.loadViewIfNeeded()
		XCTAssertEqual(Set(controller.filteredDescriptors.map { $0.id }), Set(HealthCatalog.availableDescriptors.map { $0.id }))
		XCTAssertEqual(controller.filteredDescriptors.count, HealthCatalog.availableDescriptors.count)
		XCTAssertEqual(Set(controller.groups), Set(HealthCatalog.availableDescriptors.map { $0.group }))
		let sectionCount = controller.numberOfSections(in: controller.tableView)
		let rowCount = (0..<sectionCount).reduce(0) { $0 + controller.tableView(controller.tableView, numberOfRowsInSection: $1) }
		XCTAssertEqual(rowCount, HealthCatalog.availableDescriptors.count)
		if #available(iOS 26.2, *) { XCTAssertEqual(rowCount, 221) }
		XCTAssertTrue(probe.sampleRequests.isEmpty)
		XCTAssertTrue(probe.externalRequests.isEmpty)
	}

	@MainActor func testSearchMatchesNamesGroupsAndIdentifiersAndCanBeCleared() {
		let controller = HealthLibraryViewController(descriptors: [profile, quantity], sampleTypes: [:])
		controller.loadViewIfNeeded()
		for term in ["HEIGHT", "measurements", "HKLibraryFixtureHeight"] {
			controller.searchController.searchBar.text = term
			controller.updateSearchResults(for: controller.searchController)
			XCTAssertEqual(controller.filteredDescriptors.map { $0.id }, [quantity.id], term)
			XCTAssertEqual(controller.groups, [quantity.group])
		}
		controller.searchController.searchBar.text = "No matching type"
		controller.updateSearchResults(for: controller.searchController)
		XCTAssertTrue(controller.filteredDescriptors.isEmpty)
		controller.searchController.searchBar.text = ""
		controller.updateSearchResults(for: controller.searchController)
		XCTAssertEqual(Set(controller.filteredDescriptors.map { $0.id }), Set([quantity.id, profile.id]))
	}

	@MainActor func testSelectingDatedTypeUsesItsRegisteredSampleLoaderAndReadOnlyList() throws {
		let probe = HealthLibraryLoaderProbe()
		let library = HealthLibraryViewController(descriptors: [quantity, profile],
			sampleTypes: [quantity.id: HealthLibrarySampleFixture.self],
			sampleLoader: probe.sampleLoader, externalLoader: probe.externalLoader)
		let navigation = UINavigationController(rootViewController: library)
		library.loadViewIfNeeded()
		library.tableView(library.tableView, didSelectRowAt: try indexPath(quantity, in: library))
		let list = try XCTUnwrap(navigation.topViewController as? HealthLibraryRecordsViewController)
		list.loadViewIfNeeded()
		XCTAssertTrue(list.isLoading)
		XCTAssertEqual(probe.sampleRequests.count, 1)
		XCTAssertTrue(probe.sampleRequests[0].type == HealthLibrarySampleFixture.self)
		XCTAssertTrue(probe.externalRequests.isEmpty)
		XCTAssertNil(list.navigationItem.leftBarButtonItem)
		XCTAssertEqual(list.tableView(list.tableView, numberOfRowsInSection: 0), 0)
		list.cancelLoading()
	}

	@MainActor func testSelectingProfileUsesDedicatedReaderRatherThanInventingSampleQuery() throws {
		let probe = HealthLibraryLoaderProbe()
		let library = HealthLibraryViewController(descriptors: [profile], sampleTypes: [:],
			sampleLoader: probe.sampleLoader, externalLoader: probe.externalLoader)
		let navigation = UINavigationController(rootViewController: library)
		library.loadViewIfNeeded()
		library.tableView(library.tableView, didSelectRowAt: try indexPath(profile, in: library))
		let list = try XCTUnwrap(navigation.topViewController as? HealthLibraryRecordsViewController)
		list.loadViewIfNeeded()
		XCTAssertTrue(probe.sampleRequests.isEmpty)
		XCTAssertEqual(probe.externalRequests.map { $0.descriptor }, [profile])
		list.cancelLoading()
	}

	@MainActor func testAllRecordsAreSortedOffMainByOriginalInstantsAndEqualDatesRetainTheirOrder() throws {
		let probe = HealthLibraryLoaderProbe(), list = records(probe: probe)
		let firstTie = HealthLibrarySampleFixture(at: anchor.addingTimeInterval(2), displayDate: anchor.addingTimeInterval(-2000))
		let secondTie = HealthLibrarySampleFixture(at: anchor.addingTimeInterval(2), displayDate: anchor.addingTimeInterval(2000))
		let older = (0..<1003).map { HealthLibrarySampleFixture(at: anchor.addingTimeInterval(-Double($0)),
			displayDate: anchor.addingTimeInterval(Double($0))) }
		let input = Array(older.reversed()) + [firstTie, secondTie]
		probe.sampleRequests[0].completion(.success(input))
		ready(list)
		XCTAssertEqual(list.samples.count, input.count, "Browsing must not silently cap record history")
		XCTAssertEqual(list.samples.map { $0.sourceIdentifier }, ([firstTie, secondTie] + older).map { $0.sourceIdentifier })
		XCTAssertTrue(input.allSatisfy { $0.wasReadOnWorker }, "Projection and sorting must leave the UI queue")
		XCTAssertEqual(list.tableView(list.tableView, numberOfRowsInSection: 0), input.count)
		let navigation = UINavigationController(rootViewController: list)
		list.tableView(list.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		let detail = try XCTUnwrap(navigation.topViewController as? HealthRecordDetailViewController)
		XCTAssertTrue(detail.record === firstTie.record)
		XCTAssertEqual(detail.record.startDate.timeIntervalSinceReferenceDate.bitPattern,
			firstTie.record.startDate.timeIntervalSinceReferenceDate.bitPattern)
		XCTAssertEqual(detail.record.metadata?["Library fixture"] as? String, "Retain original")
		XCTAssertFalse(list.tableView(list.tableView, canEditRowAt: IndexPath(row: 0, section: 0)))
	}

	@MainActor func testUnexpectedNonHealthResultFailsTheWholeReadInsteadOfDroppingARecord() {
		let probe = HealthLibraryLoaderProbe(), list = records(probe: probe)
		probe.sampleRequests[0].completion(.success([HealthLibrarySampleFixture(at: anchor), HealthLibraryNonHealthFixture()]))
		ready(list)
		XCTAssertTrue(list.samples.isEmpty)
		XCTAssertTrue(list.externalRecords.isEmpty)
		XCTAssertEqual(list.tableView(list.tableView, numberOfRowsInSection: 0), 0)
		XCTAssertTrue(list.statusText.lowercased().contains("unexpected"))
		XCTAssertNotNil(list.tableView.backgroundView)
	}

	@MainActor func testProfileAndMedicationStyleRecordsNeverAcquireInventedEventDates() throws {
		let probe = HealthLibraryLoaderProbe(), list = records(profile, probe: probe)
		let sections = [HealthRecordSection(title: "Profile fixture", fields: [.init(name: "Value", value: "Recorded value")])]
		let value = HealthExternalRecord(identifier: "original-profile-id", title: "Recorded profile", sections: sections)
		probe.externalRequests[0].completion(.success([value]))
		ready(list)
		XCTAssertTrue(list.samples.isEmpty)
		XCTAssertEqual(list.externalRecords.count, 1)
		XCTAssertEqual(list.externalRecords[0].identifier, "original-profile-id")
		XCTAssertTrue(list.externalRecords[0].dates.isEmpty)
		let row = list.tableView(list.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
		XCTAssertNil(row.detailTextLabel?.text, "Undated profile and medication records must not display an invented date")
		let navigation = UINavigationController(rootViewController: list)
		list.tableView(list.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		let detail = try XCTUnwrap(navigation.topViewController as? HealthValueRecordViewController)
		XCTAssertEqual(detail.title, value.title)
		XCTAssertEqual(detail.sections, sections)
	}

	@MainActor func testAttachmentCatalogEntryExplainsParentScopeWithoutStartingAnyGlobalRead() {
		let attachment = HealthTypeDescriptor(id: 30002, identifier: "HKLibraryFixtureAttachment", name: "Attachments",
			group: "Records", family: .attachment, minimumOS: "18.0")
		let probe = HealthLibraryLoaderProbe(), list = records(attachment, probe: probe)
		XCTAssertFalse(list.isLoading)
		XCTAssertTrue(probe.sampleRequests.isEmpty)
		XCTAssertTrue(probe.externalRequests.isEmpty)
		XCTAssertTrue(list.statusText.lowercased().contains("parent"))
		XCTAssertTrue(list.statusText.lowercased().contains("record"))
		XCTAssertEqual(list.tableView(list.tableView, numberOfRowsInSection: 0), 0)
	}

	@MainActor func testEmptyReadsExplainVisibilityWithoutClaimingPermissionWasDenied() {
		let probe = HealthLibraryLoaderProbe(), list = records(probe: probe)
		probe.sampleRequests[0].completion(.success([]))
		ready(list)
		XCTAssertTrue(list.samples.isEmpty)
		XCTAssertTrue(list.statusText.lowercased().contains("permission") || list.statusText.lowercased().contains("access"))
		XCTAssertFalse(list.statusText.lowercased().contains("permission denied"))
		XCTAssertFalse(list.statusText.lowercased().contains("access denied"))
		XCTAssertNotNil(list.tableView.backgroundView)
		XCTAssertTrue(list.navigationItem.rightBarButtonItem?.isEnabled == true)
	}

	@MainActor func testErrorRemainsDistinctFromEmptyAndReloadCanRecover() {
		let probe = HealthLibraryLoaderProbe(), list = records(probe: probe)
		probe.sampleRequests[0].completion(.failure(NSError(domain: "LibraryFixtureRead", code: 7,
			userInfo: [NSLocalizedDescriptionKey: "Fixture read failed"])))
		ready(list)
		XCTAssertTrue(list.statusText.lowercased().contains("failed") || list.statusText.lowercased().contains("could not"))
		XCTAssertTrue(list.samples.isEmpty)
		list.reloadRecords()
		XCTAssertEqual(probe.sampleRequests.count, 2)
		XCTAssertTrue(list.isLoading)
		let value = HealthLibrarySampleFixture(at: anchor)
		probe.sampleRequests[1].completion(.success([value]))
		ready(list)
		XCTAssertEqual(list.samples.map { $0.sourceIdentifier }, [value.sourceIdentifier])
		XCTAssertNil(list.tableView.backgroundView)
	}

	@MainActor func testReloadCancelsPreviousReadAndRejectsItsLateCompletion() {
		let probe = HealthLibraryLoaderProbe(), list = records(probe: probe)
		let previous = probe.sampleRequests[0]
		list.reloadRecords()
		XCTAssertEqual(previous.cancellationCount, 1)
		let currentValue = HealthLibrarySampleFixture(at: anchor)
		probe.sampleRequests[1].completion(.success([currentValue]))
		ready(list)
		previous.completion(.failure(NSError(domain: "OldLibraryRequest", code: 9)))
		drainMainQueue()
		XCTAssertEqual(list.samples.map { $0.sourceIdentifier }, [currentValue.sourceIdentifier])
		XCTAssertFalse(list.isLoading)
	}

	@MainActor func testDuplicateCompletionCannotOverwriteAFinishedRead() {
		let probe = HealthLibraryLoaderProbe(), list = records(probe: probe)
		let request = probe.sampleRequests[0], value = HealthLibrarySampleFixture(at: anchor)
		request.completion(.success([value]))
		ready(list)
		let finishedStatus = list.statusText
		request.completion(.failure(NSError(domain: "DuplicateLibraryCallback", code: 10)))
		let overwritten = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in list.statusText != finishedStatus }, object: nil)
		overwritten.isInverted = true
		XCTAssertEqual(XCTWaiter.wait(for: [overwritten], timeout: 0.2), .completed)
		XCTAssertEqual(list.samples.map { $0.sourceIdentifier }, [value.sourceIdentifier])
		list.reloadRecords()
		XCTAssertEqual(request.cancellationCount, 0, "A completed reader must release its cancellation operation")
		list.cancelLoading()
	}

	@MainActor func testCancellingExternalReadRejectsLateResultsAndCanBeRetried() {
		let probe = HealthLibraryLoaderProbe(), list = records(profile, probe: probe)
		let previous = probe.externalRequests[0]
		list.cancelLoading()
		XCTAssertEqual(previous.cancellationCount, 1)
		XCTAssertFalse(list.isLoading)
		previous.completion(.success([HealthExternalRecord(identifier: "late", title: "Late record", sections: [])]))
		drainMainQueue()
		XCTAssertTrue(list.externalRecords.isEmpty)
		list.reloadRecords()
		XCTAssertEqual(probe.externalRequests.count, 2)
		probe.externalRequests[1].completion(.success([]))
		ready(list)
		XCTAssertTrue(list.externalRecords.isEmpty)
	}

	@MainActor func testRetainedLoaderCallbackDoesNotKeepTheRecordsControllerAlive() {
		let probe = HealthLibraryLoaderProbe()
		weak var released: HealthLibraryRecordsViewController?
		autoreleasepool {
			let list = records(probe: probe)
			released = list
		}
		XCTAssertNil(released)
		XCTAssertEqual(probe.sampleRequests[0].cancellationCount, 1)
		probe.sampleRequests[0].completion(.success([]))
		drainMainQueue()
	}

	@MainActor func testPoppingTheRecordsControllerCancelsTheActiveRead() {
		let probe = HealthLibraryLoaderProbe(), list = records(probe: probe)
		let navigation = UINavigationController(rootViewController: UIViewController())
		navigation.loadViewIfNeeded()
		navigation.beginAppearanceTransition(true, animated: false)
		navigation.endAppearanceTransition()
		navigation.pushViewController(list, animated: false)
		XCTAssertTrue(list.isLoading)
		XCTAssertTrue(navigation.popViewController(animated: false) === list)
		XCTAssertEqual(probe.sampleRequests[0].cancellationCount, 1)
		XCTAssertFalse(list.isLoading)
		probe.sampleRequests[0].completion(.failure(NSError(domain: "PoppedLibraryRequest", code: 8)))
		drainMainQueue()
		XCTAssertTrue(list.samples.isEmpty)
		navigation.beginAppearanceTransition(false, animated: false)
		navigation.endAppearanceTransition()
	}

	@MainActor func testSynchronousAndBackgroundCompletionsPublishTheSameRecords() {
		let value = HealthLibrarySampleFixture(at: anchor)
		let synchronous = HealthLibraryRecordsViewController(descriptor: quantity, sampleType: HealthLibrarySampleFixture.self,
			sampleLoader: { _, completion in completion(.success([value])); return {} })
		synchronous.loadViewIfNeeded(); ready(synchronous)
		XCTAssertEqual(synchronous.samples.map { $0.sourceIdentifier }, [value.sourceIdentifier])
		let probe = HealthLibraryLoaderProbe(), background = records(probe: probe)
		DispatchQueue.global(qos: .userInitiated).async { probe.sampleRequests[0].completion(.success([value])) }
		ready(background)
		XCTAssertEqual(background.samples.map { $0.sourceIdentifier }, synchronous.samples.map { $0.sourceIdentifier })
	}
}
