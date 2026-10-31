//
//  Test.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import UIKit
import CoreData
import SwiftyMocky
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import DataExport
@testable import DataImport
@testable import DependencyInjection
@testable import Notifications
@testable import Persistence
@testable import Queries
@testable import Samples
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Settings
@testable import UIExtensions

final class GeneratedMockConcurrencyTests: UnitTest {
	func testConcurrentDependencyCallsAndPropertyReadsKeepEveryInvocation() {
		Matcher.default.register(String.Type.self) { $0 == $1 }
		let provider = InjectionProviderMock()
		Given(provider, .types(getter: [String.self]))
		Given(provider, .get(.any, willReturn: "value"))
		DispatchQueue.concurrentPerform(iterations: 1000) { _ in
			do {
				let value = try provider.get(String.self)
				XCTAssertEqual(value, "value")
			} catch {
				XCTFail("Concurrent dependency resolution threw: \(error)")
			}
			XCTAssertEqual(provider.types.count, 1)
		}
		Verify(provider, .exactly(1000), .get(.value(String.self)))
	}

	func testProviderReplacementConfiguresMocksBeforeRetiredObjectsResolveDependencies() {
		var resolvedDuringRetirement: Database?
		var retiring: RetiringDatabaseProvider? = RetiringDatabaseProvider(database: mockDatabase) {
			resolvedDuringRetirement = injected(Database.self)
		}
		DependencyInjector.register([retiring!])
		retiring = nil // The registry now owns the retiring provider's lifetime.

		registerTypesWithDependencyInjection()

		XCTAssertTrue((resolvedDuringRetirement as? DatabaseMock) === mockDatabase)
	}

	private final class RetiringDatabaseProvider: InjectionProvider {
		let types: [Any.Type] = [Database.self]
		private let database: Database
		private let onRetirement: () -> Void

		init(database: Database, onRetirement: @escaping () -> Void) {
			self.database = database
			self.onRetirement = onRetirement
		}

		func get<Type>(_: Type.Type) throws -> Type {
			database as! Type
		}

		deinit { onRetirement() }
	}
}

final class ImporterHydrationTests: UnitTest {
	private let entityNames = [ATrackerActivityImporterImpl.entityName, IntrospectiveActivityImporterImpl.entityName,
		EasyPillMedicationImporterImpl.entityName, EasyPillMedicationDoseImporterImpl.entityName,
		IntrospectiveMedicationImporterImpl.entityName, IntrospectiveMoodImporterImpl.entityName,
		WellnessMoodImporterImpl.entityName]

	func testInsertingAndFetchingAllImporterTypesDoesNotOpenTransactions() throws {
		let store = try makeStore()
		let context = store.viewContext
		for name in entityNames { _ = NSEntityDescription.insertNewObject(forEntityName: name, into: context) }
		try context.save()
		context.reset()
		for name in entityNames {
			let objects = try context.fetch(NSFetchRequest<NSManagedObject>(entityName: name))
			XCTAssertEqual(objects.count, 1)
			let importer = try XCTUnwrap(objects.first as? Importer)
			XCTAssertFalse(importer.isCancelled)
			XCTAssertFalse(importer.isPaused)
		}
		Verify(mockDatabase, .never, .transaction())
		Verify(injectionProvider, .never, .get(.value(Database.self)))
	}

