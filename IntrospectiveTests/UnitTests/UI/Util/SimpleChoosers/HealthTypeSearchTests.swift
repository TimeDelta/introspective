import XCTest
import UIKit
import SwiftyMocky
@testable import Introspective
@testable import Common
@testable import Samples

final class HealthTypeSearchTests: UnitTest {
	private let types: [Sample.Type] = [Steps.self, HeartRate.self, MoodImpl.self]

	private func descriptor(_ id: Int16, name: String, group: String, identifier: String) -> HealthTypeDescriptor {
		HealthTypeDescriptor(id: id, identifier: identifier, name: name, group: group,
			family: .quantity, minimumOS: "18.0")
	}

	private func chooser(selected: Sample.Type? = nil) -> ChooseSampleTypeViewControllerImpl {
		Given(mockSampleFactory, .allTypes(willReturn: types))
		let storyboard = UIStoryboard(name: "Util", bundle: Bundle(for: ChooseSampleTypeViewControllerImpl.self))
		let controller = storyboard.instantiateViewController(withIdentifier: "chooseSampleType") as! ChooseSampleTypeViewControllerImpl
		controller.selectedSampleType = selected
		controller.notificationToSendOnAccept = .sampleTypeEdited
		controller.loadViewIfNeeded()
		return controller
	}

	private func path(for type: Sample.Type, in controller: SampleTypeSearchViewController) throws -> IndexPath {
		for (section, group) in controller.sections.enumerated() {
			if let row = group.items.firstIndex(where: { $0.sampleType == type }) { return IndexPath(row: row, section: section) }
		}
		XCTFail("Expected a search result for the supplied sample type")
		return try XCTUnwrap(nil as IndexPath?)
	}

	func testSearchMatchesEveryTermAcrossNamesGroupsAndIdentifiersWithoutCaseOrAccentSensitivity() {
		let heart = descriptor(21, name: "Heart Rate", group: "Café Cardiology", identifier: "HKQuantityTypeIdentifierPulse")
		let model = SampleTypeSearchModel(types: types) { $0 == HeartRate.self ? heart : nil }
		let matches = model.sections(matching: "  CAFE pulse HEART  ").flatMap { $0.items }
		XCTAssertEqual(matches.count, 1)
		XCTAssertTrue(matches.first.map { $0.sampleType == HeartRate.self } ?? false)
		XCTAssertEqual(matches.first?.originalIndex, 1)
		XCTAssertTrue(model.sections(matching: "heart unknown-term").isEmpty)
	}

	func testCatalogCapitalizationIsPreservedWhileLegacyWheelTitlesAndOriginalOrderStayUnchanged() {
		let modern = descriptor(21, name: "HbA1c", group: "Laboratory", identifier: "HKQuantityTypeIdentifierHbA1c")
		let legacy = descriptor(14, name: "Different catalog spelling", group: "Activity", identifier: "HKQuantityTypeIdentifierStepCount")
		let model = SampleTypeSearchModel(types: types) { type in
			if type == HeartRate.self { return modern }
			if type == Steps.self { return legacy }
			return nil
		}
		XCTAssertEqual(model.items.map { $0.title }, [Steps.name.localizedCapitalized, "HbA1c", MoodImpl.name.localizedCapitalized])
		XCTAssertEqual(model.items.map { $0.originalIndex }, [0, 1, 2])
		for (index, item) in model.items.enumerated() { XCTAssertTrue(item.sampleType == types[index]) }
		let matches = model.sections(matching: "laboratory").flatMap { $0.items }
		XCTAssertEqual(matches.count, 1)
		XCTAssertTrue(matches.first.map { $0.sampleType == HeartRate.self } ?? false)
	}

	func testEqualDisplayNamesRemainDistinctAndUseOriginalIndexesForStableSelection() {
		let model = SampleTypeSearchModel(types: [HeartRate.self, Steps.self]) { type in
			self.descriptor(type == HeartRate.self ? 21 : 22, name: "Same name", group: "Health", identifier: "identifier")
		}
		let items = model.sections(matching: "same").flatMap { $0.items }
		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(items.map { $0.originalIndex }, [0, 1])
		XCTAssertTrue(items[0].sampleType == HeartRate.self)
		XCTAssertTrue(items[1].sampleType == Steps.self)
	}

	func testChooserCapturesFactoryTypesOnceAndKeepsWheelIndexesEvenIfTheFactoryLaterChanges() {
		let controller = chooser(selected: MoodImpl.self)
		XCTAssertEqual(controller.sampleTypePicker.selectedRow(inComponent: 0), 2)
		Given(mockSampleFactory, .allTypes(willReturn: [Weight.self]))
		XCTAssertEqual(controller.pickerView(controller.sampleTypePicker, numberOfRowsInComponent: 0), 3)
		XCTAssertEqual(controller.pickerView(controller.sampleTypePicker, titleForRow: 0, forComponent: 0), Steps.name.localizedCapitalized)
		controller.pickerView(controller.sampleTypePicker, didSelectRow: 1, inComponent: 0)
		XCTAssertTrue(controller.selectedSampleType.map { $0 == HeartRate.self } ?? false)
		Verify(mockSampleFactory, .once, .allTypes())
	}

