//
//  ResultsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import NotificationBannerSwift
import CoreData

final class ResultsViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = ResultsViewController
	private static let editedExtraInformation = Notification.Name("editedExtraInformationFromResultsScreen")
	private static let sortSamples = Notification.Name("sortSamplesBy")
	private static let editedSample = Notification.Name("editedSampleFromResultsScreen")
	private static let sortPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 245), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var actionsButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var query: Query!
	public final var samples: [Sample]! {
		didSet {
			if !failed && samples != nil  {
				self.viewIsReady()
			}
		}
	}

	public final var backButtonTitle: String?

	private final var extraInformation = [ExtraInformation]()
	private final var extraInformationValues: [String?]!
	private final var lastSelectedRowIndex: Int!
	private final var extraInformationEditIndex: Int!
	private final var actionsPresenter: Presentr!
	private final var finishedLoading = false

	private final var actionsController: UIAlertController?

	private final var sortAttribute: Attribute?
	private final var sortOrder: ComparisonResult?
	private final var sortTask: DispatchWorkItem?
	private final var sortActionSheet: UIAlertController?
	private final var sortController: SortResultsViewController?

	private final var failed = false

	private final let log = Log()

	// MARK: - UIViewController Overloads

	public final override func viewDidLoad() {
		actionsButton.target = self
		actionsButton.action = #selector(presentActions)
		actionsButton.accessibilityLabel = "actions button"

		observe(selector: #selector(saveEditedExtraInformation), name: Me.editedExtraInformation)
		observe(selector: #selector(sortSamplesBy), name: Me.sortSamples)
		observe(selector: #selector(editedSample), name: Me.editedSample)

		navigationItem.setRightBarButton(actionsButton, animated: false)

		DependencyInjector.util.ui.setBackButton(for: self, title: backButtonTitle ?? "Query", action: #selector(done))

		tableView.flashScrollIndicators()
		finishedLoading = true

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44
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
		onDonePresenting: (() -> Void)? = nil)
	{
		var onDismiss: ((UIAlertAction) -> Void)? = originalOnDismiss
		if samples == nil {
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
			onDonePresenting: onDonePresenting)
	}

	// MARK: - Table View Data Source

	final override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Extra Information"
		} else if section == 1 {
			if samples != nil && samples.count > 0 {
				return samples[0].attributedName.capitalized
			}
			return "Entries"
		} else {
			log.error("Unexpected section index while getting section title")
			return nil
		}
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if failed {
			return 0
		}

		if waiting() {
			return 1
		}

		if section == 0 {
			return extraInformation.count
		}

		if section == 1 {
			return samples.count
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
			guard let value = extraInformationValues[row] else {
				return tableView.dequeueReusableCell(withIdentifier: "waitingCell", for: indexPath)
			}
			let cell = (tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! ExtraInformationTableViewCell)
			cell.extraInformation = extraInformation[row]
			cell.value = value
			return cell
		}

		if section == 1 {
			let sample = samples[row]
			switch (sample) {
				case is Activity:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "activityCell") as! ActivityTableViewCell)
					cell.activity = (sample as! Activity)
					return cell
				case is BloodPressure:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "bloodPressureCell", for: indexPath) as! BloodPressureTableViewCell)
					cell.sample = (sample as! BloodPressure)
					return cell
				case is HealthKitQuantitySample:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "healthKitQuantitySampleCell", for: indexPath) as! HealthKitQuantitySampleTableViewCell)
					cell.sample = (sample as! HealthKitQuantitySample)
					return cell
				case is MedicationDose:
					let cell = tableView.dequeueReusableCell(withIdentifier: "medicationDoseCell", for: indexPath) as! MedicationDoseTableTableViewCell
					cell.medicationDose = (sample as! MedicationDose)
					return cell
				case is Mood:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "moodSampleCell", for: indexPath) as! MoodTableViewCell)
					cell.mood = (sample as! Mood)
					return cell
				case is SexualActivity:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "sexualActivityCell", for: indexPath) as! SexualActivityTableViewCell)
					cell.sample = (sample as! SexualActivity)
					return cell
				case is Sleep:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "sleepCell", for: indexPath) as! SleepTableViewCell)
					cell.sleep = (sample as! Sleep)
					return cell
				default:
					fatalError("Forgot a type of Sample")
			}
		}

		log.error("Unexpected section index (%@) while instantiating cell", String(section))
		return UITableViewCell()
	}

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard finishedLoading else { return }
		if indexPath.section == 0 {
			showEditInformationView(indexPath)
		} else if samples[indexPath.row] is Activity {
			showEditActivityView(indexPath)
		} else if samples[indexPath.row] is Mood {
			showEditMoodView(indexPath)
		}
	}

	// MARK: - TableView Editing

	final override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 0 || samplesAreDeletable()
	}

	final override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 0
	}

	final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		extraInformation.swapAt(fromIndexPath.row, to.row)
		extraInformationValues.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		guard let managedSample = self.samples[indexPath.row] as? NSManagedObject else { return [] }
		let delete = UITableViewRowAction(style: .destructive, title: "🗑️") { _, indexPath in
			if indexPath.section == 0 {
				self.extraInformation.remove(at: indexPath.row)
				self.extraInformationValues.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .fade)
				tableView.reloadData()
			} else if indexPath.section == 1 {
				let alert = UIAlertController(title: "Are you sure you want to delete this?", message: nil, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
					let goBackAfterDelete = self.samples.count == 1
					do {
						let transaction = DependencyInjector.db.transaction()
						try retryOnFail({ try transaction.delete(managedSample) }, maxRetries: 2)
						if goBackAfterDelete {
							self.navigationController?.popViewController(animated: false)
						} else {
							self.samples.remove(at: indexPath.row)
							tableView.deleteRows(at: [indexPath], with: .fade)
							tableView.reloadData()
						}
					} catch {
						self.log.error("Failed to delete sample: %@", errorInfo(error))
						self.showError(
							title: "Failed to delete " + self.samples[indexPath.row].attributedName.localizedLowercase,
							error: error)
					}
				})
				alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
				self.present(alert, animated: false, completion: nil)
			}
		}

		return [delete]
	}

	// MARK: - Received Notifications

	@objc private final func saveEditedExtraInformation(notification: Notification) {
		if let selectedInformation: ExtraInformation? = value(for: .information, from: notification) {
			if let editIndex = extraInformationEditIndex {
				// selectedInformation can no longer be nil even though it's type is Optional
				extraInformation[editIndex] = selectedInformation!
				extraInformationValues[editIndex] = nil
				tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
				DispatchQueue.global(qos: .userInteractive).async {
					do {
						self.extraInformationValues[editIndex] =
							try self.extraInformation[editIndex].compute(forSamples: self.samples)
						DispatchQueue.main.async {
							self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
						}
					} catch {
						self.log.error("Failed to compute %@ information: %@", selectedInformation!.name, errorInfo(error))
						DispatchQueue.main.async {
							self.showError(title: "Failed to compute \(selectedInformation!.name) information", error: error)
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
			samples[lastSelectedRowIndex] = sample!
			tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
		}
	}

	@objc private final func sortSamplesBy(notification: Notification) {
		sortController?.dismiss(animated: false, completion: nil)

		guard let attribute: Attribute? = value(for: .attribute, from: notification) else { return }
		guard let order: ComparisonResult? = value(for: .comparisonResult, from: notification) else { return }
		self.sortOrder = order
		self.sortAttribute = attribute

		self.sortActionSheet = UIAlertController(title: "Sorting by \(self.sortAttribute!.name)", message: nil, preferredStyle: .actionSheet)
		self.sortActionSheet?.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
			self.sortTask?.cancel()
			self.sortTask = nil
			self.tableView.reloadData()
		})
		self.present(self.sortActionSheet!, animated: false, completion: nil)

		self.sortTask = DispatchWorkItem {
			switch (self.sortAttribute) {
				case is DoubleAttribute: self.sort(by: Double.self); break
				case is IntegerAttribute: self.sort(by: Int.self); break
				case is TextAttribute: self.sort(by: String.self); break
				case is DateAttribute: self.sort(by: Date.self); break
				case is DayOfWeekAttribute: self.sort(by: DayOfWeek.self); break
				case is TimeOfDayAttribute: self.sort(by: TimeOfDay.self); break
				case is DurationAttribute: self.sort(by: Duration.self); break
				case is FrequencyAttribute: self.sort(by: Frequency.self); break
				case is DosageAttribute: self.sort(by: Dosage.self); break
				default:
					self.log.error("Unknown sort attribute type: %@", String(describing: type(of: self.sortAttribute)))
			}
			self.sortTask = nil
			DispatchQueue.main.async{
				self.sortActionSheet?.dismiss(animated: false, completion: nil)
				self.tableView.reloadData()
			}
		}
		DispatchQueue.global(qos: .userInteractive).async(execute: self.sortTask!)
	}

	// MARK: - Button Actions

	@objc private final func presentActions() {
		actionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		actionsController?.addAction(UIAlertAction(title: "Graph", style: .default) { _ in self.graph() })
		if samplesAreSortable() {
			actionsController?.addAction(UIAlertAction(title: "Sort", style: .default) { _ in self.setSampleSort() })
		}
		actionsController?.addAction(UIAlertAction(title: "Add Information", style: .default) { _ in DispatchQueue.main.async{ self.addInformation() } })
		if samplesAreDeletable() {
			actionsController?.addAction(UIAlertAction(
				title: "Delete these " + samples[0].attributedName.localizedLowercase + " entries",
				style: .default,
				handler: { _ in
					self.deleteAllSamples()
				}))
		}
		actionsController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(actionsController!, animated: false, completion: nil)
	}

	@objc private final func done() {
		query.stop()
		self.navigationController?.popViewController(animated: false)
	}

	@objc private final func graph() {
		let controller: QueryResultsGraphSetupViewController = viewController(named: "queryResultsGraphSetup", fromStoryboard: "GraphSetup")
		controller.samples = samples
		navigationController?.pushViewController(controller, animated: false)
	}

	@objc private final func setSampleSort() {
		let controller: SortResultsViewController = viewController(named: "sortResults")
		controller.attributes = self.sortableAttributes()
		controller.sortAttribute = self.sortAttribute
		controller.sortOrder = self.sortOrder
		controller.notificationToSendOnAccept = Me.sortSamples
		self.customPresentViewController(Me.sortPresenter, viewController: controller, animated: false)
	}

	@objc private final func addInformation() {
		do {
			let attribute = type(of: samples[0]).defaultDependentAttribute
			let information = DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: attribute)[0].init(attribute)
			extraInformation.append(information)
			extraInformationValues.append(try extraInformation.last!.compute(forSamples: samples))
			tableView.reloadData()
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
			preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			DispatchQueue.global(qos: .userInitiated).async {
				do {
					let transaction = DependencyInjector.db.transaction()
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
		self.present(alert, animated: false, completion: nil)
	}

	// MARK: - Display Edit Screen Functions

	private final func showEditInformationView(_ indexPath: IndexPath) {
		extraInformationEditIndex = indexPath.row
		let selectedInformation = extraInformation[extraInformationEditIndex]

		let controller: SelectExtraInformationViewController = viewController(named: "editExtraInformation", fromStoryboard: "Util")
		controller.notificationToSendWhenFinished = Me.editedExtraInformation
		controller.attributes = samples[0].attributes
		controller.selectedAttribute = selectedInformation.attribute
		controller.selectedInformation = selectedInformation
		if let navigationController = navigationController {
			navigationController.pushViewController(controller, animated: false)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	private final func showEditActivityView(_ indexPath: IndexPath) {
		lastSelectedRowIndex = indexPath.row

		let controller: EditActivityTableViewController = viewController(named: "editActivity", fromStoryboard: "RecordData")
		controller.activity = (samples[indexPath.row] as! Activity)
		controller.notificationToSendOnAccept = Me.editedSample
		controller.userInfoKey = .sample
		if navigationController != nil {
			navigationController!.pushViewController(controller, animated: false)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	private final func showEditMoodView(_ indexPath: IndexPath) {
		lastSelectedRowIndex = indexPath.row

		let controller: EditMoodTableViewController = viewController(named: "editMood", fromStoryboard: "Util")
		controller.mood = (samples[indexPath.row] as! Mood)
		controller.notificationToSendOnAccept = Me.editedSample
		controller.userInfoKey = .sample
		if navigationController != nil {
			navigationController!.pushViewController(controller, animated: false)
		} else {
			present(controller, animated: false, completion: nil)
		}
	}

	// MARK: - Helper functions

	private final func viewIsReady() {
		DispatchQueue.main.async {
			self.enableActionsButton()
			self.recomputeExtraInformation()
			self.tableView.reloadData()
		}
	}

	private final func waiting() -> Bool {
		return samples == nil
	}

	private final func recomputeExtraInformation() {
		extraInformationValues = [String]()
		for index in 0 ..< extraInformation.count {
			do {
				extraInformationValues.append(try extraInformation[index].compute(forSamples: samples))
			} catch {
				log.error("Failed to compute %@ information: %@", extraInformation[index].name, errorInfo(error))
				extraInformationValues.append("") // avoid any index out of bounds errors
			}
		}
	}

	private final func samplesAreDeletable() -> Bool {
		return (samples != nil && samples.count > 0 && samples[0] is CoreDataSample)
	}

	private final func samplesAreSortable() -> Bool {
		return sortableAttributes().count > 0
	}

	private final func disableActionsButton() {
		actionsButton.isEnabled = false
		actionsButton.tintColor = UIColor.darkGray
	}

	private final func enableActionsButton() {
		setActionsPresenter()
		actionsButton.isEnabled = true
		actionsButton.tintColor = nil
	}

	private final func setActionsPresenter() {
		var height: Float = 106
		if samplesAreDeletable() {
			height += 38
		}
		if samplesAreSortable() {
			height += 38
		}
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: height), center: .center)
		actionsPresenter = Presentr(presentationType: customType)
		actionsPresenter.dismissTransitionType = .crossDissolve
		actionsPresenter.roundCorners = true
	}

	private final func sortableAttributes() -> [Attribute] {
		return samples[0].attributes.filter() {
			return self.isSortableAttribute($0)
		}
	}

	private final func isSortableAttribute(_ attribute: Attribute) -> Bool {
		return attribute is ComparableAttribute
	}

	private final func sort<Type: Comparable>(by type: Type.Type) {
		do {
			samples = try samples.sorted() {
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