	func testQueuedImporterMergeDoesNotResolveAReplacementDatabase() throws {
		let store = try makeStore()
		let context = store.viewContext
		context.automaticallyMergesChangesFromParent = true
		// Allow construction on the writing side; the replacement deliberately
		// has no transaction stub, reproducing the delayed-merge failure.
		Given(mockDatabase, .transaction(willReturn: TransactionMock()))
		let merged = expectation(description: "All importer records merged on the main context")
		let names = Set(entityNames)
		var observed = false
		let observer = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange,
			object: context, queue: nil) { notification in
			let inserted = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
			if !observed && names.isSubset(of: Set(inserted.compactMap { $0.entity.name })) {
				observed = true
				merged.fulfill()
			}
		}
		defer { NotificationCenter.default.removeObserver(observer) }
		let writer = store.newBackgroundContext()
		var saveError: Error?
		writer.performAndWait {
			for name in entityNames { _ = NSEntityDescription.insertNewObject(forEntityName: name, into: writer) }
			do { try writer.save() } catch { saveError = error }
		}
		if let error = saveError { throw error }
		registerTypesWithDependencyInjection()
		wait(for: [merged], timeout: 5)
		Verify(mockDatabase, .never, .transaction())
		Verify(injectionProvider, .never, .get(.value(Database.self)))
	}

	private func makeStore() throws -> NSPersistentContainer {
		let store = NSPersistentContainer(name: "Importer hydration", managedObjectModel: ObjectModelContainer.objectModel)
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		description.shouldAddStoreAsynchronously = false
		store.persistentStoreDescriptions = [description]
		var loadError: Error?
		store.loadPersistentStores { _, error in loadError = error }
		if let error = loadError { throw error }
		return store
	}
}

final class ManagedObjectLifecycleTests: UnitTest {
	func testMainContextObjectsDeallocateWithoutResolvingDatabase() throws {
		try assertObjectsDeallocate(on: .mainQueueConcurrencyType)
	}

	func testPrivateContextObjectsDeallocateWithoutResolvingDatabase() throws {
		try assertObjectsDeallocate(on: .privateQueueConcurrencyType)
	}

	private func assertObjectsDeallocate(on queue: NSManagedObjectContextConcurrencyType,
		file: StaticString = #file, line: UInt = #line) throws {
		let model = ObjectModelContainer.objectModel
		let entityNames = [Activity.entityName, ActivityDefinition.entityName, Medication.entityName, MedicationDose.entityName]
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
		let context = NSManagedObjectContext(concurrencyType: queue)
		context.persistentStoreCoordinator = coordinator
		var references = [WeakManagedObject]()
		injectionProvider.resetMock(.invocation)
		context.performAndWait {
			autoreleasepool {
				for name in entityNames {
					let object = NSEntityDescription.insertNewObject(forEntityName: name, into: context)
					references.append(WeakManagedObject(object))
				}
				context.reset()
			}
		}
		XCTAssertEqual(references.count, 4, file: file, line: line)
		XCTAssertTrue(references.allSatisfy { $0.value == nil }, "Reset objects should be released", file: file, line: line)
		Verify(injectionProvider, .never, .get(.value(Database.self)))
	}

	private final class WeakManagedObject {
		weak var value: NSManagedObject?
		init(_ value: NSManagedObject) { self.value = value }
	}
}

final class ManagedObjectCleanupFunctionalTests: FunctionalTest {
	func testCleanupRefaultsPrivateContextObjectWithoutRefaultingMainRecord() throws {
		let original = MoodDataTestUtil.createMood(rating: 4)
		XCTAssertEqual(original.rating, 4) // Realize the main-context record.
		let identifier = original.objectID
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		context.persistentStoreCoordinator = try XCTUnwrap(original.managedObjectContext?.persistentStoreCoordinator)
		var operationError: Error?
		context.performAndWait {
			do {
				let object = try XCTUnwrap(context.existingObject(with: identifier) as? MoodImpl)
				XCTAssertEqual(object.rating, 4)
				XCTAssertFalse(object.isFault)
				database.cleanUpManagedObjectWithStrongReferenceCycle(object)
				XCTAssertTrue(object.isFault)
				XCTAssertEqual(object.rating, 4)
			} catch { operationError = error }
		}
		if let error = operationError { throw error }
		XCTAssertFalse(original.isFault)
		XCTAssertEqual(original.rating, 4)
	}
}