	func testSelectingAFilteredResultUpdatesTheOriginalWheelAndAcceptsTheSameTypeExactlyOnce() throws {
		let controller = chooser(selected: MoodImpl.self)
		var accepted: [Sample.Type] = []
		Perform(mockNotificationUtil, .post(.value(NotificationName.sampleTypeEdited), object: .any, userInfo: .any, qos: .any,
			perform: { _, _, values, _ in
				if let type = values?[.sampleType] as? Sample.Type { accepted.append(type) }
			}))
		let search = controller.makeSearchController()
		search.loadViewIfNeeded()
		search.applySearch("heart rate")
		let chosen = try path(for: HeartRate.self, in: search)
		search.tableView(search.tableView, didSelectRowAt: chosen)
		search.tableView(search.tableView, didSelectRowAt: chosen)
		XCTAssertTrue(controller.selectedSampleType.map { $0 == HeartRate.self } ?? false)
		XCTAssertEqual(controller.sampleTypePicker.selectedRow(inComponent: 0), 1)
		XCTAssertTrue(accepted.isEmpty, "Searching chooses a type; the original Save action still accepts it")
		controller.userPressedAccept(self)
		XCTAssertEqual(accepted.count, 1)
		XCTAssertTrue(accepted.first.map { $0 == HeartRate.self } ?? false)
		Verify(mockSampleFactory, .once, .allTypes())
	}

	func testCancellingSearchPreservesTheOriginalTypeAndWheelSelection() throws {
		let controller = chooser(selected: MoodImpl.self)
		let search = controller.makeSearchController()
		search.loadViewIfNeeded()
		search.applySearch("heart rate")
		let candidate = try path(for: HeartRate.self, in: search)
		search.cancelSearch()
		search.tableView(search.tableView, didSelectRowAt: candidate)
		XCTAssertTrue(controller.selectedSampleType.map { $0 == MoodImpl.self } ?? false)
		XCTAssertEqual(controller.sampleTypePicker.selectedRow(inComponent: 0), 2)
		Verify(mockNotificationUtil, .never, .post(.value(NotificationName.sampleTypeEdited), object: .any, userInfo: .any, qos: .any))
	}

	func testNoMatchesAndEmptyAvailabilityAreExplicitAndCannotAcceptAnOutOfBoundsSelection() {
		let search = SampleTypeSearchViewController(model: SampleTypeSearchModel(types: types), selectedType: nil) { _ in
			XCTFail("A missing search result must not choose a type")
		}
		search.loadViewIfNeeded(); search.applySearch("no-matching-type-123")
		XCTAssertEqual(search.numberOfSections(in: search.tableView), 0)
		XCTAssertEqual((search.tableView.backgroundView as? UILabel)?.text, "No matching data types.")
		search.tableView(search.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		search.applySearch("")
		XCTAssertNil(search.tableView.backgroundView)

		Given(mockSampleFactory, .allTypes(willReturn: []))
		let storyboard = UIStoryboard(name: "Util", bundle: Bundle(for: ChooseSampleTypeViewControllerImpl.self))
		let empty = storyboard.instantiateViewController(withIdentifier: "chooseSampleType") as! ChooseSampleTypeViewControllerImpl
		empty.notificationToSendOnAccept = .sampleTypeEdited
		empty.loadViewIfNeeded(); empty.userPressedAccept(self)
		XCTAssertEqual(empty.pickerView(empty.sampleTypePicker, numberOfRowsInComponent: 0), 0)
		XCTAssertNil(empty.pickerView(empty.sampleTypePicker, titleForRow: 0, forComponent: 0))
		Verify(mockNotificationUtil, .never, .post(.value(NotificationName.sampleTypeEdited), object: .any, userInfo: .any, qos: .any))
	}

	func testSearchAndOriginalSaveRemainSeparateFromTheLegacyPickerWithoutOverlapping() throws {
		let controller = chooser()
		controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
		controller.view.setNeedsLayout(); controller.view.layoutIfNeeded()
		let buttons = controller.view.subviews.compactMap { $0 as? UIButton }
		let save = try XCTUnwrap(buttons.first { $0.accessibilityIdentifier == "save button" })
		let search = try XCTUnwrap(buttons.first { $0.accessibilityIdentifier == "search data types" })
		XCTAssertEqual(controller.sampleTypePicker.accessibilityIdentifier, "data type picker")
		XCTAssertTrue(controller.selectedSampleType.map { $0 == Steps.self } ?? false)
		let browser = controller.makeSearchController()
		let first = try path(for: Steps.self, in: browser)
		XCTAssertEqual(browser.tableView(browser.tableView, cellForRowAt: first).accessoryType, .checkmark)
		XCTAssertFalse(save.frame.intersects(search.frame))
		XCTAssertFalse(controller.sampleTypePicker.frame.intersects(save.frame))
		XCTAssertFalse(controller.sampleTypePicker.frame.intersects(search.frame))
		for button in [save, search] {
			XCTAssertGreaterThanOrEqual(button.frame.width, 44)
			XCTAssertGreaterThanOrEqual(button.frame.height, 44)
			XCTAssertTrue(controller.view.bounds.contains(button.frame))
		}
	}

	func testSearchCallbackDoesNotRetainTheOriginalChooser() {
		var search: SampleTypeSearchViewController?
		weak var released: ChooseSampleTypeViewControllerImpl?
		autoreleasepool {
			let controller = chooser(selected: MoodImpl.self)
			released = controller
			search = controller.makeSearchController()
		}
		XCTAssertNil(released)
		XCTAssertNotNil(search, "The independent search snapshot can outlive its original chooser")
		search?.cancelSearch()
	}
}
