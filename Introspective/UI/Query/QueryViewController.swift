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
		case sampleType
		case attributeRestriction
		public static let allTypes = [sampleType, attributeRestriction]
		public var description: String {
			switch (self) {
				case .sampleType: return "Data Type"
				case .attributeRestriction: return "Attribute Restriction"
			}
		}
	}

	struct Part {
		public var sampleTypeInfo: SampleTypeInfo? = nil
		public var attributeRestriction: AttributeRestriction? = nil

		public init(_ sampleTypeInfo: SampleTypeInfo) {
			self.sampleTypeInfo = sampleTypeInfo
		}

		public init(_ attributeRestriction: AttributeRestriction) {
			self.attributeRestriction = attributeRestriction
		}
	}

	struct SampleTypeInfo {
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
	private static let acceptedSubSampleTypeEdit = Notification.Name("acceptedSubSampleTypeEdit")
	private static let addQuestionPart = Notification.Name("addQuestionPart")
	private static let acceptedSampleTypeEdit = Notification.Name("acceptedSampleTypeEdit")
	private static let runQueryNotification = Notification.Name("runQuery")

	private static let addQuestionPartPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()
	private static let editSampleTypePresenter: Presentr = {
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
			parts = [Part(SampleTypeInfo(topmostSampleType!))]
		} else {
			parts = [Part(SampleTypeInfo())]
		}

		partWasAdded()

		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedAttributeRestriction), name: Me.acceptedAttributeRestrictionEdit, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedSubQuerySampleType), name: Me.acceptedSubSampleTypeEdit, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(addQueryPart), name: Me.addQuestionPart, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedSampleType), name: Me.acceptedSampleTypeEdit, object: nil)

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
			cell.textLabel?.text = part.sampleTypeInfo!.sampleType.name
			if topmostSampleType != nil {
				cell.isUserInteractionEnabled = false
			}
			return cell
		}


		if let sampleTypeInfo = part.sampleTypeInfo {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Sub Data Type", for: indexPath) as! SubSampleTypeTableViewCell
			cell.matcher = sampleTypeInfo.matcher
			cell.sampleType = sampleTypeInfo.sampleType
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
		// TODO - handle case where moving a sample type down adds invalid attribute restrictions to preceeding sample type
		parts.swapAt(fromIndexPath.row, to.row)
		if let attributeRestriction = parts[to.row].attributeRestriction {
			let sampleType = bottomMostSampleTypeAbove(index: to.row)
			if let attributeIndex = sampleType.attributes.firstIndex(where: { $0.equalTo(attributeRestriction.restrictedAttribute) }) {
				parts[to.row].attributeRestriction!.restrictedAttribute = sampleType.attributes[attributeIndex]
			} else {
				parts[to.row].attributeRestriction = defaultAttributeRestriction(for: sampleType)
			}
		} else if parts[to.row].sampleTypeInfo != nil {
			updateAttributesForSampleType(at: to.row)
			if to.row > 0 {
				let indexOfSampleTypeAbove = bottomMostSampleTypeIndex(above: to.row - 1)
				updateAttributesForSampleType(at: indexOfSampleTypeAbove)
			}
		} else {
			os_log("Unknown part type while moving row to %d", type: .debug, to.row)
		}
		tableView.reloadData()
	}

	final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			let sampleType = self.parts[indexPath.row].sampleTypeInfo
			self.parts.remove(at: indexPath.row)
			if sampleType != nil && indexPath.row < self.parts.count {
				self.updateAttributesForSampleType(at: self.bottomMostSampleTypeIndex(above: indexPath.row))
			}
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.row == 0 {
			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseSampleType") as! ChooseSampleTypeViewController
			editedIndex = 0
			controller.selectedSampleType = parts[0].sampleTypeInfo!.sampleType
			controller.notificationToSendOnAccept = Me.acceptedSampleTypeEdit
			tableView.deselectRow(at: indexPath, animated: true)
			customPresentViewController(Me.editSampleTypePresenter, viewController: controller, animated: true)
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
			controller.sampleType = bottomMostSampleTypeAbove(index: editedIndex)
			controller.attributeRestriction = parts[editedIndex].attributeRestriction!
			controller.notificationToSendWhenAccepted = Me.acceptedAttributeRestrictionEdit
		} else if segue.destination is EditSubSampleTypeViewController {
			let controller = (segue.destination as! EditSubSampleTypeViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.sampleType = parts[editedIndex].sampleTypeInfo!.sampleType
			controller.matcher = parts[editedIndex].sampleTypeInfo!.matcher
			controller.notificationToSendWhenAccepted = Me.acceptedSubSampleTypeEdit
		}
	}

	// MARK: - Received Notifications

	@objc final func saveEditedSampleType(notification: Notification) {
		let sampleType = notification.object as! Sample.Type
		parts[editedIndex] = Part(SampleTypeInfo(sampleType))

		updateAttributesForSampleType(at: editedIndex)
		tableView.reloadData()
	}

	@objc final func saveEditedAttributeRestriction(notification: Notification) {
		parts[editedIndex] = Part(notification.object as! AttributeRestriction)
		tableView.reloadData()
	}

	@objc final func saveEditedSubQuerySampleType(notification: Notification) {
		parts[editedIndex] = Part(notification.object as! SampleTypeInfo)
		updateAttributesForSampleType(at: editedIndex)
		tableView.reloadData()
	}

	@objc final func addQueryPart(notification: Notification) {
		let type = notification.object as! PartType
		switch (type) {
			case .sampleType:
				parts.append(Part(SampleTypeInfo()))
				break
			case .attributeRestriction:
				let lastSampleType = bottomMostSampleType()
				let attributeRestriction = defaultAttributeRestriction(for: lastSampleType)
				parts.append(Part(attributeRestriction))
				break
		}

		partWasAdded()
	}

	// Mark: - Helper Functions

	private final func updateAttributesForSampleType(at sampleTypeIndex: Int) {
		for i in sampleTypeIndex+1 ..< parts.count {
			if let _ = parts[i].sampleTypeInfo { break }
			if let attributeRestriction = parts[i].attributeRestriction {
				let attribute = attributeRestriction.restrictedAttribute
				let sampleType = parts[sampleTypeIndex].sampleTypeInfo!.sampleType
				if let attributeIndex = sampleType.attributes.firstIndex(where: { $0.equalTo(attribute) }) {
					parts[i].attributeRestriction!.restrictedAttribute = sampleType.attributes[attributeIndex]
				} else {
					parts[i].attributeRestriction = defaultAttributeRestriction(for: sampleType)
				}
			}
		}
	}

	private final func bottomMostSampleType() -> Sample.Type {
		return bottomMostSampleType(in: parts)
	}

	private final func bottomMostSampleType(in parts: [Part]) -> Sample.Type {
		var index = parts.count - 1
		while index >= 0 && parts[index].sampleTypeInfo == nil {
			index -= 1
		}
		return parts[index].sampleTypeInfo!.sampleType
	}

	private final func bottomMostSampleTypeAbove(index aboveIndex: Int) -> Sample.Type {
		var index = aboveIndex
		while index >= 0 && parts[index].sampleTypeInfo == nil {
			index -= 1
		}
		return parts[index].sampleTypeInfo!.sampleType
	}

	private final func bottomMostSampleTypeIndex(above aboveIndex: Int) -> Int {
		var index = aboveIndex
		while index >= 0 && parts[index].sampleTypeInfo == nil {
			index -= 1
		}
		return index
	}

	private final func partWasAdded() {
		let indexPath = IndexPath(row: parts.count - 1, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}

	private final func defaultAttributeRestriction(for sampleType: Sample.Type) -> AttributeRestriction {
		let attribute = sampleType.defaultDependentAttribute
		let restrictionType = DependencyInjector.restriction.typesFor(attribute)[0]
		return DependencyInjector.restriction.initialize(type: restrictionType, forAttribute: attribute)
	}

	private final func buildQuery() -> Query {
		let partsSplitByQuery = splitPartsByQuery()
		var currentTopmostQuery: Query? = nil
		for parts in partsSplitByQuery {
			var currentQuery: Query

			let sampleTypeInfo = parts[0].sampleTypeInfo!
			switch (sampleTypeInfo.sampleType) {
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
				currentTopmostQuery?.subQuery = (matcher: sampleTypeInfo.matcher!, query: currentQuery)
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
			} else if part.sampleTypeInfo == nil {
				os_log("Forgot a type of query part: %@", type: .error, String(describing: part))
			}
		}
	}

	private final func splitPartsByQuery() -> [[Part]] {
		var partsSplitByQuery = [[Part]]()
		var currentParts = [Part]()
		for part in parts {
			if part.sampleTypeInfo != nil && !currentParts.isEmpty {
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
}