final class MoodEditorCellBehaviorTests: UnitTest {
	override func setUp() {
		super.setUp()
		Given(mockSettings, .minMood(getter: 1))
		Given(mockSettings, .maxMood(getter: 10))
		Given(mockMoodUiUtil, .valueToString(.any, willReturn: "value"))
		Given(mockMoodUiUtil, .colorForMood(rating: .any, minRating: .any, maxRating: .any, willReturn: .white))
		Given(mockSettings, .minFatigue(getter: 1))
		Given(mockSettings, .maxFatigue(getter: 10))
		Given(mockSettings, .minPain(getter: 1))
		Given(mockSettings, .maxPain(getter: 10))
		Matcher.default.register(FatigueUiUtil.Protocol.self) { _, _ in true }
		Matcher.default.register(PainUiUtil.Protocol.self) { _, _ in true }
		Given(injectionProvider, .get(.value(FatigueUiUtil.self), willReturn: FatigueUiUtilImpl()))
		Given(injectionProvider, .get(.value(PainUiUtil.self), willReturn: PainUiUtilImpl()))
	}

	func testMoodSliderMapsTheEntireNonzeroMinimumScaleInBothDirections() {
		let cell = ratingCell(min: 2, max: 10)
		for (rating, fraction) in [(2.0, Float(0)), (6.0, Float(0.5)), (10.0, Float(1))] {
			cell.rating = rating
			XCTAssertEqual(cell.ratingSlider.value, fraction, accuracy: 0.000001)
			cell.ratingSlider.value = fraction
			cell.sliderValueChanged(self)
			XCTAssertEqual(cell.rating, rating, accuracy: 0.000001)
		}
	}

	func testMoodSliderMapsNegativeRatingsAndZeroWithoutLosingItsScale() {
		let cell = ratingCell(min: -5, max: 5)
		for (rating, fraction) in [(-5.0, Float(0)), (0.0, Float(0.5)), (5.0, Float(1))] {
			cell.rating = rating
			XCTAssertEqual(cell.ratingSlider.value, fraction, accuracy: 0.000001)
			cell.ratingSlider.value = fraction
			cell.sliderValueChanged(self)
			XCTAssertEqual(cell.rating, rating, accuracy: 0.000001)
		}
	}

	func testConstantMoodScaleDisablesTheSliderAndKeepsItsOnlyRatingFinite() {
		let cell = ratingCell(min: 4, max: 4)
		XCTAssertFalse(cell.ratingSlider.isEnabled)
		XCTAssertEqual(cell.ratingSlider.value, 0)
		XCTAssertTrue(cell.ratingSlider.value.isFinite)
		cell.ratingSlider.value = 1
		cell.sliderValueChanged(self)
		XCTAssertEqual(cell.rating, 4)
		XCTAssertTrue(cell.rating.isFinite)
		XCTAssertEqual(cell.ratingSlider.value, 0)
	}

	func testBindingAndReloadingNoteCellsDoesNotRequestKeyboardFocus() {
		let moodView = FocusProbeTextView()
		let mood = MoodNoteTableViewCell()
		mood.noteView = moodView
		mood.note = "original"
		mood.note = "updated"
		let fatigueView = FocusProbeTextView()
		let fatigue = FatigueNoteTableViewCell()
		fatigue.noteView = fatigueView
		fatigue.note = "original"
		fatigue.note = "updated"
		let painView = FocusProbeTextView()
		let pain = PainNoteTableViewCell()
		pain.noteView = painView
		pain.note = "original"
		pain.note = "updated"
		for view in [moodView, fatigueView, painView] {
			XCTAssertEqual(view.focusRequests, 0)
			XCTAssertEqual(view.text, "updated")
		}
	}

	func testNoteCellsPublishEachEditBeforeTheDelegateReturns() {
		let mood = MoodNoteTableViewCell()
		let moodView = UITextView()
		mood.noteView = moodView
		mood.note = "original"
		mood.notificationToSendOnChange = Notification.Name("MoodNoteSnapshot-" + UUID().uuidString)
		assertNoteSnapshots(cell: mood, view: moodView, name: mood.notificationToSendOnChange) {
			mood.textViewDidChange(moodView)
		}
		let fatigue = FatigueNoteTableViewCell()
		let fatigueView = UITextView()
		fatigue.noteView = fatigueView
		fatigue.note = "original"
		fatigue.notificationToSendOnChange = Notification.Name("FatigueNoteSnapshot-" + UUID().uuidString)
		assertNoteSnapshots(cell: fatigue, view: fatigueView, name: fatigue.notificationToSendOnChange) {
			fatigue.textViewDidChange(fatigueView)
		}
		let pain = PainNoteTableViewCell()
		let painView = UITextView()
		pain.noteView = painView
		pain.note = "original"
		pain.notificationToSendOnChange = Notification.Name("PainNoteSnapshot-" + UUID().uuidString)
		assertNoteSnapshots(cell: pain, view: painView, name: pain.notificationToSendOnChange) {
			pain.textViewDidChange(painView)
		}
	}

