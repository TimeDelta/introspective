//
//  QueryViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

class QueryViewController: UITableViewController {

	// MARK: - Enums / Structs

	public enum PartType: CustomStringConvertible {
		case dataType
		case attributeRestriction
		public static let allTypes = [dataType, attributeRestriction]
		public var description: String {
			switch (self) {
				case .dataType: return "Data Type"
				case .attributeRestriction: return "Attribute Restriction"
			}
		}
	}

	struct Part {
		public var dataTypeInfo: DataTypeInfo? = nil
		public var attributeRestriction: AttributeRestriction? = nil

		public init(_ dataTypeInfo: DataTypeInfo) {
			self.dataTypeInfo = dataTypeInfo
		}

		public init(_ attributeRestriction: AttributeRestriction) {
			self.attributeRestriction = attributeRestriction
		}
	}

	struct DataTypeInfo {
		var sampleType: Sample.Type = DependencyInjector.sample.allTypes()[0]
		var matcher: SubQueryMatcher? = SameDatesSubQueryMatcher()

		init() {}
		init(_ sampleType: Sample.Type) {
			self.sampleType = sampleType
		}
		init(_ sampleType: Sample.Type, _ matcher: SubQueryMatcher) {
			self.sampleType = sampleType
			self.matcher = matcher
		}
	}

	// MARK: - Static Member Variables

	private typealias Me = QueryViewController
	private static let acceptedAttributeRestrictionEdit = Notification.Name("acceptedAttributeRestrictionEdit")
	private static let acceptedSubDataTypeEdit = Notification.Name("acceptedSubDataTypeEdit")
	private static let addQuestionPart = Notification.Name("addQuestionPart")
	private static let acceptedDataTypeEdit = Notification.Name("acceptedDataTypeEdit")
	private static let runQueryNotification = Notification.Name("runQuery")

	private static let addQuestionPartPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()
	private static let editDataTypePresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var addPartButton: UIBarButtonItem!
	@IBOutlet weak final var finishedButton: UIBarButtonItem!
	@IBOutlet weak final var editButton: UIBarButtonItem!

	// MARK: - Instance Member Variables

	public final var finishedButtonTitle: String! = "Run"
	/// Corresponding notification object will contain the built query as the object
	public final var finishedButtonNotification: Notification.Name! = Me.runQueryNotification
	public final var topmostSampleType: Sample.Type?

	final var parts: [Part]!
	private final var editedIndex: Int!

	// MARK: - UIViewController Overloads

