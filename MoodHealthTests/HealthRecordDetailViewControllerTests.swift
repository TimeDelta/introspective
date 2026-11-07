import XCTest
import UIKit
import HealthKit
import CoreLocation
import Attributes
import Samples

private final class HealthDetailSampleFixture: HealthKitSample {
	static let name = "Original Health fixture"
	static let attributes: [Attribute] = []
	static let dateAttributes: [DateType: DateAttribute] = [:]
	static let defaultDependentAttribute: Attribute = CommonSampleAttributes.timestamp
	static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	static var sampleType: HKSampleType { HKQuantityType.quantityType(forIdentifier: .height)! }
	static var readPermissions: Set<HKObjectType> { [sampleType] }
	static var writePermissions: Set<HKSampleType> { [] }
	static func initUnits() {}
	let originalHealthSample: HKSample?
	let fallback: HKQuantitySample
	let displayDate: Date
	let attributedName = "Original Health fixture"
	let description = "Projected value"
	let attributes: [Attribute] = []
	private(set) var reconstructionCount = 0
	var sourceIdentifier: UUID? { originalHealthSample?.uuid }
	init(original: HKSample?, fallback: HKQuantitySample, displayDate: Date) {
		originalHealthSample = original; self.fallback = fallback; self.displayDate = displayDate
	}
	func hkSample() -> HKSample { reconstructionCount += 1; return fallback }
	func dates() -> [DateType: Date] { [.start: displayDate] }
	func value(of attribute: Attribute) throws -> Any? { nil }
	func set(attribute: Attribute, to value: Any?) throws { throw HealthCatalogError.readOnly }
}

private final class HealthAttachmentLoaderProbe {
	final class Request {
		let record: HKObject
		let completion: (Result<[HKAttachment], Error>) -> Void
		var cancellationCount = 0
		init(record: HKObject, completion: @escaping (Result<[HKAttachment], Error>) -> Void) {
			self.record = record; self.completion = completion
		}
	}
	var requests: [Request] = []
	var loader: HealthRecordAttachmentsViewController.Loader {
		{ [self] record, completion in
			let request = Request(record: record, completion: completion)
			requests.append(request)
			return { request.cancellationCount += 1 }
		}
	}
}

private final class HealthAttachmentCancellationLease {
	var cancellationCount = 0
}

final class HealthRecordDetailViewControllerTests: XCTestCase {
	private let anchor = Date(timeIntervalSinceReferenceDate: 700_000_023.875)

	private func record(at date: Date? = nil) -> HKQuantitySample {
		let start = date ?? anchor
		let device = HKDevice(name: "Original device", manufacturer: "Fixture maker", model: "Fixture model",
			hardwareVersion: "1", firmwareVersion: "2", softwareVersion: "3",
			localIdentifier: "original-local-id", udiDeviceIdentifier: "original-udi")
		return HKQuantitySample(type: HealthDetailSampleFixture.sampleType as! HKQuantityType,
			quantity: HKQuantity(unit: .meter(), doubleValue: 1.765625),
			start: start, end: start.addingTimeInterval(12.125), device: device,
			metadata: ["Original note": "café 🫀\nRecorded, unchanged", "Original flag": true])
	}