	func testFatigueAndPainSlidersMapPositiveAndNegativeScaleEndpointsAndMidpoints() {
		for (min, max) in [(2.0, 10.0), (-5.0, 5.0)] {
			for probe in otherRatingCells(min: min, max: max) {
				for fraction: Float in [0, 0.5, 1] {
					let expected = min + Double(fraction) * (max - min)
					probe.setRating(expected)
					XCTAssertEqual(probe.slider.value, fraction, accuracy: 0.000001, probe.name)
					probe.slider.value = fraction
					probe.sliderChanged()
					XCTAssertEqual(probe.rating(), expected, accuracy: 0.000001, probe.name)
				}
			}
		}
	}

	func testConstantFatigueAndPainScalesDisableSlidersAndKeepTheirOnlyRatingFinite() {
		for probe in otherRatingCells(min: 4, max: 4) {
			XCTAssertFalse(probe.slider.isEnabled, probe.name)
			XCTAssertEqual(probe.slider.value, 0, probe.name)
			probe.slider.value = 1
			probe.sliderChanged()
			XCTAssertEqual(probe.rating(), 4, probe.name)
			XCTAssertTrue(probe.rating().isFinite, probe.name)
			XCTAssertEqual(probe.slider.value, 0, probe.name)
			XCTAssertTrue(probe.slider.value.isFinite, probe.name)
		}
	}

	func testRatingColorsUseTheirEndpointsForPositiveAndNegativeScales() {
		for (name, color, minimum, maximum) in ratingColors() {
			for (min, max) in [(2.0, 10.0), (-5.0, 5.0)] {
				assertColor(color(min, min, max), matches: minimum, name)
				assertColor(color(max, min, max), matches: maximum, name)
			}
		}
	}

	func testRatingColorsClampValuesOutsideTheirScale() {
		for (name, color, minimum, maximum) in ratingColors() {
			assertColor(color(-500, 2, 10), matches: minimum, name)
			assertColor(color(500, 2, 10), matches: maximum, name)
		}
	}

	func testConstantReversedAndNonfiniteRatingScalesProduceFiniteMinimumColors() {
		for (name, color, minimum, _) in ratingColors() {
			for (rating, min, max) in [(4.0, 4.0, 4.0), (3.0, 5.0, 1.0),
				(Double.nan, 0.0, 10.0), (Double.infinity, 0.0, 10.0),
				(2.0, -Double.infinity, Double.infinity)] {
				assertColor(color(rating, min, max), matches: minimum, name)
			}
		}
	}

	func testActivityDescriptionPublishesCurrentTextBeforeEveryDelegateReturns() {
		let cell = ActivityDefinitionDescriptionTableViewCell()
		let view = UITextView()
		cell.descriptionView = view
		cell.activityDescription = "original"
		let name = Notification.Name("ActivityDescriptionSnapshot-" + UUID().uuidString)
		cell.notificationToSendOnChange = name
		var snapshots = [String]()
		let observer = NotificationCenter.default.addObserver(forName: name, object: cell, queue: nil) { notification in
			if let value = notification.userInfo?[UserInfoKey.text] as? String { snapshots.append(value) }
		}
		defer { NotificationCenter.default.removeObserver(observer) }
		cell.textViewDidBeginEditing(view)
		XCTAssertEqual(snapshots, ["original"])
		let multiline = "Updated activity 🌱\nSecond line"
		view.text = multiline
		cell.textViewDidChange(view)
		XCTAssertEqual(snapshots, ["original", multiline])
		view.text = ""
		cell.textViewDidEndEditing(view)
		XCTAssertEqual(snapshots, ["original", multiline, ""])
	}

