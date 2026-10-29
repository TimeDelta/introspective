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
	var query: Query? { get set }
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

	private static let sortPresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 245), center: .center)
	private static let setDosePresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 350), height: .custom(size: Float(MedicationDoseEditorViewControllerImpl.preferredHeight)), center: .center)

	// MARK: Logging

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var actionsButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var backButtonTitle: String?

	public final var query: Query?
	private var storedSamples: [Sample]?
	public final var samples: [Sample]! {
		get { storedSamples }
		set { resultsOnMain { [weak self] in self?.acceptSamples(newValue) } }
	}

	// public for testing purposes
	public final var information = [SampleGroupInformation]()
	private final var informationValues = [String?]()

	// MARK: Editing

	private var selectedEditingSample: Sample?
	private final var informationEditIndex: Int!

	// MARK: Sorting

	private final var sortAttribute: Attribute?
	private final var sortOrder: ComparisonResult?
	private var sortWork: ResultsWork?
	private var queryWork: ResultsWork?
	private var activeRefreshQuery: Query?
	private var isClosed = false
	private var publishedSort: (Attribute?, ComparisonResult?) = (nil, nil)
	private final var sortActionSheet: UIAlertController?
	private final var sortController: SortResultsViewController?
	private final var initialSampleSortDone = false

	// MARK: Searching

	private final let searchController = UISearchController(searchResultsController: nil)

	private final var filteredSamples: [Sample]! {
		didSet {
			recomputeInformation()
			if isViewLoaded { tableView.reloadData() }
		}
	}

	// MARK: Search Nearby

	private final var selectedSearchNearbySampleDates = [DateType: Date]()
	private final var selectedSearchNearbySampleType: Sample.Type!
	private weak var nearbyDurationChooser: UIViewController?

	// MARK: Other

	private final var finishedLoading = false {
		didSet { searchController.searchBar.isUserInteractionEnabled = finishedLoading }
	}

	private final var actionsController: UIAlertController?

	private final var failed = false

	// MARK: - UIViewController Overloads

	public final override func viewDidLoad() {
		super.viewDidLoad()

		setTableViewInsetsForTabBar()

		actionsButton.target = self
		actionsButton.action = #selector(presentActions)
		actionsButton.accessibilityLabel = "actions button"

		observe(selector: #selector(saveEditedInformation), name: .editedInformation, object: self)
		observe(selector: #selector(sortSamplesBy), name: Me.sortSamples)
		observe(selector: #selector(editedSample), name: Me.editedSample)

		navigationItem.setRightBarButton(actionsButton, animated: false)

		injected(UiUtil.self)
			.setBackButton(for: self, title: backButtonTitle ?? "Query", action: #selector(done))

		extendedLayoutIncludesOpaqueBars = true

		tableView.flashScrollIndicators()
		finishedLoading = !waiting() && sortWork == nil
		if finishedLoading { enableActionsButton() }
		else { disableActionsButton() }

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44
	}

	deinit {
		sortWork?.cancel()
		queryWork?.cancel()
		NotificationCenter.default.removeObserver(self)
	}

	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if isMovingFromParent || isBeingDismissed { closeResults() }
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
			onDismiss = { [weak self] action in
				if let originalOnDismiss = originalOnDismiss {
					originalOnDismiss(action)
				}
				self?.navigationController?.popViewController(animated: false)
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
			Me.log.error("Unexpected section index while getting section title")
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

		Me.log.error("Unexpected section index (%@) while determining number of rows in section", String(section))
		return 0
	}

	// MARK: - Table View Delegate

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		let section = indexPath.section

		if waiting() {
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
				let cell = (tableView.dequeueReusableCell(
					withIdentifier: "bloodPressureCell",
					for: indexPath
				) as! BloodPressureTableViewCell)
				cell.sample = (sample as! BloodPressure)
				return cell
			case is Fatigue:
				let cell = (tableView.dequeueReusableCell(
					withIdentifier: "fatigueCell",
					for: indexPath
				) as! FatigueTableViewCell)
				cell.fatigue = (sample as! Fatigue)
				return cell
			case is Steps: // must come before HealthKitQuantitySample
				let cell = (tableView.dequeueReusableCell(
					withIdentifier: "stepsCell",
					for: indexPath
				) as! StepsTableViewCell)
				cell.steps = (sample as! Steps)
				return cell
			case let context as MetricContextEntry:
				let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
				cell.textLabel?.text = context.category + " · " + context.metric.title + " · " + (context.note ?? "")
				cell.detailTextLabel?.text = injected(CalendarUtil.self).string(for: context.timestamp, dateStyle: .medium, timeStyle: .short)
				return cell
			case let event as LostItemEvent:
				let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
				cell.textLabel?.text = event.description + " · " + (event.note ?? "")
				cell.detailTextLabel?.text = injected(CalendarUtil.self).string(for: event.timestamp, dateStyle: .medium, timeStyle: .short)
				return cell
			case let workout as Workout:
				let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
				cell.textLabel?.text = workout.typeName + " · " + TimeDuration(workout.workout.duration).description
				cell.detailTextLabel?.text = injected(CalendarUtil.self).string(for: workout.workout.startDate, dateStyle: .medium, timeStyle: .short)
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
			case is Pain:
				let cell = tableViewCell(withIdentifier: "painCell", for: indexPath) as! PainTableViewCell
				cell.pain = (sample as! Pain)
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
				Me.log.error("Forgot a type of Sample")
				return UITableViewCell()
			}
		}

		Me.log.error("Unexpected section index (%@) while instantiating cell", String(section))
		return UITableViewCell()
	}

	final override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard finishedLoading && !waiting() else { return }
		if indexPath.section == 0 {
			showEditInformationView(indexPath)
		} else {
			let sample = filteredSamples[indexPath.row]
			selectedEditingSample = sample
			if filteredSamples[indexPath.row] is Activity {
				showEditActivityView(indexPath)
			} else if filteredSamples[indexPath.row] is Mood {
				showEditMoodView(indexPath)
			} else if filteredSamples[indexPath.row] is MedicationDose {
				showEditDoseView(indexPath)
			} else if filteredSamples[indexPath.row] is Fatigue {
				showEditFatigueView(indexPath)
			} else if filteredSamples[indexPath.row] is Pain {
				showEditPainView(indexPath)
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
		injected(UiUtil.self).contextualAction(
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
		let dates = filteredSamples[indexPath.row].dates()
		guard dates[.start] != nil else { return nil }

		let action = injected(UiUtil.self).contextualAction(
			style: .normal,
			title: "🔍 Nearby"
		) { [weak self] action, view, completion in
			guard let self = self, !self.isClosed else { completion(false); return }
			let actionSheet = injected(UiUtil.self).alert(
				title: "Which data type?",
				message: "Choose a type of data for which to search.",
				preferredStyle: .actionSheet
			)
			for sampleType in injected(SampleFactory.self).allTypes() {
				let dateAttributes = sampleType.attributes.filter { $0 is DateAttribute }
				guard dateAttributes.count > 0 else { continue }
				actionSheet.addAction(injected(UiUtil.self).alertAction(
					title: sampleType.name,
					style: .default
				) { [weak self] _ in
					guard let self = self, !self.isClosed else { return }
					let controller = self.viewController(
						named: "durationChooser",
						fromStoryboard: "Util"
					) as! SelectDurationViewController
					controller.initialDuration = TimeDuration(30.minutes)
					controller.notificationToSendOnAccept = Me.choseSearchNearbyDuration
					NotificationCenter.default.removeObserver(self, name: Me.choseSearchNearbyDuration, object: nil)
					self.selectedSearchNearbySampleDates = dates
					self.selectedSearchNearbySampleType = sampleType
					self.nearbyDurationChooser = controller
					self.observe(selector: #selector(self.searchNearby), name: Me.choseSearchNearbyDuration, object: controller)
					self.present(controller, using: SelectDurationViewControllerImpl.presenter)
				})
			}
			actionSheet.addAction(injected(UiUtil.self).alertAction(
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
		injected(UiUtil.self).contextualAction(
			style: .destructive,
			title: "🗑️"
		) { action, view, completion in
			let alert = UIAlertController(
				title: "Are you sure you want to delete this?",
				message: nil,
				preferredStyle: .alert
			)
			let yesAction = injected(UiUtil.self).alertAction(title: "Yes", style: .destructive) { _ in
				let goBackAfterDelete = self.filteredSamples.count == 1
				do {
					let transaction = injected(Database.self).transaction()
					try retryOnFail({ try transaction.delete(managedSample) }, maxRetries: 2)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					let updated = (self.storedSamples ?? []).filter { ($0 as AnyObject) !== (managedSample as AnyObject) }
					if goBackAfterDelete { self.done() }
					else { self.acceptSamples(updated) }
				} catch {
					Me.log.error("Failed to delete sample: %@", errorInfo(error))
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
		guard !isClosed, let selected: SampleGroupInformation? = value(for: .information, from: notification),
			let replacement = selected, let index = informationEditIndex, information.indices.contains(index) else { return }
		information[index] = replacement
		recomputeInformation()
		if isViewLoaded { tableView.reloadData() }
	}

	@objc private final func editedSample(notification: Notification) {
		guard !isClosed, let value: Sample? = value(for: .sample, from: notification), let replacement = value,
			let selected = selectedEditingSample, var current = storedSamples else { return }
		let index = current.firstIndex {
			if ($0 as AnyObject) === (selected as AnyObject) { return true }
			guard let candidate = $0 as? NSManagedObject, let record = selected as? NSManagedObject,
				!record.objectID.isTemporaryID else { return false }
			return candidate.objectID == record.objectID
		}
		guard let matchingIndex = index else { return } // The edited record may have left a refreshed result set.
		current[matchingIndex] = replacement
		selectedEditingSample = replacement
		acceptSamples(current)
	}

	@objc private final func sortSamplesBy(notification: Notification) {
		guard let attribute: Attribute? = value(for: .attribute, from: notification),
			let order: ComparisonResult? = value(for: .comparisonResult, from: notification),
			let chosenAttribute = attribute, let chosenOrder = order else { return }
		let start: () -> Void = { [weak self] in self?.sortResults(by: chosenAttribute, order: chosenOrder) }
		if let picker = sortController {
			sortController = nil
			picker.dismiss(animated: false) { start() }
		} else { start() }
	}

	@objc private final func searchNearby(notification: Notification) {
		guard !isClosed, let chooser = nearbyDurationChooser,
			(notification.object as? UIViewController) === chooser,
			let duration: TimeDuration = value(for: .duration, from: notification),
			let sampleType = selectedSearchNearbySampleType else { return }
		NotificationCenter.default.removeObserver(self, name: Me.choseSearchNearbyDuration, object: chooser)
		nearbyDurationChooser = nil
		do {
			let query = try injected(QueryFactory.self).queryFor(sampleType)
			try NearbyResultsQuery.configure(query, type: sampleType, dates: selectedSearchNearbySampleDates, duration: duration)
			let destination = viewController(named: "results") as! ResultsViewController
			destination.query = query
			destination.backButtonTitle = "\(samples?.first?.attributedName ?? "Entry") Results"
			query.runQuery { [weak destination] (result: QueryResult?, error: Error?) in
				resultsOnMain { [weak destination] in
					guard let destination = destination else { return }
					if let controller = destination as? ResultsViewControllerImpl, controller.isClosed { return }
					if let error = error, !(error is NoSamplesFoundQueryError) {
						destination.showError(title: "Failed to run query", error: error)
					} else { destination.samples = result?.samples ?? [] }
				}
			}
			pushToNavigationController(destination)
		} catch {
			if let displayable = error as? DisplayableError {
				showError(title: displayable.displayableTitle, message: displayable.displayableDescription)
			} else { showError(title: "Failed to generate query", error: error) }
		}
	}

	// MARK: - Button Actions

	@objc private final func presentActions() {
		actionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		actionsController?.addAction(injected(UiUtil.self).alertAction(
			title: "Graph",
			style: .default,
			handler: { [weak self] _ in self?.graph() }
		))
		if samplesAreSortable() {
			actionsController?.addAction(injected(UiUtil.self).alertAction(
				title: "Sort",
				style: .default,
				handler: { [weak self] _ in self?.setSampleSort() }
			))
		}
		actionsController?.addAction(injected(UiUtil.self).alertAction(
			title: "Add Information",
			style: .default,
			handler: { [weak self] _ in self?.addInformation() }
		))
		if let _ = query {
			actionsController?.addAction(injected(UiUtil.self).alertAction(
				title: "Refresh",
				style: .default,
				handler: { [weak self] _ in
					self?.refreshQuery()
				}
			))
		}
		if samplesAreDeletable() {
			actionsController?.addAction(injected(UiUtil.self).alertAction(
				title: "Delete these " + samples[0].attributedName.localizedLowercase + " entries",
				style: .default,
				handler: { [weak self] _ in self?.deleteAllSamples() }
			))
		}
		actionsController?
			.addAction(injected(UiUtil.self).alertAction(title: "Cancel", style: .cancel, handler: nil))
		present(actionsController!, animated: false, completion: nil)
	}

	@objc private final func done() {
		closeResults()
		navigationController?.popViewController(animated: false)
	}

	final func closeResults() {
		guard !isClosed else { return }
		query?.stop()
		activeRefreshQuery?.stop(); activeRefreshQuery = nil
		isClosed = true
		sortWork?.cancel(); sortWork = nil
		queryWork?.cancel(); queryWork = nil
		dismissSortProgress()
		storedSamples = nil
		filteredSamples = nil
		selectedEditingSample = nil
		nearbyDurationChooser = nil
		finishedLoading = false
		NotificationCenter.default.removeObserver(self)
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
			guard let first = storedSamples?.first else { return }
			let attribute = type(of: first).defaultDependentAttribute
			let applicableTypes = injected(SampleGroupInformationFactory.self)
				.getApplicableInformationTypes(forAttribute: attribute)
			guard let informationType = applicableTypes.first else { return }
			let newInformation = injected(SampleGroupInformationFactory.self)
				.initInformation(informationType, attribute)
			information.append(newInformation)
			informationValues.append(nil)
			informationValues[information.count - 1] = try information.last!.compute(forSamples: filteredSamples)
			if isViewLoaded { tableView.reloadData() }
		} catch {
			Me.log.error("Failed to compute information: %@", errorInfo(error))
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
					let transaction = injected(Database.self).transaction()
					try transaction.deleteAll(self.samples as! [NSManagedObject])
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					DispatchQueue.main.async {
						self.navigationController?.popViewController(animated: false)
					}
				} catch {
					Me.log.error("Failed to delete all %@: %@", sampleType, errorInfo(error))
					DispatchQueue.main.async {
						self.showError(title: "Failed to delete all \(sampleType) records", error: error)
					}
				}
			}
		})
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		present(alert, animated: false, completion: nil)
	}

	final func refreshQuery() {
		guard !isClosed, let original = query else { return }
		queryWork?.cancel(); queryWork = nil
		activeRefreshQuery?.stop(); activeRefreshQuery = nil
		original.stop()
		let fresh: Query
		do { fresh = try ResultsQuerySnapshot.copy(original, using: injected(QueryFactory.self)) }
		catch { showError(title: "Unable to refresh query", error: error); return }
		let work = ResultsWork()
		queryWork = work
		activeRefreshQuery = fresh
		fresh.runQuery { [weak self, weak original] result, error in
			resultsOnMain { [weak self, weak original] in
				guard let self = self, let original = original, !self.isClosed, self.query === original,
					self.queryWork === work, !work.isCancelled else { return }
				self.queryWork = nil
				self.activeRefreshQuery = nil
				if let error = error, !(error is NoSamplesFoundQueryError) {
					self.showError(title: "Refresh query failed", error: error)
					return
				}
				self.acceptSamples(result?.samples ?? [])
			}
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
		let controller = viewController(
			named: "editActivity",
			fromStoryboard: "RecordData"
		) as! EditActivityTableViewController
		guard let activity = filteredSamples[indexPath.row] as? Activity else {
			Me.log.error("Failed to cast result sample as Activity")
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
		let controller = viewController(named: "editMood", fromStoryboard: "Util") as! EditMoodTableViewController
		guard let mood = filteredSamples[indexPath.row] as? Mood else {
			Me.log.error("Failed to cast result sample as Mood")
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
		let controller = viewController(
			named: "medicationDoseEditor",
			fromStoryboard: "RecordData"
		) as! MedicationDoseEditorViewController
		guard let dose = filteredSamples[indexPath.row] as? MedicationDose else {
			Me.log.error("Failed to cast result sample as MedicationDose")
			return
		}
		controller.medicationDose = dose
		controller.medication = dose.medication
		controller.notificationToSendOnAccept = Me.editedSample
		tableView.deselectRow(at: indexPath, animated: false)
		customPresentViewController(Me.setDosePresenter, viewController: controller, animated: false)
	}

	private final func showEditFatigueView(_ indexPath: IndexPath) {
		let controller = viewController(
			named: "editFatigue",
			fromStoryboard: "Util"
		) as! EditFatigueTableViewController
		guard let fatigue = filteredSamples[indexPath.row] as? Fatigue else {
			Me.log.error("Failed to cast result sample as Fatigue")
			return
		}
		controller.fatigue = fatigue
		controller.notificationToSendOnAccept = Me.editedSample
		tableView.deselectRow(at: indexPath, animated: false)
		if navigationController != nil {
			pushToNavigationController(controller)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	private final func showEditPainView(_ indexPath: IndexPath) {
		let controller = viewController(
			named: "editPain",
			fromStoryboard: "Util"
		) as! EditPainTableViewController
		guard let pain = filteredSamples[indexPath.row] as? Pain else {
			Me.log.error("Failed to cast result sample as Pain")
			return
		}
		controller.pain = pain
		controller.notificationToSendOnAccept = Me.editedSample
		tableView.deselectRow(at: indexPath, animated: false)
		if navigationController != nil {
			pushToNavigationController(controller)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	// MARK: - Helper functions

	private func acceptSamples(_ incoming: [Sample]?) {
		guard !isClosed else { return }
		queryWork?.cancel(); queryWork = nil
		activeRefreshQuery?.stop(); activeRefreshQuery = nil
		sortWork?.cancel()
		sortWork = nil
		dismissSortProgress()
		storedSamples = incoming
		guard !failed else { return }
		guard let incoming = incoming else {
			filteredSamples = nil
			return
		}
		if !initialSampleSortDone, let first = incoming.first {
			if let _ = incoming as? [SearchableSample] {
				searchController.searchResultsUpdater = self
				searchController.obscuresBackgroundDuringPresentation = false
				searchController.searchBar.placeholder = "Search \(type(of: first).name) entries"
				searchController.hidesNavigationBarDuringPresentation = false
				navigationItem.searchController = searchController
				navigationItem.hidesSearchBarWhenScrolling = false
				definesPresentationContext = true
			} else { searchController.searchBar.isHidden = true }
			if let attribute = first.attributes.first {
				let count = injected(SampleGroupInformationFactory.self).initInformation(CountInformation.self, attribute)
				if !information.contains(where: { $0.name == count.name }) { information.append(count) }
			}
			sortAttribute = first.attributes.first { $0 is DateAttribute }
			sortOrder = .orderedDescending
			initialSampleSortDone = true
		}
		startSorting(incoming, showProgress: false)
	}

	/// Entry point shared by the sort chooser and controlled regression tests.
	final func sortResults(by attribute: Attribute, order: ComparisonResult) {
		guard !isClosed, let current = storedSamples else { return }
		sortAttribute = attribute
		sortOrder = order
		startSorting(current, showProgress: true)
	}

	final func cancelSorting() {
		guard sortWork != nil else { return }
		sortWork?.cancel()
		sortWork = nil
		(sortAttribute, sortOrder) = publishedSort
		dismissSortProgress()
		if filteredSamples != nil { viewIsReady() }
	}

	private func startSorting(_ input: [Sample], showProgress: Bool) {
		sortWork?.cancel()
		dismissSortProgress()
		let work = ResultsWork()
		sortWork = work
		finishedLoading = false
		if isViewLoaded { disableActionsButton() }
		let snapshot: ResultsSortSnapshot
		do { snapshot = try ResultsSortSnapshot(samples: input, attribute: sortAttribute, order: sortOrder ?? .orderedDescending) }
		catch {
			(sortAttribute, sortOrder) = publishedSort
			publishResults(input, for: work)
			tellUserSortFailed()
			return
		}
		if showProgress, viewIfLoaded?.window != nil {
			let progress = UIAlertController(title: "Sorting by \(sortAttribute?.name ?? "date")", message: nil, preferredStyle: .actionSheet)
			progress.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
				guard self?.sortWork === work else { return }
				self?.cancelSorting()
			})
			progress.popoverPresentationController?.barButtonItem = actionsButton
			sortActionSheet = progress
			present(progress, animated: false)
		}
		injected(AsyncUtil.self).run(qos: .userInteractive) { [weak self] in
			guard !work.isCancelled else { return }
			do {
				guard let indices = try snapshot.sort(using: work) else { return }
				resultsOnMain { [weak self] in
					guard let self = self, !self.isClosed, self.sortWork === work, !work.isCancelled else { return }
					self.publishResults(indices.map { input[$0] }, for: work)
				}
			} catch {
				resultsOnMain { [weak self] in
					guard let self = self, self.sortWork === work, !work.isCancelled else { return }
					(self.sortAttribute, self.sortOrder) = self.publishedSort
					self.publishResults(input, for: work)
					self.tellUserSortFailed()
				}
			}
		}
	}

	private func publishResults(_ result: [Sample], for work: ResultsWork) {
		guard !isClosed, sortWork === work, !work.isCancelled else { return }
		sortWork = nil
		storedSamples = result
		publishedSort = (sortAttribute, sortOrder)
		filterSamples()
		viewIsReady()
		dismissSortProgress()
		if result.isEmpty {
			DispatchQueue.main.async { [weak self] in
				guard let self = self, !self.isClosed, self.sortWork == nil, self.storedSamples?.isEmpty == true else { return }
				self.showError(title: "No results", message: nil, onDismiss: { [weak self] _ in self?.popFromNavigationController() })
			}
		}
	}

	private func dismissSortProgress() {
		sortActionSheet?.dismiss(animated: false)
		sortActionSheet = nil
	}

	private final func viewIsReady() {
		finishedLoading = true
		if isViewLoaded { enableActionsButton() }
	}

	private final func waiting() -> Bool {
		filteredSamples == nil
	}

	// leave non-private for testing
	final func recomputeInformation() {
		guard let filteredSamples = filteredSamples else {
			informationValues = Array(repeating: nil, count: information.count)
			return
		}
		var newInformationValues = [String]()
		for index in 0 ..< information.count {
			do {
				let value = try information[index].compute(forSamples: filteredSamples)
				newInformationValues.append(value)
			} catch {
				Me.log.error("Failed to compute %@ information: %@", information[index].name, errorInfo(error))
				newInformationValues.append("") // avoid any index out of bounds errors
			}
		}
		informationValues = newInformationValues
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
		(samples?.first?.attributes ?? []).filter {
			self.isSortableAttribute($0)
		}
	}

	private final func isSortableAttribute(_ attribute: Attribute) -> Bool {
		attribute is ComparableAttribute
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
		guard !isClosed, sortWork == nil else { return }
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