	override func viewDidLoad() {
		super.viewDidLoad()

		editButton.target = editButtonItem.target
		editButton.action = editButtonItem.action

		finishedButton.title = finishedButtonTitle

		if topmostSampleType != nil {
			parts = [Part(DataTypeInfo(topmostSampleType!))]
		} else {
			parts = [Part(DataTypeInfo())]
		}

		partWasAdded()

		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedAttributeRestriction), name: Me.acceptedAttributeRestrictionEdit, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedSubQueryDataType), name: Me.acceptedSubDataTypeEdit, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(addQuestionPart), name: Me.addQuestionPart, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedSampleType), name: Me.acceptedDataTypeEdit, object: nil)

		addPartButton?.target = self
		addPartButton?.action = #selector(addPartButtonWasPressed)
	}

	// MARK: - Table View Data Source

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return parts.count
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let index = indexPath.row
		let part = parts[index]

		if index == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Data Type", for: indexPath)
			cell.textLabel?.text = part.dataTypeInfo!.sampleType.name
			if topmostSampleType != nil {
				cell.isUserInteractionEnabled = false
			}
			return cell
		}


		if let dataTypeInfo = part.dataTypeInfo {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Sub Data Type", for: indexPath) as! SubDataTypeTableViewCell
			cell.matcher = dataTypeInfo.matcher
			cell.sampleType = dataTypeInfo.sampleType
			return cell
		}
		if let attributeRestriction = part.attributeRestriction {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Attribute Restriction", for: indexPath) as! AttributeRestrictionTableViewCell
			cell.attributeRestriction = attributeRestriction
			return cell
		}
		os_log("Forgot a type of cell: %@", type: .error, String(describing: part))
		return UITableViewCell()
	}

	// MARK: - Table View Delegate

	final override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != 0
	}

	final override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != 0
	}

	final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		parts.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			self.parts.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.row == 0 {
			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseSampleType") as! ChooseSampleTypeViewController
			editedIndex = 0
			controller.selectedSampleType = parts[0].dataTypeInfo!.sampleType
			controller.notificationToSendOnAccept = Me.acceptedDataTypeEdit
			tableView.deselectRow(at: indexPath, animated: true)
			customPresentViewController(Me.editDataTypePresenter, viewController: controller, animated: true)
		}
	}

	// MARK: - Button Actions

	@IBAction final func finishedButtonPressed(_ sender: Any) {
		let query = buildQuery()
		if finishedButtonNotification != Me.runQueryNotification {
			NotificationCenter.default.post(name: finishedButtonNotification, object: query)
			navigationController?.popViewController(animated: true)
		} else {
			let controller = UIStoryboard(name: "Results", bundle: nil).instantiateViewController(withIdentifier: "results") as! ResultsViewController
			query.runQuery { (result: QueryResult?, error: Error?) in
				if error != nil {
					controller.error = error
					return
				}
				controller.samples = result?.samples
			}
			controller.query = query
			navigationController?.pushViewController(controller, animated: true)
		}
	}

	@objc private final func addPartButtonWasPressed() {
		let controller = storyboard!.instantiateViewController(withIdentifier: "addQuestionPart") as! AddToQueryViewController
		controller.notificationToSendOnAccept = Me.addQuestionPart
		customPresentViewController(Me.addQuestionPartPresenter, viewController: controller, animated: true)
	}

	// MARK: - Navigation

	final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditAttributeRestrictionViewController {
			let controller = (segue.destination as! EditAttributeRestrictionViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.sampleType = bottomMostDataTypeAbove(index: editedIndex)
			controller.attributeRestriction = parts[editedIndex].attributeRestriction!
			controller.notificationToSendWhenAccepted = Me.acceptedAttributeRestrictionEdit
		} else if segue.destination is EditSubDataTypeViewController {
			let controller = (segue.destination as! EditSubDataTypeViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.sampleType = parts[editedIndex].dataTypeInfo!.sampleType
			controller.matcher = parts[editedIndex].dataTypeInfo!.matcher
			controller.notificationToSendWhenAccepted = Me.acceptedSubDataTypeEdit
		}
	}

	// MARK: - Received Notifications

	@objc final func saveEditedSampleType(notification: Notification) {
		let sampleType = notification.object as! Sample.Type
		parts[editedIndex] = Part(DataTypeInfo(sampleType))
		tableView.reloadData()
	}

	@objc final func saveEditedAttributeRestriction(notification: Notification) {
		parts[editedIndex] = Part(notification.object as! AttributeRestriction)
		tableView.reloadData()
	}

	@objc final func saveEditedSubQueryDataType(notification: Notification) {
		parts[editedIndex] = Part(notification.object as! DataTypeInfo)
		tableView.reloadData()
	}

	@objc final func addQuestionPart(notification: Notification) {
		let type = notification.object as! PartType
		switch (type) {
			case .dataType:
				parts.append(Part(DataTypeInfo()))
				break
			case .attributeRestriction:
				let lastDataType = bottomMostDataType()
				let attribute = lastDataType.defaultDependentAttribute
				let restrictionType = DependencyInjector.restriction.typesFor(attribute)[0]
				let attributeRestriction = DependencyInjector.restriction.initialize(type: restrictionType, forAttribute: attribute)
				parts.append(Part(attributeRestriction))
				break
		}

		partWasAdded()
	}

	// Mark: - Helper Functions

	private final func bottomMostDataType() -> Sample.Type {
		return bottomMostDataType(in: parts)
	}

	private final func bottomMostDataType(in parts: [Part]) -> Sample.Type {
		var index = parts.count - 1
		while index >= 0 && parts[index].dataTypeInfo == nil {
			index -= 1
		}
		return parts[index].dataTypeInfo!.sampleType
	}

	private final func bottomMostDataTypeAbove(index: Int) -> Sample.Type {
		for part in parts[0 ... index].reversed() {
			if part.dataTypeInfo != nil {
				return part.dataTypeInfo!.sampleType
			}
		}
		return parts[0].dataTypeInfo!.sampleType // this will never happen but the compiler can't know that
	}

	private final func closestDataType(aboveIndex: Int) -> Sample.Type {
		var index = aboveIndex
		while index >= 0 && parts[index].dataTypeInfo == nil {
			index -= 1
		}
		return parts[index].dataTypeInfo!.sampleType
	}

	private final func partWasAdded() {
		let indexPath = IndexPath(row: parts.count - 1, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}

	private final func buildQuery() -> Query {
		let partsSplitByQuery = splitPartsByQuery()
		var currentTopmostQuery: Query? = nil
		for parts in partsSplitByQuery {
			var currentQuery: Query

			let dataTypeInfo = parts[0].dataTypeInfo!
			switch (dataTypeInfo.sampleType) {
				case is BloodPressure.Type:
					currentQuery = DependencyInjector.query.bloodPressureQuery()
					break
				case is BodyMassIndex.Type:
					currentQuery = DependencyInjector.query.bmiQuery()
					break
				case is HeartRate.Type:
					currentQuery = DependencyInjector.query.heartRateQuery()
					break
				case is LeanBodyMass.Type:
					currentQuery = DependencyInjector.query.leanBodyMassQuery()
					break
				case is MoodImpl.Type:
					currentQuery = DependencyInjector.query.moodQuery()
					break
				case is RestingHeartRate.Type:
					currentQuery = DependencyInjector.query.restingHeartRateQuery()
					break
				case is SexualActivity.Type:
					currentQuery = DependencyInjector.query.sexualActivityQuery()
					break
				case is Sleep.Type:
					currentQuery = DependencyInjector.query.sleepQuery()
					break
				case is Weight.Type:
					currentQuery = DependencyInjector.query.weightQuery()
					break
				default: fatalError("Forgot a type of Sample")
			}

			buildQuery(&currentQuery, from: parts)

			if currentTopmostQuery != nil {
				currentTopmostQuery?.subQuery = (matcher: dataTypeInfo.matcher!, query: currentQuery)
			} else {
				currentTopmostQuery = currentQuery
			}
		}
		return currentTopmostQuery!
	}

	private final func buildQuery(_ query: inout Query, from parts: [Part]) {
		for part in parts.reversed() {
			if let attributeRestriction = part.attributeRestriction {
				query.attributeRestrictions.append(attributeRestriction)
			} else if part.dataTypeInfo == nil {
				os_log("Forgot a type of query part: %@", type: .error, String(describing: part))
			}
		}
	}

	private final func splitPartsByQuery() -> [[Part]] {
		var partsSplitByQuery = [[Part]]()
		var currentParts = [Part]()
		for part in parts {
			if part.dataTypeInfo != nil && !currentParts.isEmpty {
				partsSplitByQuery.append(currentParts)
				currentParts = [Part]()
			}
			currentParts.append(part)
		}
		if !currentParts.isEmpty {
			partsSplitByQuery.append(currentParts)
		}
		return partsSplitByQuery
	}

	private final func distanceToNextDataType(index: Int) -> Int {
		var distance = 0
		for part in parts {
			if part.dataTypeInfo != nil {
				return distance
			}
			distance += 1
		}
		return distance
	}
}