	private func ratingCell(min: Double, max: Double) -> ContinuousMoodRatingTableViewCell {
		let cell = ContinuousMoodRatingTableViewCell()
		cell.ratingSlider = UISlider()
		cell.ratingTextField = UITextField()
		cell.ratingRangeLabel = UILabel()
		cell.minRating = min
		cell.maxRating = max
		cell.rating = min
		return cell
	}

	private func assertNoteSnapshots(cell: UITableViewCell, view: UITextView, name: Notification.Name,
		didChange: () -> Void, file: StaticString = #file, line: UInt = #line) {
		var snapshots = [String]()
		let observer = NotificationCenter.default.addObserver(forName: name, object: cell, queue: nil) { notification in
			if let value = notification.userInfo?[UserInfoKey.text] as? String { snapshots.append(value) }
		}
		defer { NotificationCenter.default.removeObserver(observer) }
		let multiline = "Updated note 🙂\nSecond line"
		view.text = multiline
		didChange()
		XCTAssertEqual(snapshots, [multiline], file: file, line: line)
		view.text = ""
		didChange()
		XCTAssertEqual(snapshots, [multiline, ""], file: file, line: line)
	}

	private struct RatingCellProbe {
		let name: String
		let slider: UISlider
		let setRating: (Double) -> Void
		let rating: () -> Double
		let sliderChanged: () -> Void
	}

	private func otherRatingCells(min: Double, max: Double) -> [RatingCellProbe] {
		let fatigue = ContinuousFatigueRatingTableViewCell()
		fatigue.ratingSlider = UISlider()
		fatigue.ratingTextField = UITextField()
		fatigue.ratingRangeLabel = UILabel()
		fatigue.minRating = min
		fatigue.maxRating = max
		fatigue.rating = min
		let pain = ContinuousPainRatingTableViewCell()
		pain.ratingSlider = UISlider()
		pain.ratingTextField = UITextField()
		pain.ratingRangeLabel = UILabel()
		pain.minRating = min
		pain.maxRating = max
		pain.rating = min
		return [
			RatingCellProbe(name: "Fatigue", slider: fatigue.ratingSlider,
				setRating: { fatigue.rating = $0 }, rating: { fatigue.rating },
				sliderChanged: { fatigue.sliderValueChanged(fatigue) }),
			RatingCellProbe(name: "Pain", slider: pain.ratingSlider,
				setRating: { pain.rating = $0 }, rating: { pain.rating },
				sliderChanged: { pain.sliderValueChanged(pain) }),
		]
	}

	private func ratingColors() -> [(String, (Double, Double, Double) -> UIColor, UIColor, UIColor)] {
		let mood = MoodUiUtilImpl()
		let fatigue = FatigueUiUtilImpl()
		let pain = PainUiUtilImpl()
		return [
			("Mood", { mood.colorForMood(rating: $0, minRating: $1, maxRating: $2) },
				MoodUiUtilImpl.minRatingColor, MoodUiUtilImpl.maxRatingColor),
			("Fatigue", { fatigue.colorForFatigue(rating: $0, minRating: $1, maxRating: $2) },
				FatigueUiUtilImpl.minRatingColor, FatigueUiUtilImpl.maxRatingColor),
			("Pain", { pain.colorForPain(rating: $0, minRating: $1, maxRating: $2) },
				PainUiUtilImpl.minRatingColor, PainUiUtilImpl.maxRatingColor),
		]
	}

