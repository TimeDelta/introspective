//
//  ResultsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import NotificationBannerSwift
import Presentr
import SwiftDate
import UIKit

import AttributeRestrictions
import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Queries
import SampleGroupInformation
import Samples
import UIExtensions

public protocol ResultsViewController: UITableViewController {
	var query: Query! { get set }
	var samples: [Sample]! { get set }
	var backButtonTitle: String? { get set }
}

final class ResultsViewControllerImpl: UITableViewController, ResultsViewController {
	// MARK: - Static Variables

	private typealias Me = ResultsViewControllerImpl

	// MARK: Notification Names

	private static let sortSamples = Notification.Name("sortSamplesBy")
	static let editedSample = Notification.Name("editedSampleFromResultsScreen")
	static let choseSearchNearbyDuration = Notification.Name("choseSearchNearbyDuration")

	// MARK: Presenters

	private static let sortPresenter: Presentr = DependencyInjector.get(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 245), center: .center)
	private static let setDosePresenter: Presentr = DependencyInjector.get(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 250), center: .center)

	// MARK: - IBOutlets

	@IBOutlet final var actionsButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var backButtonTitle: String?

	public final var query: Query!
	public final var samples: [Sample]! {
		didSet {
			guard !failed else { return }
			guard samples != nil else { return }

			if !initialSampleSortDone {
				guard !samples.isEmpty else {
					viewIsReady()
					return
				}
				initialSampleSortDone = true
				DependencyInjector.get(AsyncUtil.self).run(qos: .userInteractive) {
					let dateAttributes = self.samples[0].attributes.filter { $0 is DateAttribute }
					guard !dateAttributes.isEmpty else {
						self.viewIsReady()
						return
					}
					self.sortAttribute = dateAttributes[0]
					self.sortOrder = .orderedDescending
					self.sortTask = DispatchWorkItem(block: {})
					self.sort(by: Date.self)
					self.sortTask = nil
					self.filterSamples()
					self.viewIsReady()
				}
			} else {
				DependencyInjector.get(AsyncUtil.self).run(qos: .userInteractive) {
					self.filterSamples()
				}
			}
		}
	}

	// public for testing purposes
	public final var information = [SampleGroupInformation]()
	private final var informationValues = [String?]()

	// MARK: Editing

	private final var lastSelectedRowIndex: Int!
	private final var lastSelectedUnfilteredRowIndex: Int!
	private final var informationEditIndex: Int!

	// MARK: Sorting

	private final var sortAttribute: Attribute?
	private final var sortOrder: ComparisonResult?
	private final var sortTask: DispatchWorkItem?
	private final var sortActionSheet: UIAlertController?
	private final var sortController: SortResultsViewController?
	private final var initialSampleSortDone = false

	// MARK: Searching

	private final let searchController = UISearchController(searchResultsController: nil)

	private final var filteredSamples: [Sample]! {
		didSet {
			recomputeInformation()
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}

	// MARK: Search Nearby

	private final var selectedSearchNearbySampleDates = [DateType: Date]()
	private final var selectedSearchNearbySampleType: Sample.Type!

	// MARK: Other

	private final var finishedLoading = false {
		didSet { searchController.searchBar.isUserInteractionEnabled = finishedLoading }
	}

	private final var actionsController: UIAlertController?

	private final var failed = false

	private final let log = Log()

	// MARK: - UIViewController Overloads

	public final override func viewDidLoad() {
		actionsButton.target = self
		actionsButton.action = #selector(presentActions)
		actionsButton.accessibilityLabel = "actions button"

		if let _ = samples as? [SearchableSample] {
			searchController.searchResultsUpdater = self
			searchController.obscuresBackgroundDuringPresentation = false
			searchController.searchBar.placeholder = "Search \(type(of: samples[0]).name) entries"
			searchController.hidesNavigationBarDuringPresentation = false
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = false
			definesPresentationContext = true
		} else {
			searchController.searchBar.isHidden = true
		}

		observe(selector: #selector(saveEditedInformation), name: .editedInformation, object: self)
		observe(selector: #selector(sortSamplesBy), name: Me.sortSamples)
		observe(selector: #selector(editedSample), name: Me.editedSample)
		observe(selector: #selector(searchNearby), name: Me.choseSearchNearbyDuration)

		navigationItem.setRightBarButton(actionsButton, animated: false)

		DependencyInjector.get(UiUtil.self)
			.setBackButton(for: self, title: backButtonTitle ?? "Query", action: #selector(done))

		extendedLayoutIncludesOpaqueBars = true

		tableView.flashScrollIndicators()
		finishedLoading = true

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44

		filterSamples()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	public final override func showError(
		title: String,
		message: String? = "Sorry for the inconvenience.",
		error: Error? = nil,
		tryAgain: (() -> Void)? = nil,
		onDismiss originalOnDismiss: ((UIAlertAction) -> Void)? = nil,
		onDonePresenting: (() -> Void)? = nil
	) {
		var onDismiss: ((UIAlertAction) -> Void)? = originalOnDismiss
		if filteredSamples == nil {
			failed = true
			onDismiss = { action in
				if let originalOnDismiss = originalOnDismiss {
					originalOnDismiss(action)
				}
				self.navigationController?.popViewController(animated: false)
			}
		}
		super.showError(
			title: title,
			message: message,
			error: error,
			tryAgain: tryAgain,
			onDismiss: onDismiss,
			onDonePresenting: onDonePresenting
		)
	}

	// MARK: - Table View Data Source

	final override func numberOfSections(in _: UITableView) -> Int {
		2
	}

	final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Information"
		} else if section == 1 {
			if filteredSamples != nil && !filteredSamples.isEmpty {
				return filteredSamples[0].attributedName.capitalized
			}
			return "Entries"
		} else {
			log.error("Unexpected section index while getting section title")
			return nil
		}
	}

	final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if failed {
			return 0
		}

		if waiting() {
			return 1
		}

		if section == 0 {
			return information.count
		}

		if section == 1 {
			return filteredSamples.count
		}

		log.error("Unexpected section index (%@) while determining number of rows in section", String(section))
		return 0
	}

	// MARK: - Table View Delegate

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		let section = indexPath.section

		if waiting() || sortTask != nil {
			return tableView.dequeueReusableCell(withIdentifier: "waitingCell", for: indexPath)
		}

		if section == 0 {
			guard let value = informationValues[row] else {
				return tableView.dequeueReusableCell(withIdentifier: "waitingCell", for: indexPath)
			}
			let cell = (tableView.dequeueReusableCell(
				withIdentifier: "informationCell",
				for: indexPath
			) as! SampleGroupInformationTableViewCell)
			cell.sampleGroupInformation = information[row]
			cell.value = value
			return cell
		}

		if section == 1 {
			let sample = filteredSamples[row]
			switch sample {
			case is Activity:
				let cell = (tableView.dequeueReusableCell(withIdentifier: "activityCell") as! ActivityTableViewCell)
				cell.activity = (sample as! Activity)
				return cell
			case is BloodPressure:
				let cell = (
					tableView
						.dequeueReusableCell(
							withIdentifier: "bloodPressureCell",
							for: indexPath
						) as! BloodPressureTableViewCell
				)
				cell.sample = (sample as! BloodPressure)
				return cell
			case is HealthKitQuantitySample:
				let cell = (tableView.dequeueReusableCell(
					withIdentifier: "healthKitQuantitySampleCell",
					for: indexPath
				) as! HealthKitQuantitySampleTableViewCell)
				cell.sample = (sample as! HealthKitQuantitySample)
				return cell
			case is MedicationDose:
				let cell = tableView.dequeueReusableCell(
					withIdentifier: "medicationDoseCell",
					for: indexPath
				) as! MedicationDoseTableTableViewCell
				cell.medicationDose = (sample as! MedicationDose)
				return cell
			case is Mood:
				let cell = tableViewCell(withIdentifier: "moodSampleCell", for: indexPath) as! MoodTableViewCell
				cell.mood = (sample as! Mood)
				return cell
			case is SexualActivity:
				let cell = (
					tableView
						.dequeueReusableCell(
							withIdentifier: "sexualActivityCell",
							for: indexPath
						) as! SexualActivityTableViewCell
				)
				cell.sample = (sample as! SexualActivity)
				return cell
			case is Sleep:
				let cell = (
					tableView
						.dequeueReusableCell(withIdentifier: "sleepCell", for: indexPath) as! SleepTableViewCell
				)
				cell.sleep = (sample as! Sleep)
				return cell
			default:
				log.error("Forgot a type of Sample")
				return UITableViewCell()
			}
		}

		log.error("Unexpected section index (%@) while instantiating cell", String(section))
		return UITableViewCell()
	}

	final override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard finishedLoading && !waiting() else { return }
		if indexPath.section == 0 {
			showEditInformationView(indexPath)
		} else {
			let sample = filteredSamples[indexPath.row]
			guard let allSamplesIndex = samples.firstIndex(where: { s in s.equalTo(sample) }) else {
				log.error("Unable to find filtered sample in original samples")
				return
			}
			lastSelectedUnfilteredRowIndex = allSamplesIndex
			if filteredSamples[indexPath.row] is Activity {
				lastSelectedUnfilteredRowIndex = indexPath.row
				showEditActivityView(indexPath)
			} else if filteredSamples[indexPath.row] is Mood {
				lastSelectedUnfilteredRowIndex = indexPath.row
				showEditMoodView(indexPath)
			} else if filteredSamples[indexPath.row] is MedicationDose {
				lastSelectedUnfilteredRowIndex = indexPath.row
				showEditDoseView(indexPath)
			}
		}
	}

	// MARK: - TableView Editing

	final override func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		indexPath.section == 0 || samplesAreDeletable()
	}

	final override func tableView(_: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		indexPath.section == 0
	}

	final override func tableView(_: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		guard fromIndexPath.section == 0 && to.section == 0 else { return }
		information.swapAt(fromIndexPath.row, to.row)
		informationValues.swapAt(fromIndexPath.row, to.row)
	}

	// MARK: - TableView Swipe Actions

	public final override func tableView(
		_ tableView: UITableView,
		leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		nil
	}

	public final override func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		guard indexPath.section > 0 else {
			let actions = [
				getDeleteInformationAction(at: indexPath),
			]
			return UISwipeActionsConfiguration(actions: actions)
		}
		var actions = [UIContextualAction]()
		if let searchNearbyAction = getSearchNearbyAction(at: indexPath) {
			actions.append(searchNearbyAction)
		}
		if let managedSample = filteredSamples[indexPath.row] as? CoreDataSample {
			actions.append(getDeleteCoreDataSampleAction(for: managedSample, at: indexPath))
		}
		return UISwipeActionsConfiguration(actions: actions)
	}

	private final func getDeleteInformationAction(at indexPath: IndexPath) -> UIContextualAction {
		DependencyInjector.get(UiUtil.self).contextualAction(
			style: .destructive,
			title: "🗑️"
		) { action, view, completion in
			self.information.remove(at: indexPath.row)
			self.informationValues.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .fade)
			completion(true)
		}
	}

	private final func getSearchNearbyAction(at indexPath: IndexPath) -> UIContextualAction? {
		selectedSearchNearbySampleDates = samples[indexPath.row].dates()
		guard selectedSearchNearbySampleDates.count > 0 else { return nil }

		let action = DependencyInjector.get(UiUtil.self).contextualAction(
			style: .normal,
			title: "🔍 Nearby"
		) { action, view, completion in
			let actionSheet = DependencyInjector.get(UiUtil.self).alert(
				title: "Which data type?",
				message: "Choose a type of data for which to search.",
				preferredStyle: .actionSheet
			)
			for sampleType in DependencyInjector.get(SampleFactory.self).allTypes() {
				let dateAttributes = sampleType.attributes.filter { $0 is DateAttribute }
				guard dateAttributes.count > 0 else { continue }
				actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
					title: sampleType.name,
					style: .default
				) { _ in
					let controller = self.viewController(
						named: "durationChooser",
						fromStoryboard: "Util"
					) as! SelectDurationViewController
					controller.initialDuration = TimeDuration(30.minutes)
					controller.notificationToSendOnAccept = Me.choseSearchNearbyDuration
					self.selectedSearchNearbySampleType = sampleType
					self.present(controller, using: DependencyInjector.get(UiUtil.self).defaultPresenter)
				})
			}
			actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
				title: "Cancel",
				style: .cancel,
				handler: nil
			))
			self.presentView(actionSheet, completion: { completion(true) })
		}
		action.backgroundColor = .systemBlue
		return action
	}

	private final func getDeleteCoreDataSampleAction(
		for managedSample: CoreDataSample,
		at indexPath: IndexPath
	) -> UIContextualAction {
		DependencyInjector.get(UiUtil.self).contextualAction(
			style: .destructive,
			title: "🗑️"
		) { action, view, completion in
			let alert = UIAlertController(
				title: "Are you sure you want to delete this?",
				message: nil,
				preferredStyle: .alert
			)
			let yesAction = DependencyInjector.get(UiUtil.self).alertAction(title: "Yes", style: .destructive) { _ in
				let goBackAfterDelete = self.filteredSamples.count == 1
				do {
					let transaction = DependencyInjector.get(Database.self).transaction()
					try retryOnFail({ try transaction.delete(managedSample) }, maxRetries: 2)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					if goBackAfterDelete {
						self.navigationController?.popViewController(animated: false)
					} else {
						let toRemove = self.filteredSamples.remove(at: indexPath.row)
						self.samples.removeAll(where: { $0 === toRemove })
						self.tableView.deleteRows(at: [indexPath], with: .fade)
						self.recomputeInformation()
						self.tableView.reloadData()
					}
				} catch {
					self.log.error("Failed to delete sample: %@", errorInfo(error))
					self.showError(
						title: "Failed to delete " + self.filteredSamples[indexPath.row].attributedName
							.localizedLowercase,
						error: error
					)
				}
			}

			alert.addAction(yesAction)
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: { completion(true) })
		}
	}

	// MARK: - Received Notifications

	@objc private final func saveEditedInformation(notification: Notification) {
		if let selectedInformation: SampleGroupInformation? = value(for: .information, from: notification) {
			if let editIndex = informationEditIndex {
				// selectedInformation can no longer be nil even though it's type is Optional
				information[editIndex] = selectedInformation!
				informationValues[editIndex] = nil
				tableView.reloadRows(at: [IndexPath(row: editIndex, section: 0)], with: .automatic)
				DependencyInjector.get(AsyncUtil.self).run(qos: .userInteractive) {
					do {
						self.informationValues[editIndex] =
							try self.information[editIndex].compute(forSamples: self.filteredSamples)
						DispatchQueue.main.async {
							self.tableView.reloadRows(at: [IndexPath(row: editIndex, section: 0)], with: .automatic)
						}
					} catch {
						self.log.error(
							"Failed to compute %@ information: %@",
							selectedInformation!.name,
							errorInfo(error)
						)
						DispatchQueue.main.async {
							self.showError(
								title: "Failed to compute \(selectedInformation!.name) information",
								error: error
							)
						}
					}
				}
			} else {
				log.error("Extra Information edit index was nil")
				showError(title: "Failed to edit selected information")
			}
		}
	}

	@objc private final func editedSample(notification: Notification) {
		if let sample: Sample? = value(for: .sample, from: notification) {
			guard let editIndex = lastSelectedRowIndex else {
				log.error("edit index nil")
				return
			}
			samples[lastSelectedUnfilteredRowIndex] = sample!
			tableView.reloadRows(at: [IndexPath(row: editIndex, section: 1)], with: .automatic)
			for i in 0 ..< informationValues.count {
				informationValues[i] = nil
			}
			tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
			DependencyInjector.get(AsyncUtil.self).run(qos: .userInteractive) {
				self.recomputeInformation()
				DispatchQueue.main.async {
					self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
				}
			}
		}
	}

	@objc private final func sortSamplesBy(notification: Notification) {
		guard let attribute: Attribute? = value(for: .attribute, from: notification) else { return }
		guard let order: ComparisonResult? = value(for: .comparisonResult, from: notification) else { return }
		sortOrder = order
		sortAttribute = attribute

		sortActionSheet = UIAlertController(
			title: "Sorting by \(sortAttribute!.name)",
			message: nil,
			preferredStyle: .actionSheet
		)
		sortActionSheet?.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
			self.sortTask?.cancel()
			self.sortTask = nil
			self.tableView.reloadData()
		})
		sortController?.dismiss(animated: false, completion: {
			self.present(self.sortActionSheet!, animated: false, completion: nil)

			self.sortTask = DispatchWorkItem {
				switch self.sortAttribute {
				case is DoubleAttribute: self.sort(by: Double.self); break
				case is IntegerAttribute: self.sort(by: Int.self); break
				case is TextAttribute: self.sort(by: String.self); break
				case is DateAttribute: self.sort(by: Date.self); break
				case is DayOfWeekAttribute: self.sort(by: DayOfWeek.self); break
				case is TimeOfDayAttribute: self.sort(by: TimeOfDay.self); break
				case is DurationAttribute: self.sort(by: TimeDuration.self); break
				case is FrequencyAttribute: self.sort(by: Frequency.self); break
				case is DosageAttribute: self.sort(by: Dosage.self); break
				default:
					self.log.error("Unknown sort attribute type: %@", String(describing: type(of: self.sortAttribute)))
				}
				self.sortTask = nil
				DispatchQueue.main.async {
					self.sortActionSheet?.dismiss(animated: false, completion: nil)
					self.sortActionSheet = nil
					self.tableView.reloadData()
				}
			}
			DispatchQueue.global(qos: .userInteractive).async(execute: self.sortTask!)
		})
	}

	@objc private final func searchNearby(notification: Notification) {
		guard let duration: TimeDuration = value(for: .duration, from: notification) else {
			log.error("Missing duration for searchNearby notification")
			return
		}
		do {
			var query = try DependencyInjector.get(QueryFactory.self).queryFor(selectedSearchNearbySampleType)
			let start = selectedSearchNearbySampleDates[.start]
			let end = selectedSearchNearbySampleDates[.end]
			if let startDate = start, let endDate = end {
				try buildNearbyQuery(
					&query,
					sampleType: selectedSearchNearbySampleType,
					startDate: startDate,
					endDate: endDate,
					duration: duration
				)
			} else if let timestamp = start {
				try buildNearbyQuery(
					&query,
					sampleType: selectedSearchNearbySampleType,
					timestamp: timestamp,
					duration: duration
				)
			} else {
				log.error("Sample type has no dates: %@", selectedSearchNearbySampleType.name)
			}
			let controller = viewController(named: "results") as! ResultsViewController
			query.runQuery { (result: QueryResult?, error: Error?) in
				if let error = error {
					DispatchQueue.main.async {
						controller.showError(title: "Failed to run query", error: error)
					}
					return
				}
				controller.samples = result?.samples
			}
			controller.query = query
			controller.backButtonTitle = "\(samples[0].attributedName) Results"
			pushToNavigationController(controller)
		} catch {
			if let displayableError = error as? DisplayableError {
				showError(
					title: displayableError.displayableTitle,
					message: displayableError.displayableDescription
				)
			} else {
				showError(title: "Failed to generate query")
			}
		}
	}

	/// Build a query to search nearby a sample that has two dates.
	private final func buildNearbyQuery(
		_ query: inout Query,
		sampleType: Sample.Type,
		startDate: Date,
		endDate: Date,
		duration: TimeDuration
	) throws {
		let minDate = startDate - duration
		let maxDate = endDate + duration
		guard let startAttribute = sampleType.dateAttributes[.start] else {
			log.error("Missing start attribute for %@", sampleType.name)
			throw GenericDisplayableError(
				title: "Unable to search nearby",
				description: "You found a bug: please report RVCbnq1"
			)
		}
		if let endAttribute = sampleType.dateAttributes[.end] {
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: endAttribute, date: maxDate)
			)
		} else { // only one attribute on target sample type
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: maxDate)
			)
		}
	}

	/// Build a query to search nearby a sample that has only one date.
	private final func buildNearbyQuery(
		_ query: inout Query,
		sampleType: Sample.Type,
		timestamp: Date,
		duration: TimeDuration
	) throws {
		let minDate = timestamp - duration
		let maxDate = timestamp + duration
		guard let startAttribute = sampleType.dateAttributes[.start] else {
			log.error("Missing start attribute for %@", sampleType.name)
			throw GenericDisplayableError(
				title: "Unable to search nearby",
				description: "You found a bug: please report RVCbnq3"
			)
		}
		if let endAttribute = sampleType.dateAttributes[.end] {
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: endAttribute, date: maxDate)
			)
		} else { // only one attribute on target sample type
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: maxDate)
			)
		}
	}

	// MARK: - Button Actions

	@objc private final func presentActions() {
		actionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		actionsController?.addAction(DependencyInjector.get(UiUtil.self).alertAction(
			title: "Graph",
			style: .default,
			handler: { _ in self.graph() }
		))
		if samplesAreSortable() {
			actionsController?.addAction(DependencyInjector.get(UiUtil.self).alertAction(
				title: "Sort",
				style: .default,
				handler: { _ in self.setSampleSort() }
			))
		}
		actionsController?
			.addAction(DependencyInjector.get(UiUtil.self).alertAction(title: "Add Information", style: .default) { _ in
				DependencyInjector.get(AsyncUtil.self).run(qos: .userInteractive) { self.addInformation() }
			})
		if let _ = query {
			actionsController?.addAction(DependencyInjector.get(UiUtil.self).alertAction(
				title: "Refresh",
				style: .default,
				handler: { _ in
					self.refreshQuery()
				}
			))
		}
		if samplesAreDeletable() {
			actionsController?.addAction(DependencyInjector.get(UiUtil.self).alertAction(
				title: "Delete these " + samples[0].attributedName.localizedLowercase + " entries",
				style: .default,
				handler: { _ in self.deleteAllSamples() }
			))
		}
		actionsController?
			.addAction(DependencyInjector.get(UiUtil.self).alertAction(title: "Cancel", style: .cancel, handler: nil))
		present(actionsController!, animated: false, completion: nil)
	}

	@objc private final func done() {
		query.stop()
		navigationController?.popViewController(animated: false)
	}

	@objc private final func graph() {
		let controller: QueryResultsGraphSetupViewController = viewController(
			named: "queryResultsGraphSetup",
			fromStoryboard: "GraphSetup"
		)
		controller.samples = samples
		pushToNavigationController(controller, animated: false)
	}

	@objc private final func setSampleSort() {
		sortController = viewController(named: "sortResults")
		sortController?.attributes = sortableAttributes()
		sortController?.sortAttribute = sortAttribute
		sortController?.sortOrder = sortOrder
		sortController?.notificationToSendOnAccept = Me.sortSamples
		customPresentViewController(Me.sortPresenter, viewController: sortController!, animated: false)
	}

	@objc private final func addInformation() {
		do {
			let attribute = type(of: samples[0]).defaultDependentAttribute
			let applicableTypes = DependencyInjector.get(SampleGroupInformationFactory.self)
				.getApplicableInformationTypes(forAttribute: attribute)
			let newInformation = DependencyInjector.get(SampleGroupInformationFactory.self)
				.initInformation(applicableTypes[0], attribute)
			information.append(newInformation)
			informationValues.append(nil)
			DispatchQueue.main.async {
				self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
			}
			informationValues[information.count - 1] = try information.last!.compute(forSamples: filteredSamples)
			DispatchQueue.main.async {
				self.tableView.reloadRows(
					at: [IndexPath(row: self.information.count - 1, section: 0)],
					with: .automatic
				)
			}
		} catch {
			log.error("Failed to compute information: %@", errorInfo(error))
			showError(title: "You found a bug.", error: error)
		}
	}

	@objc private final func deleteAllSamples() {
		let sampleType = samples[0].attributedName.localizedLowercase
		let alert = UIAlertController(
			title: "Are you sure you want to delete all of these \(sampleType) records?",
			message: "This will only delete the ones displayed here.",
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			DispatchQueue.global(qos: .userInitiated).async {
				do {
					let transaction = DependencyInjector.get(Database.self).transaction()
					try transaction.deleteAll(self.samples as! [NSManagedObject])
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					DispatchQueue.main.async {
						self.navigationController?.popViewController(animated: false)
					}
				} catch {
					self.log.error("Failed to delete all %@: %@", sampleType, errorInfo(error))
					DispatchQueue.main.async {
						self.showError(title: "Failed to delete all \(sampleType) records", error: error)
					}
				}
			}
		})
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		present(alert, animated: false, completion: nil)
	}

	private final func refreshQuery() {
		query?.runQuery { result, error in
			if let error = error {
				self.log.error("Refresh query failed: %@", errorInfo(error))
			}
			self.initialSampleSortDone = false
			self.samples = result?.samples
			self.tableView.reloadData()
		}
	}

	// MARK: - Display Edit Screen Functions

	private final func showEditInformationView(_ indexPath: IndexPath) {
		informationEditIndex = indexPath.row
		let selectedInformation = information[informationEditIndex]

		let controller = viewController(
			named: "editSampleGroupInformation",
			fromStoryboard: "Util"
		) as! SelectSampleGroupInformationViewController
		controller.notificationToSendWhenFinished = .editedInformation
		controller.attributes = samples[0].attributes
		controller.selectedAttribute = selectedInformation.attribute
		controller.selectedInformation = selectedInformation
		controller.notificationFilter = self
		if navigationController != nil {
			pushToNavigationController(controller)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	private final func showEditActivityView(_ indexPath: IndexPath) {
		lastSelectedRowIndex = indexPath.row

		let controller = viewController(
			named: "editActivity",
			fromStoryboard: "RecordData"
		) as! EditActivityTableViewController
		guard let activity = filteredSamples[indexPath.row] as? Activity else {
			log.error("Failed to cast result sample as Activity")
			return
		}
		controller.activity = activity
		controller.notificationToSendOnAccept = Me.editedSample
		controller.userInfoKey = .sample
		if navigationController != nil {
			pushToNavigationController(controller)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	private final func showEditMoodView(_ indexPath: IndexPath) {
		lastSelectedRowIndex = indexPath.row

		let controller = viewController(named: "editMood", fromStoryboard: "Util") as! EditMoodTableViewController
		guard let mood = filteredSamples[indexPath.row] as? Mood else {
			log.error("Failed to cast result sample as Mood")
			return
		}
		controller.mood = mood
		controller.notificationToSendOnAccept = Me.editedSample
		controller.userInfoKey = .sample
		if navigationController != nil {
			pushToNavigationController(controller)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	private final func showEditDoseView(_ indexPath: IndexPath) {
		lastSelectedRowIndex = indexPath.row

		let controller = viewController(
			named: "medicationDoseEditor",
			fromStoryboard: "RecordData"
		) as! MedicationDoseEditorViewController
		guard let dose = filteredSamples[indexPath.row] as? MedicationDose else {
			log.error("Failed to cast result sample as MedicationDose")
			return
		}
		controller.medicationDose = dose
		controller.medication = dose.medication
		controller.notificationToSendOnAccept = Me.editedSample
		tableView.deselectRow(at: indexPath, animated: false)
		customPresentViewController(Me.setDosePresenter, viewController: controller, animated: false)
	}

	// MARK: - Helper functions

	private final func viewIsReady() {
		DispatchQueue.main.async {
			self.enableActionsButton()
		}
		DependencyInjector.get(AsyncUtil.self).run(qos: .userInteractive) {
			self.recomputeInformation()
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}

	private final func waiting() -> Bool {
		samples == nil
	}

	// leave non-private for testing
	final func recomputeInformation() {
		informationValues = [String]()
		for index in 0 ..< information.count {
			do {
				informationValues.append(try information[index].compute(forSamples: filteredSamples))
			} catch {
				log.error("Failed to compute %@ information: %@", information[index].name, errorInfo(error))
				informationValues.append("") // avoid any index out of bounds errors
			}
		}
	}

	private final func samplesAreDeletable() -> Bool {
		(samples != nil && !samples.isEmpty && samples[0] is CoreDataSample)
	}

	private final func samplesAreSortable() -> Bool {
		!sortableAttributes().isEmpty
	}

	private final func disableActionsButton() {
		actionsButton.isEnabled = false
		actionsButton.tintColor = UIColor.darkGray
	}

	private final func enableActionsButton() {
		actionsButton.isEnabled = true
		actionsButton.tintColor = nil
	}

	private final func sortableAttributes() -> [Attribute] {
		samples[0].attributes.filter {
			self.isSortableAttribute($0)
		}
	}

	private final func isSortableAttribute(_ attribute: Attribute) -> Bool {
		attribute is ComparableAttribute
	}

	private final func sort<Type: Comparable>(by type: Type.Type) {
		do {
			samples = try samples.sorted {
				if self.sortTask == nil || self.sortTask!.isCancelled { return true }
				let value1 = try $0.value(of: self.sortAttribute!) as? Type
				let value2 = try $1.value(of: self.sortAttribute!) as? Type
				if value1 == nil && value2 == nil { return true }
				if value1 == nil { return true }
				if value2 == nil { return false }
				if self.sortOrder == .orderedAscending {
					return value1! <= value2!
				}
				return value1! >= value2!
			}
		} catch {
			log.error("Failed to sort by %@: %@", String(describing: type), errorInfo(error))
			tellUserSortFailed()
		}
	}

	private final func tellUserSortFailed() {
		showError(title: "Failed to sort")
	}
}

// MARK: - UISearchResultsUpdating

extension ResultsViewControllerImpl: UISearchResultsUpdating {
	/// This is used to provide a hook into setting the search text for testing. For some reason
	/// passing searchController into resetFetchedResultsControllers() directly from
	/// updateSearchResults() to use it instead results in localSearchController.searchBar being
	/// nil in that function even though it is not nil when passed in.
	public func setSearchText(_ text: String) {
		searchController.searchBar.text = text
	}

	public func updateSearchResults(for _: UISearchController) {
		filterSamples()
	}

	private final func filterSamples() {
		if let samples = samples as? [SearchableSample] {
			guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
				filteredSamples = samples
				return
			}
			filteredSamples = samples.filter { $0.matchesSearchString(searchText) }
		} else {
			filteredSamples = samples
		}
	}
}
