//
//  ResultsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import CoreData
import os

final class ResultsViewController: UITableViewController {

	// MARK: - Static Member Variables

	private typealias Me = ResultsViewController
	private static let editedExtraInformation = Notification.Name("editedExtraInformationFromResultsView")
	private static let sortSamples = Notification.Name("sortSamplesBy")
	private static let sortPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 245), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var actionsButton: UIBarButtonItem!

	// MARK: - Instance Member Variables

	public final var query: Query!
	public final var samples: [Sample]! {
		didSet {
			if error == nil && samples != nil  {
				DispatchQueue.global(qos: .userInteractive).async { self.viewIsReady() }
			}
		}
	}
	public final var error: Error? {
		didSet {
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}

	private final var extraInformation = [ExtraInformation]()
	private final var extraInformationValues: [String]!
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

	// MARK: - UIViewController Overloads

	public final override func viewDidLoad() {
		disableActionsButton()
		actionsButton.target = self
		actionsButton.action = #selector(presentActions)

		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedExtraInformation), name: Me.editedExtraInformation, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(sortSamplesBy), name: Me.sortSamples, object: nil)

		self.navigationItem.setRightBarButton(actionsButton, animated: true)

		UiUtil.setBackButton(for: self, title: "Query", action: #selector(done))

		tableView.flashScrollIndicators()
		finishedLoading = true
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
				return samples[0].name.capitalized
			}
			return "Entries"
		} else {
			os_log("Unexpected section index while getting section title", type: .error)
			return nil
		}
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if error != nil {
			if section == 1 {
				return 1
			}
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

		os_log("Unexpected section index (%@) while determining number of rows in section", type: .error, String(section))
		return 0
	}

	// MARK: - Table View Delegate

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		let section = indexPath.section

		if error != nil {
			let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
			var errorText = error!.localizedDescription
			if error is DisplayableError {
				errorText = (error as! DisplayableError).displayableDescription
			}
			cell.textLabel!.text = errorText
			return cell
		}

		if waiting() || sortTask != nil {
			return tableView.dequeueReusableCell(withIdentifier: "waitingCell", for: indexPath)
		}

		if section == 0 {
			let cell = (tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! ExtraInformationTableViewCell)
			cell.extraInformation = extraInformation[row]
			cell.value = extraInformationValues[row]
			return cell
		}

		if section == 1 {
			let sample = samples[row]
			switch (samples[0]) {
				case is BloodPressure:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "bloodPressureCell", for: indexPath) as! BloodPressureTableViewCell)
					cell.sample = (sample as! BloodPressure)
					return cell
				case is HealthKitQuantitySample:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "healthKitQuantitySampleCell", for: indexPath) as! HealthKitQuantitySampleTableViewCell)
					cell.sample = (sample as! HealthKitQuantitySample)
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

		os_log("Unexpected section index (%@) while instantiating cell", type: .error, String(section))
		return UITableViewCell()
	}

	final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 || waiting() { return 44 }
		switch (samples[indexPath.row]) {
			case is BloodPressure,
				 is BodyMassIndex,
				 is HeartRate,
				 is LeanBodyMass,
				 is SexualActivity,
				 is Sleep,
				 is Weight:
				return 44
			case is Mood:
				return 67
			default:
				fatalError("Forgot a type of Sample")
		}
	}

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			extraInformationEditIndex = indexPath.row
			let selectedInformation = extraInformation[extraInformationEditIndex]

			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "editExtraInformation") as! SelectExtraInformationViewController
			controller.notificationToSendWhenFinished = Me.editedExtraInformation
			controller.attributes = samples[0].attributes
			controller.selectedAttribute = selectedInformation.attribute
			controller.selectedInformation = selectedInformation
			if navigationController != nil {
				navigationController!.pushViewController(controller, animated: true)
			} else {
				present(controller, animated: true, completion: nil)
			}
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
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			if indexPath.section == 0 {
				self.extraInformation.remove(at: indexPath.row)
				self.extraInformationValues.remove(at: indexPath.row)
			} else if indexPath.section == 1 {
				guard let managedSample = self.samples[indexPath.row] as? NSManagedObject else { return }
				DispatchQueue.global(qos: .background).async {
					DependencyInjector.db.delete(managedSample)
					DependencyInjector.db.save()
				}
				self.samples.remove(at: indexPath.row)
			}
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

	// MARK: - Navigation

	@objc final func saveEditedExtraInformation(notification: Notification) {
		let selectedInformation = notification.object as! ExtraInformation
		extraInformation[extraInformationEditIndex] = selectedInformation
		recomputeExtraInformation()
		tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
	}

	// MARK: - Button Actions

	@objc private final func presentActions() {
		actionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		actionsController?.addAction(UIAlertAction(title: "Graph", style: .default) { _ in self.graph() })
		if samplesAreSortable() {
			actionsController?.addAction(UIAlertAction(title: "Sort", style: .default) { _ in self.setSampleSort() })
		}
		actionsController?.addAction(UIAlertAction(title: "Add Information", style: .default) { _ in self.addInformation() })
		if samplesAreDeletable() {
			actionsController?.addAction(UIAlertAction(title: "Delete All " + samples[0].name + " Entries", style: .default) { _ in self.deleteAllSamples() })
		}
		actionsController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(actionsController!, animated: false, completion: nil)
	}

	@objc private final func done() {
		query.stop()
		self.navigationController?.popViewController(animated: true)
	}

	@objc private final func graph() {
		let controller = UIStoryboard(name: "GraphChooser", bundle: nil).instantiateViewController(withIdentifier: "QueryResultsGraphTypeChooser") as! QueryResultsGraphTypeTableViewController
		controller.samples = samples
		navigationController?.pushViewController(controller, animated: false)
	}

	@objc private final func setSampleSort() {
		let controller = self.storyboard!.instantiateViewController(withIdentifier: "sortResults") as! SortResultsViewController
		controller.attributes = self.sortableAttributes()
		controller.sortAttribute = self.sortAttribute
		controller.sortOrder = self.sortOrder
		controller.notificationToSendOnAccept = Me.sortSamples
		self.customPresentViewController(Me.sortPresenter, viewController: controller, animated: true)
	}

	@objc private final func addInformation() {
		let attribute = type(of: samples[0]).defaultDependentAttribute
		let information = DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: attribute)[0].init(attribute)
		extraInformation.append(information)
		recomputeExtraInformation()
		tableView.reloadData()
	}

	@objc private final func deleteAllSamples() {
		DispatchQueue.global(qos: .userInitiated).async {
			// TODO - tell the user something went wrong if an error is thrown here
			try! DependencyInjector.db.deleteAll(self.samples as! [NSManagedObject])
			DependencyInjector.db.save()
		}
		navigationController!.popViewController(animated: true)
	}

	// MARK: - Received Notifications

	@objc private final func sortSamplesBy(notification: Notification) {
		sortController?.dismiss(animated: false, completion: nil)

		let sortCriteria = notification.object as! (attribute: Attribute, order: ComparisonResult)
		self.sortOrder = sortCriteria.order
		self.sortAttribute = sortCriteria.attribute
		self.sortTask = DispatchWorkItem {
			DispatchQueue.main.sync{
				self.tableView.reloadData()
				self.sortActionSheet = UIAlertController(title: "Sorting by \(self.sortAttribute!.name)", message: nil, preferredStyle: .actionSheet)
				self.sortActionSheet?.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
					self.sortTask?.cancel()
					self.sortTask = nil
					self.tableView.reloadData()
				})
				self.present(self.sortActionSheet!, animated: false, completion: nil)
			}

			switch (self.sortAttribute) {
				case is DoubleAttribute: self.sortByDouble(); break
				case is IntegerAttribute: self.sortByInteger(); break
				case is TextAttribute: self.sortByText(); break
				case is DateAttribute: self.sortByDate(); break
				case is DayOfWeekAttribute: self.sortByDayOfWeek(); break
				case is TimeOfDayAttribute: self.sortByTimeOfDay(); break
				default:
					os_log("Unknown sort attribute type: %@", type: .error, String(describing: type(of: self.sortAttribute)))
			}
			self.sortTask = nil
			DispatchQueue.main.async{
				self.sortActionSheet?.dismiss(animated: false, completion: nil)
				self.tableView.reloadData()
			}
		}
		DispatchQueue.global(qos: .userInteractive).async(execute: self.sortTask!)
	}

	// MARK: - Helper functions

	private final func viewIsReady() {
		while !finishedLoading {} // this ensures that the actions button does not get disabled after everything loads
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
			extraInformationValues.append(try! extraInformation[index].compute(forSamples: samples))
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
		return attribute is NumericAttribute ||
			attribute is TextAttribute ||
			attribute is DateAttribute ||
			attribute is DayOfWeekAttribute ||
			attribute is TimeOfDayAttribute
	}

	private final func sortByDouble() {
		do {
			samples = try samples.sorted() {
				if self.sortTask == nil || self.sortTask!.isCancelled { return true }
				let value1 = try $0.value(of: self.sortAttribute!) as? Double
				let value2 = try $1.value(of: self.sortAttribute!) as? Double
				if value1 == nil && value2 == nil { return true }
				if value1 == nil { return true }
				if value2 == nil { return false }
				if self.sortOrder == .orderedAscending {
					return value1! <= value2!
				}
				return value1! >= value2!
			}
		} catch {
			os_log("Failed to sort by DoubleAttribute: %@", type: .error, error.localizedDescription)
			tellUserSortFailed()
		}
	}

	private final func sortByInteger() {
		do {
			samples = try samples.sorted() {
				if self.sortTask == nil || self.sortTask!.isCancelled { return true }
				let value1 = try $0.value(of: self.sortAttribute!) as? Int
				let value2 = try $1.value(of: self.sortAttribute!) as? Int
				if value1 == nil && value2 == nil { return true }
				if value1 == nil { return true }
				if value2 == nil { return false }
				if self.sortOrder == .orderedAscending {
					return value1! <= value2!
				}
				return value1! >= value2!
			}
		} catch {
			os_log("Failed to sort by IntegerAttribute: %@", type: .error, error.localizedDescription)
			tellUserSortFailed()
		}
	}

	private final func sortByText() {
		do {
			samples = try samples.sorted() {
				if self.sortTask == nil || self.sortTask!.isCancelled { return true }
				let value1 = try $0.value(of: self.sortAttribute!) as? String
				let value2 = try $1.value(of: self.sortAttribute!) as? String
				if value1 == nil && value2 == nil { return true }
				if value1 == nil { return true }
				if value2 == nil { return false }
				if self.sortOrder == .orderedAscending {
					return value1! <= value2!
				}
				return value1! >= value2!
			}
		} catch {
			os_log("Failed to sort by TextAttribute: %@", type: .error, error.localizedDescription)
			tellUserSortFailed()
		}
	}

	private final func sortByDate() {
		do {
			samples = try samples.sorted() {
				if self.sortTask == nil || self.sortTask!.isCancelled { return true }
				let value1 = try $0.value(of: self.sortAttribute!) as? Date
				let value2 = try $1.value(of: self.sortAttribute!) as? Date
				if value1 == nil && value2 == nil { return true }
				if value1 == nil { return true }
				if value2 == nil { return false }
				if self.sortOrder == .orderedAscending {
					return value1! <= value2!
				}
				return value1! >= value2!
			}
		} catch {
			os_log("Failed to sort by DateAttribute: %@", type: .error, error.localizedDescription)
			tellUserSortFailed()
		}
	}

	private final func sortByDayOfWeek() {
		do {
			samples = try samples.sorted() {
				if self.sortTask == nil || self.sortTask!.isCancelled { return true }
				let value1 = try $0.value(of: self.sortAttribute!) as? DayOfWeek
				let value2 = try $1.value(of: self.sortAttribute!) as? DayOfWeek
				if value1 == nil && value2 == nil { return true }
				if value1 == nil { return true }
				if value2 == nil { return false }
				if self.sortOrder == .orderedAscending {
					return value1! <= value2!
				}
				return value1! >= value2!
			}
		} catch {
			os_log("Failed to sort by DayOfWeekAttribute: %@", type: .error, error.localizedDescription)
			tellUserSortFailed()
		}
	}

	private final func sortByTimeOfDay() {
		do {
			samples = try samples.sorted() {
				if self.sortTask == nil || self.sortTask!.isCancelled { return true }
				let value1 = try $0.value(of: self.sortAttribute!) as? TimeOfDay
				let value2 = try $1.value(of: self.sortAttribute!) as? TimeOfDay
				if value1 == nil && value2 == nil { return true }
				if value1 == nil { return true }
				if value2 == nil { return false }
				if self.sortOrder == .orderedAscending {
					return value1! <= value2!
				}
				return value1! >= value2!
			}
		} catch {
			os_log("Failed to sort by TimeOfDayAttribute: %@", type: .error, error.localizedDescription)
			tellUserSortFailed()
		}
	}

	private final func tellUserSortFailed() {
		let alert = UIAlertController(title: "Failed to sort", message: "Sorry for the inconvenience.", preferredStyle: .alert)
		present(alert, animated: false, completion: nil)
	}
}