	private func assertColor(_ color: UIColor, matches expected: UIColor, _ name: String,
		file: StaticString = #file, line: UInt = #line) {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
		var expectedRed: CGFloat = 0, expectedGreen: CGFloat = 0, expectedBlue: CGFloat = 0, expectedAlpha: CGFloat = 0
		XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha), name, file: file, line: line)
		XCTAssertTrue(expected.getRed(&expectedRed, green: &expectedGreen, blue: &expectedBlue, alpha: &expectedAlpha),
			name, file: file, line: line)
		for (actual, wanted) in [(red, expectedRed), (green, expectedGreen), (blue, expectedBlue), (alpha, expectedAlpha)] {
			XCTAssertTrue(actual.isFinite, name, file: file, line: line)
			XCTAssertEqual(actual, wanted, accuracy: 0.000001, name, file: file, line: line)
		}
	}

	private final class FocusProbeTextView: UITextView {
		var focusRequests = 0
		override func becomeFirstResponder() -> Bool {
			focusRequests += 1
			return false
		}
	}
}

final class TextAttributeEditorFocusTests: UnitTest {
	func testTextEditorRequestsFocusAfterAppearanceInsteadOfDuringLoading() {
		let controller = TextAttributeValueViewController()
		let text = FocusProbeTextView()
		controller.textView = text
		controller.validationLabel = UILabel()
		controller.textAttribute = Activity.nameAttribute
		controller.currentValue = "Existing text"
		controller.view = UIView()
		controller.viewDidLoad()
		XCTAssertEqual(text.focusRequests, 0)
		XCTAssertEqual(text.text, "Existing text")
		XCTAssertTrue(text.delegate === controller)
		XCTAssertEqual(text.accessibilityIdentifier, "attribute value text")
		controller.viewDidAppear(false)
		XCTAssertEqual(text.focusRequests, 1)
	}

	private final class FocusProbeTextView: UITextView {
		var focusRequests = 0
		override func becomeFirstResponder() -> Bool {
			focusRequests += 1
			return true
		}
	}
}

final class GrouperEditorContainmentTests: UnitTest {
	func testGrouperEditorOwnsItsChooserAndLaysOutTheSaveControl() {
		Matcher.default.register(AttributedChooserViewController.Type.self) { $0 == $1 }
		Matcher.default.register(AttributeViewController.Type.self) { $0 == $1 }
		let storyboard = UIStoryboard(name: "AttributeList", bundle: nil)
		let chooser = storyboard.instantiateViewController(withIdentifier: "attributedChooserViewController") as! AttributedChooserViewController
		let first = storyboard.instantiateViewController(withIdentifier: "attributeView") as! AttributeViewController
		let second = storyboard.instantiateViewController(withIdentifier: "attributeView") as! AttributeViewController
		Given(mockUiUtil, .controller(named: .value("attributedChooserViewController"),
			from: .value("AttributeList"), as: .value(AttributedChooserViewController.self), willReturn: chooser))
		Given(mockUiUtil, .controller(named: .value("attributeView"),
			from: .value("AttributeList"), as: .value(AttributeViewController.self), willReturn: first, second))
		let editor = EditGrouperViewControllerImpl()
		let grouper = SameTimeUnitSampleGrouper(attributes: [CommonSampleAttributes.startDate], .weekOfYear)
		editor.currentGrouper = grouper
		editor.availableGroupers = [grouper]
		editor.notificationToSendWhenAccepted = .backgroundExportFinished
		editor.loadViewIfNeeded()
		editor.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
		editor.view.layoutIfNeeded()
		XCTAssertEqual(editor.children.count, 1)
		XCTAssertTrue(chooser.parent === editor)
		XCTAssertTrue(chooser.view.superview === editor.view)
		XCTAssertEqual(chooser.view.frame, editor.view.bounds)
		let save = chooser.scrollContentView.subviews.first { $0.accessibilityIdentifier == "save grouper button" }
		XCTAssertNotNil(save)
		if let save = save {
			XCTAssertGreaterThan(save.frame.height, 0)
			XCTAssertTrue(chooser.view.bounds.contains(save.convert(save.bounds, to: chooser.view)))
		}
		NotificationCenter.default.removeObserver(editor)
		NotificationCenter.default.removeObserver(chooser)
	}
}

class Test: XCTestCase {

	public final var injectionProvider: InjectionProviderMock!