	@MainActor private func fields(in controller: UITableViewController) -> [HealthRecordField] {
		(0..<controller.numberOfSections(in: controller.tableView)).flatMap { section in
			(0..<controller.tableView(controller.tableView, numberOfRowsInSection: section)).map { row in
				let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: row, section: section))
				return HealthRecordField(name: cell.textLabel?.text ?? "", value: cell.detailTextLabel?.text ?? "")
			}
		}
	}

	@MainActor private func path(named name: String, in controller: UITableViewController) throws -> IndexPath {
		for section in 0..<controller.numberOfSections(in: controller.tableView) {
			for row in 0..<controller.tableView(controller.tableView, numberOfRowsInSection: section) {
				let path = IndexPath(row: row, section: section)
				if controller.tableView(controller.tableView, cellForRowAt: path).textLabel?.text == name { return path }
			}
		}
		throw NSError(domain: "HealthDetailTests.MissingField", code: 1, userInfo: [NSLocalizedDescriptionKey: name])
	}

	@MainActor private func drainMainQueue() {
		let drained = expectation(description: "Queued detail updates finished")
		DispatchQueue.main.async { DispatchQueue.main.async { drained.fulfill() } }
		XCTAssertEqual(XCTWaiter.wait(for: [drained], timeout: 3), .completed)
	}

	@MainActor private func attachments(probe: HealthAttachmentLoaderProbe) -> HealthRecordAttachmentsViewController {
		let controller = HealthRecordAttachmentsViewController(record: record())
		controller.loadAttachments = probe.loader
		controller.loadViewIfNeeded()
		return controller
	}

	@MainActor private func status(_ controller: HealthRecordAttachmentsViewController) -> UITableViewCell {
		controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
	}

	@MainActor func testDetailUsesOriginalRecordIdentityDatesDeviceAndMetadataInsteadOfTheProjection() throws {
		let original = record(), fallback = record(at: anchor.addingTimeInterval(86_400))
		let sample = HealthDetailSampleFixture(original: original, fallback: fallback, displayDate: fallback.startDate)
		let detail = HealthRecordDetailViewController(sample: sample)
		detail.loadViewIfNeeded()
		XCTAssertTrue(detail.record === original)
		XCTAssertEqual(sample.reconstructionCount, 0)
		XCTAssertEqual(detail.title, HealthDetailSampleFixture.name)
		XCTAssertEqual(detail.tableView.accessibilityIdentifier, "healthRecordDetails")
		let values = Dictionary(uniqueKeysWithValues: fields(in: detail).map { ($0.name, $0.value) })
		XCTAssertEqual(values["Health UUID"], original.uuid.uuidString)
		XCTAssertEqual(values["Health type"], original.sampleType.identifier)
		XCTAssertEqual(Double(try XCTUnwrap(values["Start reference seconds"]))?.bitPattern,
			original.startDate.timeIntervalSinceReferenceDate.bitPattern)
		XCTAssertEqual(Double(try XCTUnwrap(values["End reference seconds"]))?.bitPattern,
			original.endDate.timeIntervalSinceReferenceDate.bitPattern)
		XCTAssertEqual(values["Source bundle"], original.sourceRevision.source.bundleIdentifier)
		XCTAssertEqual(values["Local device identifier"], "original-local-id")
		XCTAssertEqual(values["UDI device identifier"], "original-udi")
		XCTAssertEqual(values["Original note"], String(reflecting: "café 🫀\nRecorded, unchanged"))
		XCTAssertEqual(values["Original flag"], "true")
		XCTAssertNil(detail.navigationItem.leftBarButtonItem)
		XCTAssertFalse(detail.tableView.isEditing)
		XCTAssertEqual(detail.navigationItem.rightBarButtonItems?.count, 2)
		XCTAssertEqual(detail.navigationItem.rightBarButtonItems?.last?.accessibilityIdentifier, "healthRecordRelatedData")
		let lastSection = detail.numberOfSections(in: detail.tableView) - 1
		XCTAssertTrue(detail.tableView(detail.tableView, titleForFooterInSection: lastSection)?.contains("original Health record") == true)
		let navigation = UINavigationController(rootViewController: detail)
		detail.tableView(detail.tableView, didSelectRowAt: try path(named: "Start reference seconds", in: detail))
		let text = try XCTUnwrap(navigation.topViewController as? HealthFieldTextViewController)
		text.loadViewIfNeeded()
		let view = try XCTUnwrap(text.view as? UITextView)
		XCTAssertFalse(view.isEditable)
		XCTAssertTrue(view.isSelectable)
		XCTAssertEqual(view.text, String(original.startDate.timeIntervalSinceReferenceDate))
	}

	@MainActor func testLocallyConstructedValueDoesNotClaimManufacturedUUIDOrSourceAsOriginalProvenance() {
		let fallback = record()
		let sample = HealthDetailSampleFixture(original: nil, fallback: fallback, displayDate: anchor)
		let detail = HealthRecordDetailViewController(sample: sample)
		detail.loadViewIfNeeded()
		let values = fields(in: detail)
		XCTAssertFalse(values.contains { $0.name == "Health UUID" || $0.name == "Source bundle" })
		XCTAssertTrue(values.contains { $0.name == "Original Health record" && $0.value.contains("Unavailable") })
		XCTAssertTrue(values.contains { $0.name == "Recorded quantity" && $0.value == fallback.quantity.description })
	}

	@MainActor func testRawWorkoutDetailRetainsTheParentAndOffersRelatedDataWithoutStartingARead() throws {
		let workout = HKWorkout(activityType: .walking, start: anchor, end: anchor.addingTimeInterval(60), duration: 45,
			totalEnergyBurned: nil, totalDistance: nil, metadata: ["Workout note": "Original workout"])
		let detail = HealthRecordDetailViewController(record: workout, title: "Recorded workout")
		detail.loadViewIfNeeded()
		XCTAssertTrue(detail.record === workout)
		XCTAssertEqual(detail.title, "Recorded workout")
		XCTAssertTrue(fields(in: detail).contains(.init(name: "Health UUID", value: workout.uuid.uuidString)))
		XCTAssertTrue(fields(in: detail).contains(.init(name: "Duration (s)", value: "45.0")))
		let related = try XCTUnwrap(detail.navigationItem.rightBarButtonItems?.first {
			$0.accessibilityIdentifier == "healthRecordRelatedData"
		}?.menu)
		XCTAssertEqual(related.children.compactMap { ($0 as? UIAction)?.title }, ["Attachments", "Workout routes"])
		XCTAssertNil(detail.navigationItem.prompt)
		XCTAssertTrue(detail.navigationItem.rightBarButtonItems?.allSatisfy { $0.isEnabled } == true)
	}

	@MainActor func testSummaryUsesTheOriginalDateRatherThanTheProjectedDisplayDate() {
		let original = record(), fallback = record(at: anchor.addingTimeInterval(172_800))
		let sample = HealthDetailSampleFixture(original: original, fallback: fallback, displayDate: fallback.startDate)
		let cell = HealthResultSummaryCell.make(in: UITableView(), sample: sample)
		let formatter = DateFormatter()
		formatter.dateStyle = .medium; formatter.timeStyle = .short
		formatter.locale = .autoupdatingCurrent; formatter.timeZone = .autoupdatingCurrent
		XCTAssertEqual(cell.textLabel?.text, HealthDetailSampleFixture.name)
		XCTAssertEqual(cell.detailTextLabel?.text, "Projected value\n" + formatter.string(from: original.startDate))
		XCTAssertEqual(sample.reconstructionCount, 0)
	}

	@MainActor func testLargePayloadPreviewOpensCompleteSelectableReadOnlyText() throws {
		let payload = "{\"resourceType\":\"Observation\",\"note\":\"café 🫀\"}\n" + String(repeating: "α\tquoted \"text\"\n", count: 800)
		let field = HealthRecordField(name: "Original FHIR JSON", value: payload)
		let detail = HealthValueRecordViewController(title: "Clinical record", sections: [.init(title: "Original data", fields: [field])])
		let navigation = UINavigationController(rootViewController: detail)
		detail.loadViewIfNeeded()
		let cell = detail.tableView(detail.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
		XCTAssertEqual(cell.detailTextLabel?.text, String(payload.prefix(1_000)))
		XCTAssertTrue(cell.textLabel?.adjustsFontForContentSizeCategory == true)
		XCTAssertTrue(cell.detailTextLabel?.adjustsFontForContentSizeCategory == true)
		detail.tableView(detail.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		let full = try XCTUnwrap(navigation.topViewController as? HealthFieldTextViewController)
		full.loadViewIfNeeded()
		let text = try XCTUnwrap(full.view as? UITextView)
		XCTAssertEqual(full.field, field)
		XCTAssertEqual(text.text, payload)
		XCTAssertFalse(text.isEditable)
		XCTAssertTrue(text.isSelectable)
		XCTAssertEqual(text.accessibilityIdentifier, "healthRecordFieldText")
	}

	@MainActor func testUndatedValueRecordDisplaysOnlyRecordedFields() {
		let sections = [HealthRecordSection(title: "Medication", fields: [.init(name: "Name", value: "Recorded medicine")])]
		let detail = HealthValueRecordViewController(title: "Medication", sections: sections)
		detail.loadViewIfNeeded()
		XCTAssertEqual(detail.sections, sections)
		XCTAssertEqual(detail.numberOfSections(in: detail.tableView), 1)
		XCTAssertEqual(fields(in: detail), sections[0].fields)
		XCTAssertNil(detail.navigationItem.leftBarButtonItem)
		XCTAssertEqual(detail.tableView.accessibilityIdentifier, "healthValueRecord")
	}

	func testSharingJSONPreservesFullTextUnicodeEscapesDuplicateFieldNamesAndRecordedOrder() throws {
		let payload = "\u{0000}café 🫀\n\t\"quoted\" \\ literal\\n\r\n" + String(repeating: "FHIR α\n", count: 2_000)
		let sections = [
			HealthRecordSection(title: "Second recorded section", fields: [
				.init(name: "Payload", value: payload), .init(name: "Payload", value: "Different recorded value"),
				.init(name: "Empty", value: "")]),
			HealthRecordSection(title: "First recorded section", fields: []),
		]
		let data = try HealthRecordSharing.data(title: "Original \"record\" 🫀", sections: sections)
		XCTAssertEqual(data, try HealthRecordSharing.data(title: "Original \"record\" 🫀", sections: sections))
		let object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
		XCTAssertEqual(Set(object.keys), ["title", "sections"])
		XCTAssertEqual(object["title"] as? String, "Original \"record\" 🫀")
		let exported = try XCTUnwrap(object["sections"] as? [[String: Any]])
		XCTAssertEqual(exported.compactMap { $0["title"] as? String }, sections.map { $0.title })
		let exportedFields = try XCTUnwrap(exported[0]["fields"] as? [[String: String]])
		XCTAssertEqual(exportedFields.map { $0["name"] }, ["Payload", "Payload", "Empty"])
		XCTAssertEqual(exportedFields.map { $0["value"] }, [payload, "Different recorded value", ""])
		XCTAssertEqual(exportedFields[0]["value"]?.data(using: .utf8), payload.data(using: .utf8))
		XCTAssertTrue((exported[1]["fields"] as? [[String: String]])?.isEmpty == true)
	}

	@MainActor func testECGDisplaysRecordedOffsetsAndUnavailableVoltageWithoutInventingMeasurements() {
		let source = record()
		let series = HealthSeriesViewController(series: .ecg([
			.init(timeSinceSampleStart: 0.000125, voltageInMillivolts: 0.875),
			.init(timeSinceSampleStart: 0.0078125, voltageInMillivolts: nil),
			.init(timeSinceSampleStart: 0.01171875, voltageInMillivolts: -0.125),
		]), source: source)
		series.loadViewIfNeeded()
		XCTAssertTrue(series.source === source)
		XCTAssertEqual(series.tableView.accessibilityIdentifier, "healthSeriesMeasurements")
		XCTAssertEqual(series.tableView(series.tableView, numberOfRowsInSection: 0), 3)
		XCTAssertEqual(series.fields(at: 1), [.init(name: "Offset (s)", value: "0.0078125"),
			.init(name: "Voltage (mV)", value: "Unavailable")])
		XCTAssertEqual(series.fields(at: 2).last?.value, "-0.125")
		let cell = series.tableView(series.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
		XCTAssertEqual(cell.textLabel?.text, "0.0078125")
		XCTAssertEqual(cell.detailTextLabel?.text, "Voltage (mV): Unavailable")
		XCTAssertTrue(series.tableView(series.tableView, titleForFooterInSection: 0)?.contains("original ECG start") == true)
	}

	@MainActor func testHeartbeatGapSurvivesOpeningIndividualRecordedMeasurement() throws {
		let series = HealthSeriesViewController(series: .heartbeat([
			.init(timeSinceSeriesStart: 0.875, precededByGap: false),
			.init(timeSinceSeriesStart: 1.625, precededByGap: false),
			.init(timeSinceSeriesStart: 5.125, precededByGap: true),
		]))
		let navigation = UINavigationController(rootViewController: series)
		series.loadViewIfNeeded()
		XCTAssertEqual(series.tableView(series.tableView, numberOfRowsInSection: 0), 3)
		XCTAssertEqual(series.fields(at: 0).last?.value, "No")
		series.tableView(series.tableView, didSelectRowAt: IndexPath(row: 2, section: 0))
		let detail = try XCTUnwrap(navigation.topViewController as? HealthValueRecordViewController)
		XCTAssertEqual(detail.sections, [.init(title: "Recorded measurement", fields: [
			.init(name: "Offset (s)", value: "5.125"), .init(name: "Preceded by a gap", value: "Yes")])])
	}

	@MainActor func testQuantitySeriesKeepsUnequalIntervalsGapsAndExactReferenceInstants() throws {
		let intervals = [DateInterval(start: anchor, duration: 0.125),
			DateInterval(start: anchor.addingTimeInterval(10.375), duration: 4.25)]
		let quantities = [HKQuantity(unit: .meter(), doubleValue: 1.125), HKQuantity(unit: .meter(), doubleValue: 2.875)]
		let series = HealthSeriesViewController(series: .quantity(zip(quantities, intervals).map {
			HealthQuantityMeasurement(quantity: $0.0, dateInterval: $0.1)
		}))
		let navigation = UINavigationController(rootViewController: series)
		series.loadViewIfNeeded()
		XCTAssertEqual(series.tableView(series.tableView, numberOfRowsInSection: 0), 2)
		for row in intervals.indices {
			let values = Dictionary(uniqueKeysWithValues: series.fields(at: row).map { ($0.name, $0.value) })
			XCTAssertEqual(Double(try XCTUnwrap(values["Start reference seconds"]))?.bitPattern,
				intervals[row].start.timeIntervalSinceReferenceDate.bitPattern)
			XCTAssertEqual(Double(try XCTUnwrap(values["End reference seconds"]))?.bitPattern,
				intervals[row].end.timeIntervalSinceReferenceDate.bitPattern)
			XCTAssertEqual(values["Quantity"], quantities[row].description)
		}
		series.tableView(series.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		let detail = try XCTUnwrap(navigation.topViewController as? HealthValueRecordViewController)
		XCTAssertEqual(detail.sections.first?.fields, series.fields(at: 1))
		XCTAssertTrue(series.tableView(series.tableView, titleForFooterInSection: 0)?.contains("different interval lengths") == true)
	}

	@MainActor func testRouteDisplaysOriginalCoordinatesAccuracyTimestampAndUnknownMotion() throws {
		let locations = [
			CLLocation(coordinate: .init(latitude: 40.125, longitude: -73.875), altitude: 12.5,
				horizontalAccuracy: 3.75, verticalAccuracy: 5.25, course: -1, speed: -1, timestamp: anchor),
			CLLocation(coordinate: .init(latitude: 40.25, longitude: -73.75), altitude: 18.75,
				horizontalAccuracy: 2.5, verticalAccuracy: 4.5, course: 270.125, speed: 2.875,
				timestamp: anchor.addingTimeInterval(90.125)),
		]
		let series = HealthSeriesViewController(series: .route(locations.map { HealthRouteLocation(location: $0) }))
		series.loadViewIfNeeded()
		XCTAssertEqual(series.tableView(series.tableView, numberOfRowsInSection: 0), 2)
		let first = Dictionary(uniqueKeysWithValues: series.fields(at: 0).map { ($0.name, $0.value) })
		XCTAssertEqual(Double(try XCTUnwrap(first["Timestamp reference seconds"]))?.bitPattern,
			anchor.timeIntervalSinceReferenceDate.bitPattern)
		XCTAssertEqual(first["Latitude"], "40.125")
		XCTAssertEqual(first["Longitude"], "-73.875")
		XCTAssertEqual(first["Altitude (m)"], "12.5")
		XCTAssertEqual(first["Horizontal accuracy (m)"], "3.75")
		XCTAssertEqual(first["Vertical accuracy (m)"], "5.25")
		XCTAssertEqual(first["Speed (m/s)"], "Unavailable")
		XCTAssertEqual(first["Course (degrees)"], "Unavailable")
		let second = Dictionary(uniqueKeysWithValues: series.fields(at: 1).map { ($0.name, $0.value) })
		XCTAssertEqual(second["Speed (m/s)"], "2.875")
		XCTAssertEqual(second["Course (degrees)"], "270.125")
		XCTAssertEqual(Double(try XCTUnwrap(second["Timestamp reference seconds"]))?.bitPattern,
			locations[1].timestamp.timeIntervalSinceReferenceDate.bitPattern)
	}

	@MainActor func testEmptySeriesOfEveryKindHasNoInventedRow() {
		let snapshots: [HealthSeriesSnapshot] = [.ecg([]), .heartbeat([]), .quantity([]), .route([])]
		for snapshot in snapshots {
			let series = HealthSeriesViewController(series: snapshot)
			series.loadViewIfNeeded()
			XCTAssertEqual(series.tableView(series.tableView, numberOfRowsInSection: 0), 0)
			XCTAssertNotNil(series.tableView(series.tableView, titleForFooterInSection: 0))
		}
	}

	@MainActor func testAttachmentLoaderReceivesExactParentAndEmptyReadExplainsVisibility() {
		let probe = HealthAttachmentLoaderProbe(), controller = attachments(probe: probe)
		XCTAssertEqual(probe.requests.count, 1)
		XCTAssertTrue(probe.requests[0].record === controller.record)
		XCTAssertEqual(controller.tableView.accessibilityIdentifier, "healthRecordAttachments")
		XCTAssertEqual(status(controller).textLabel?.text, "Reading attachments…")
		controller.refreshControl?.beginRefreshing()
		probe.requests[0].completion(.success([]))
		drainMainQueue()
		XCTAssertEqual(status(controller).textLabel?.text, "No attachments returned")
		XCTAssertNil(status(controller).detailTextLabel?.text)
		XCTAssertFalse(controller.refreshControl?.isRefreshing == true)
		XCTAssertTrue(controller.tableView(controller.tableView, titleForFooterInSection: 0)?.contains("shared with this app") == true)
		let navigation = UINavigationController(rootViewController: controller)
		controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		controller.tableView(controller.tableView, accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 0))
		XCTAssertTrue(navigation.topViewController === controller)
	}

	@MainActor func testAttachmentErrorRetainsItsMessageAndReloadRecovers() {
		let probe = HealthAttachmentLoaderProbe(), controller = attachments(probe: probe)
		probe.requests[0].completion(.failure(NSError(domain: "AttachmentFixture", code: 47,
			userInfo: [NSLocalizedDescriptionKey: "Fixture attachment read failed"])))
		drainMainQueue()
		XCTAssertEqual(status(controller).textLabel?.text, "Could not read attachments")
		XCTAssertEqual(status(controller).detailTextLabel?.text, "Fixture attachment read failed")
		controller.reloadAttachments()
		XCTAssertEqual(probe.requests.count, 2)
		XCTAssertEqual(probe.requests[0].cancellationCount, 0, "Completed reads must release their cancellation operation")
		XCTAssertEqual(status(controller).textLabel?.text, "Reading attachments…")
		XCTAssertNil(status(controller).detailTextLabel?.text)
		probe.requests[1].completion(.success([]))
		drainMainQueue()
		XCTAssertEqual(status(controller).textLabel?.text, "No attachments returned")
	}

	@MainActor func testAttachmentReloadCancelsPreviousReadAndRejectsLateAndDuplicateCompletions() {
		let probe = HealthAttachmentLoaderProbe(), controller = attachments(probe: probe)
		let previous = probe.requests[0]
		controller.reloadAttachments()
		XCTAssertEqual(previous.cancellationCount, 1)
		let current = probe.requests[1]
		previous.completion(.failure(NSError(domain: "StaleAttachmentRead", code: 1)))
		drainMainQueue()
		XCTAssertEqual(status(controller).textLabel?.text, "Reading attachments…")
		current.completion(.success([]))
		drainMainQueue()
		previous.completion(.failure(NSError(domain: "StaleAttachmentRead", code: 2)))
		current.completion(.failure(NSError(domain: "DuplicateAttachmentRead", code: 3)))
		drainMainQueue()
		XCTAssertEqual(status(controller).textLabel?.text, "No attachments returned")
		XCTAssertNil(status(controller).detailTextLabel?.text)
		controller.reloadAttachments()
		XCTAssertEqual(previous.cancellationCount, 1)
		XCTAssertEqual(current.cancellationCount, 0)
		probe.requests[2].completion(.success([]))
		drainMainQueue()
	}

	@MainActor func testAttachmentCompletionReleasesCancellationOwnershipForSuccessAndFailure() {
		weak var lease: HealthAttachmentCancellationLease?
		var completion: ((Result<[HKAttachment], Error>) -> Void)?
		let controller = HealthRecordAttachmentsViewController(record: record())
		controller.loadAttachments = { _, finish in
			let active = HealthAttachmentCancellationLease()
			lease = active; completion = finish
			return { active.cancellationCount += 1 }
		}
		controller.loadViewIfNeeded()
		XCTAssertNotNil(lease)
		completion?(.success([]))
		drainMainQueue()
		XCTAssertNil(lease)
		controller.reloadAttachments()
		XCTAssertNotNil(lease)
		completion?(.failure(NSError(domain: "AttachmentOwnership", code: 4)))
		drainMainQueue()
		XCTAssertNil(lease)
	}

	@MainActor func testRetainedAttachmentLoaderCallbackDoesNotKeepControllerAliveAndDeinitCancelsOnce() {
		let probe = HealthAttachmentLoaderProbe()
		weak var released: HealthRecordAttachmentsViewController?
		autoreleasepool {
			let controller = attachments(probe: probe)
			released = controller
		}
		XCTAssertNil(released)
		XCTAssertEqual(probe.requests[0].cancellationCount, 1)
		probe.requests[0].completion(.success([]))
		drainMainQueue()
		XCTAssertEqual(probe.requests[0].cancellationCount, 1)
	}

	@MainActor func testPoppingAttachmentsCancelsReadAndRejectsItsLateCompletionBeforeRetry() {
		let probe = HealthAttachmentLoaderProbe(), controller = attachments(probe: probe)
		let navigation = UINavigationController(rootViewController: UIViewController())
		navigation.loadViewIfNeeded()
		navigation.beginAppearanceTransition(true, animated: false)
		navigation.endAppearanceTransition()
		navigation.pushViewController(controller, animated: false)
		XCTAssertTrue(navigation.popViewController(animated: false) === controller)
		XCTAssertEqual(probe.requests[0].cancellationCount, 1)
		probe.requests[0].completion(.failure(NSError(domain: "PoppedAttachmentRead", code: 5)))
		drainMainQueue()
		XCTAssertNil(status(controller).detailTextLabel?.text)
		controller.reloadAttachments()
		XCTAssertEqual(probe.requests[0].cancellationCount, 1)
		probe.requests[1].completion(.success([]))
		drainMainQueue()
		XCTAssertEqual(status(controller).textLabel?.text, "No attachments returned")
		navigation.beginAppearanceTransition(false, animated: false)
		navigation.endAppearanceTransition()
	}

	@MainActor func testReplacingAttachmentsBeforeAppearanceCancelsOnceAndEndsRefreshing() {
		let controller = HealthRecordAttachmentsViewController(record: record())
		var cancellations = 0
		controller.loadAttachments = { _, completion in
			return {
				cancellations += 1
				completion(.failure(NSError(domain: "SynchronousAttachmentCancellation", code: 6)))
			}
		}
		controller.loadViewIfNeeded()
		controller.refreshControl?.beginRefreshing()
		let navigation = UINavigationController(rootViewController: controller)
		XCTAssertTrue(controller.parent === navigation)
		XCTAssertNil(controller.view.window)
		navigation.setViewControllers([UIViewController()], animated: false)
		XCTAssertNil(controller.parent)
		XCTAssertEqual(cancellations, 1)
		drainMainQueue()
		XCTAssertNil(status(controller).detailTextLabel?.text)
		XCTAssertFalse(controller.refreshControl?.isRefreshing == true)
		XCTAssertTrue(controller.tableView.isUserInteractionEnabled)
		XCTAssertNil(controller.navigationItem.prompt)
		XCTAssertEqual(cancellations, 1)
	}

	@MainActor func testPoppingDetailBeforeAppearanceCancelsMeasurementsAndAllowsANewRead() throws {
		let source = record()
		let controller = HealthRecordDetailViewController(record: source, title: "Recorded measurement")
		var completions: [(Result<HealthSeriesSnapshot, Error>) -> Void] = []
		var cancellations = 0
		controller.loadSeries = { sample, completion in
			XCTAssertTrue(sample === source)
			completions.append(completion)
			return {
				cancellations += 1
				completion(.failure(NSError(domain: "SynchronousSeriesCancellation", code: 7)))
			}
		}
		let root = UIViewController(), navigation = UINavigationController(rootViewController: root)
		navigation.pushViewController(controller, animated: false)
		controller.loadViewIfNeeded()
		controller.showMeasurements()
		XCTAssertNil(controller.view.window)
		XCTAssertNotNil(controller.navigationItem.prompt)
		XCTAssertTrue(controller.navigationItem.rightBarButtonItems?.allSatisfy { !$0.isEnabled } == true)
		XCTAssertTrue(navigation.popViewController(animated: false) === controller)
		XCTAssertEqual(cancellations, 1)
		XCTAssertNil(controller.parent)
		XCTAssertNil(controller.navigationItem.prompt)
		XCTAssertTrue(controller.navigationItem.rightBarButtonItems?.allSatisfy { $0.isEnabled } == true)
		drainMainQueue()
		XCTAssertNil(controller.presentedViewController)
		XCTAssertTrue(navigation.topViewController === root)
		navigation.pushViewController(controller, animated: false)
		controller.showMeasurements()
		XCTAssertEqual(completions.count, 2)
		XCTAssertEqual(cancellations, 1)
		completions[0](.success(.quantity([])))
		drainMainQueue()
		XCTAssertTrue(navigation.topViewController === controller)
		XCTAssertNotNil(controller.navigationItem.prompt)
		completions[1](.success(.quantity([])))
		drainMainQueue()
		let measurements = try XCTUnwrap(navigation.topViewController as? HealthSeriesViewController)
		XCTAssertTrue(measurements.source === controller.record)
		XCTAssertNil(controller.navigationItem.prompt)
		XCTAssertTrue(controller.navigationItem.rightBarButtonItems?.allSatisfy { $0.isEnabled } == true)
		XCTAssertEqual(cancellations, 1)
	}

	@MainActor func testCoveringDetailKeepsItsMeasurementReadActive() {
		let controller = HealthRecordDetailViewController(record: record(), title: "Recorded measurement")
		var completion: ((Result<HealthSeriesSnapshot, Error>) -> Void)?
		var cancellations = 0
		controller.loadSeries = { _, finish in completion = finish; return { cancellations += 1 } }
		controller.loadViewIfNeeded()
		let navigation = UINavigationController(rootViewController: controller)
		controller.showMeasurements()
		navigation.pushViewController(UIViewController(), animated: false)
		XCTAssertTrue(controller.parent === navigation)
		XCTAssertEqual(cancellations, 0)
		XCTAssertNotNil(controller.navigationItem.prompt)
		_ = navigation.popViewController(animated: false)
		completion?(.success(.quantity([])))
		drainMainQueue()
		XCTAssertTrue(navigation.topViewController is HealthSeriesViewController)
		XCTAssertNil(controller.navigationItem.prompt)
		XCTAssertEqual(cancellations, 0)
	}

	@MainActor func testCoveringAttachmentsWithAnotherControllerKeepsItsReadActive() {
		let probe = HealthAttachmentLoaderProbe(), controller = attachments(probe: probe)
		let navigation = UINavigationController(rootViewController: controller)
		navigation.loadViewIfNeeded()
		navigation.beginAppearanceTransition(true, animated: false)
		navigation.endAppearanceTransition()
		navigation.pushViewController(UIViewController(), animated: false)
		XCTAssertEqual(probe.requests[0].cancellationCount, 0)
		probe.requests[0].completion(.success([]))
		drainMainQueue()
		XCTAssertEqual(status(controller).textLabel?.text, "No attachments returned")
		_ = navigation.popViewController(animated: false)
		XCTAssertEqual(probe.requests.count, 1)
		XCTAssertEqual(probe.requests[0].cancellationCount, 0)
		navigation.beginAppearanceTransition(false, animated: false)
		navigation.endAppearanceTransition()
	}
}