	override func record(_ issue: XCTIssue) {
		// Preserve the original failure and include the caller of a missing mock,
		// rather than only the generated mock's declaration in the result bundle.
		print("XCTest issue in \(name): \(issue.compactDescription)\n" + Thread.callStackSymbols.joined(separator: "\n"))
		super.record(issue)
	}

	override func setUp() {
		super.setUp()
		registerMatchers()
		registerTypesWithDependencyInjection()
	}

	final func registerTypesWithDependencyInjection() {
		injectionProvider = InjectionProviderMock()
		var types: [Any.Type] = []
		types.append(contentsOf: AttributeRestrictionsInjectionProvider().types)
		types.append(contentsOf: BooleanAlgebraInjectionProvider().types)
		types.append(contentsOf: CommonInjectionProvider().types)
		types.append(contentsOf: DataExportInjectionProvider().types)
		types.append(contentsOf: DataImportInjectionProvider().types)
		types.append(contentsOf: IntrospectiveInjectionProvider().types)
		types.append(contentsOf: PersistenceInjectionProvider(ObjectModelContainer.objectModel).types)
		types.append(contentsOf: QueriesInjectionProvider().types)
		types.append(contentsOf: SamplesInjectionProvider().types)
		types.append(contentsOf: SampleGroupersInjectionProvider().types)
		types.append(contentsOf: SampleGroupInformationInjectionProvider().types)
		types.append(contentsOf: SettingsInjectionProvider().types)

		Given(injectionProvider, .types(getter: types))
		// Replacing a provider can release managed objects that resolve Database
		// during cleanup. Publish the new provider only after its mocks are ready.
		configureInjectionProvider()
		DependencyInjector.register([injectionProvider])
	}

	func configureInjectionProvider() {}

	final func registerMatchers() {
		Matcher.default.register(ActivityDAO.Protocol.self) { _,_ in true }
		Matcher.default.register(ActivityExporter.Protocol.self) { _,_ in true }
		Matcher.default.register(Any.self) { self.anyMatcher($0, $1) }
		Matcher.default.register(AnySample.self) { $0.equalTo($1) }
		Matcher.default.register(Array<Attribute>.self) { $0.elementsEqual($1, by: { $0.equalTo($1) }) }
		Matcher.default.register(Array<SampleGroupInformation>.self) { $0.elementsEqual($1, by: { $0.equalTo($1) }) }
		Matcher.default.register(AsyncUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Attribute.self) { $0.equalTo($1) }
		Matcher.default.register(AttributeRestriction.self) { $0.equalTo($1) }
		Matcher.default.register(AttributeRestriction.Type.self) { $0 == $1 }
		Matcher.default.register(AttributeRestrictionFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(BooleanExpressionParser.Protocol.self) { _,_ in true }
		Matcher.default.register(BooleanExpressionPart.self) { self.booleanExpressionPartsMatch($0, $1) }
		Matcher.default.register(CalendarUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(CoachMarkFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(CoreDataSampleUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Database.Protocol.self) { _,_ in true }
		Matcher.default.register(DayOfWeek.self)
		Matcher.default.register(Exportable.Type.self) { $0 == $1 }
		Matcher.default.register(ExporterUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(SampleGroupInformation.self) { $0.equalTo($1) }
		Matcher.default.register(SampleGroupInformationFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(GroupDefinition.self) {
			if let first = $0 as? GroupDefinitionMock, let second = $1 as? GroupDefinitionMock {
				return first === second
			}
			return $0.equalTo($1)
		}
		Matcher.default.register(HealthKitUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(HeartRate.Type.self) { _,_ in true }
		Matcher.default.register(ImporterFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(IOUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(MedicationDAO.Protocol.self) { _,_ in true }
		Matcher.default.register(MedicationExporter.Protocol.self) { _,_ in true }
		Matcher.default.register(MoodDAO.Protocol.self) { _,_ in true }
		Matcher.default.register(MoodExporter.Protocol.self) { _,_ in true }
		Matcher.default.register(MoodUiUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(MoodUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(NotificationUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(NumericSampleUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Optional<Any>.self) { self.anyMatcher($0, $1) }
		Matcher.default.register(Optional<Array<Attribute>>.self) {
			self.optionalEqualTo($0, $1, { $0.elementsEqual($1, by: { $0.equalTo($1) }) })
		}
		Matcher.default.register(Optional<Array<SampleGroupInformation>>.self) {
			self.optionalEqualTo($0, $1, { $0.elementsEqual($1, by: { $0.equalTo($1) }) })
		}
		Matcher.default.register(Optional<Attribute>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<SampleGroupInformation>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<Query>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<SampleGrouper>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(QueryFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(Sample.self) { $0.equalTo($1) }
		Matcher.default.register(Sample.Type.self) { $0.name == $1.name }
		Matcher.default.register(SampleFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(SampleGrouperFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(SampleUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(SearchUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Settings.Protocol.self) { _,_ in true }
		Matcher.default.register(StringUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(SubQueryMatcherFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(TextNormalizationUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(UITableViewCell.Type.self)
		Matcher.default.register(UiUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(UIViewController.Type.self)
		Matcher.default.register(UserDefaultsUtil.Protocol.self) { _,_ in true }
	}

	// MARK: - Helper Functions

	private final func anyMatcher(_ one: Any?, _ two: Any?) -> Bool {
		if type(of: one) != type(of: two) && (isOptional(one) == isOptional(two)) {
			return false
		}
		if (one == nil && two == nil) { return true }
		if let attribute1 = one as? Attribute, let attribute2 = two as? Attribute {
			return attribute1.equalTo(attribute2)
		}
		if let _ = one as? ATrackerActivityImporterMock, let _ = two as? ATrackerActivityImporterMock {
			// no way to mock equalTo function when other value is also a mock because the
			// Given statement would recursively call this code:
			// Given(importer, .equalTo(.value(other), willReturn: true))
			//                          ^^^^^^^^^^^^^
			// when this ran, it would go to check if the passed other value matches the
			// one from the Given statement, which would call this code, ending in infinite
			// recursion. Also, pointer comparison is not good enough because of copy
			// constructor.
			return true
		}
		if let _ = one as? ActivityExporterMock, let _ = two as? ActivityExporterMock {
			// no way to mock equalTo function when other value is also a mock because the
			// Given statement would recursively call this code:
			// Given(exporter, .equalTo(.value(other), willReturn: true))
			//                          ^^^^^^^^^^^^^
			// when this ran, it would go to check if the passed other value matches the
			// one from the Given statement, which would call this code, ending in infinite
			// recursion. Also, pointer comparison is not good enough because of copy
			// constructor.
			return true
		}
		if let importer1 = one as? Importer, let importer2 = two as? Importer {
			return importer1.equalTo(importer2)
		}
		if let exporter1 = one as? Exporter, let exporter2 = two as? Exporter {
			return exporter1.equalTo(exporter2)
		}
		if let view1 = one as? UIView, let view2 = two as? UIView {
			return view1 == view2
		}
		if let viewController1 = one as? UIViewController, let viewController2 = two as? UIViewController {
			return viewController1 == viewController2
		}
		if let cell1 = one as? UITableViewCell, let cell2 = two as? UITableViewCell {
			return cell1 == cell2
		}
		if let str1 = one as? String, let str2 = two as? String {
			return str1 == str2
		}
		fatalError("Missing equality test for Any Matcher")
	}

	private final func booleanExpressionPartsMatch(_ first: BooleanExpressionPart, _ second: BooleanExpressionPart) -> Bool {
		if first.type != second.type {
			return false
		}
		if first.expression == nil && second.expression == nil {
			return true
		}
		guard let expression1 = first.expression, let expression2 = second.expression else {
			return false
		}
		return expression1.equalTo(expression2)
	}

	private final func optionalEqualTo<Type>(_ first: Type?, _ second: Type?, _ areEqual: (Type, Type) -> Bool) -> Bool {
		guard let first = first else { return second == nil }
		guard let second = second else { return false }
		return areEqual(first, second)
	}
}
