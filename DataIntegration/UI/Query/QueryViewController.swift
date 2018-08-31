//
//  QueryViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class QueryViewController: UITableViewController {

	private typealias Me = QueryViewController
	private static let acceptedAttributeRestrictionEdit = Notification.Name("acceptedAttributeRestrictionEdit")
	private static let acceptedSubDataTypeEdit = Notification.Name("acceptedSubDataTypeEdit")

	public enum CellType: CustomStringConvertible {
		case dataType
		case attributeRestriction
		case subDataType

		public static let allTypes: [CellType] = [dataType, attributeRestriction]

		var description: String {
			switch (self) {
				case .dataType: return "Data Type"
				case .attributeRestriction: return "Attribute Restriction"
				case .subDataType: return "Sub Data Type"
			}
		}
	}

	struct DataTypeInfo {
		var dataType: DataTypes = .heartRate
		var matcher: SubQueryMatcher? = SameDatesSubQueryMatcher()

		init() {}
		init(_ dataType: DataTypes) {
			self.dataType = dataType
		}
		init(_ dataType: DataTypes, _ matcher: SubQueryMatcher) {
			self.dataType = dataType
			self.matcher = matcher
		}
	}

	final var parts: [Any]!
	final var cellTypes: [CellType]!
	final var editedIndex: Int!

	final override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = self.editButtonItem

		cellTypes = [CellType]()
		parts = [Any]()

		cellTypes.append(.dataType)
		parts.append(DataTypeInfo())

		partWasAdded()

		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedAttributeRestriction), name: Me.acceptedAttributeRestrictionEdit, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(saveEditedSubQueryDataType), name: Me.acceptedSubDataTypeEdit, object: nil)
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return parts.count
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let index = indexPath.row
		let part = parts[index]

		if index == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Data Type", for: indexPath)
			cell.textLabel?.text = (part as! DataTypeInfo).dataType.description
			return cell
		}

		let cellType = cellTypes[index]
		let identifier = cellType.description
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

		switch (cellType) {
			case .dataType, .subDataType:
				let typedCell = (cell as! SubDataTypeTableViewCell)
				typedCell.matcher = (part as! DataTypeInfo).matcher
				typedCell.dataType = (part as! DataTypeInfo).dataType
				return typedCell
			case .attributeRestriction:
				let typedCell = (cell as! AttributeRestrictionTableViewCell)
				typedCell.attributeRestriction = (part as! AttributeRestriction)
				return typedCell
		}
	}

	final override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != 0
	}

	final override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != 0
	}

	final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		parts.swapAt(fromIndexPath.row, to.row)
		cellTypes.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			self.parts.remove(at: indexPath.row)
			self.cellTypes.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

	final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is AddToQueryViewController {
			segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
			segue.destination.popoverPresentationController!.delegate = self
		} else if segue.destination is EditDataTypeViewController {
			let controller = (segue.destination as! EditDataTypeViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.selectedIndex = EditDataTypeViewController.indexFor(type: source.textLabel!.text!)
		} else if segue.destination is EditAttributeRestrictionViewController {
			let controller = (segue.destination as! EditAttributeRestrictionViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.dataType = bottomMostDataTypeAbove(index: editedIndex)
			controller.attributeRestriction = (parts[editedIndex] as! AttributeRestriction)
			controller.notificationToSendWhenAccepted = Me.acceptedAttributeRestrictionEdit
		} else if segue.destination is EditSubDataTypeViewController {
			let controller = (segue.destination as! EditSubDataTypeViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.dataType = (parts[editedIndex] as! DataTypeInfo).dataType
			controller.matcher = (parts[editedIndex] as! DataTypeInfo).matcher
			controller.notificationToSendWhenAccepted = Me.acceptedSubDataTypeEdit
		} else if segue.destination is ResultsViewController {
			let controller = (segue.destination as! ResultsViewController)
			controller.dataType = (parts[0] as! DataTypeInfo).dataType
			buildAndRunQuery(controller)
		}
	}

	@IBAction final func saveEditedDataType(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! EditDataTypeViewController)
		let index = controller.dataTypeSelector.selectedRow(inComponent: 0)
		parts[editedIndex] = DataTypeInfo(DataTypes.allTypes[index])
		tableView.reloadData()
	}

	@objc final func saveEditedAttributeRestriction(notification: Notification) {
		parts[editedIndex] = notification.object as! AttributeRestriction
		tableView.reloadData()
	}

	@objc final func saveEditedSubQueryDataType(notification: Notification) {
		parts[editedIndex] = notification.object as! DataTypeInfo
		tableView.reloadData()
	}

	@IBAction final func addQuestionPart(_ segue: UIStoryboardSegue) {
		if segue.identifier == "addQuestionPart" {
			let controller = (segue.source as! AddToQueryViewController)
			let cellType = controller.cellType!
			cellTypes.append(cellType)
			switch (cellType) {
				case .dataType, .subDataType:
					parts.append(DataTypeInfo())
					break
				case .attributeRestriction:
					let lastDataType = bottomMostDataType()
					let attribute = lastDataType.defaultDependentAttribute
					let attributeRestriction = EqualToNumericAttributeRestriction(attribute: attribute)
					parts.append(attributeRestriction)
					break
			}

			partWasAdded()
		}
	}

	@IBAction final func cancel(_ segue: UIStoryboardSegue) {} // do nothing

	// Mark: - Helper Functions

	private final func bottomMostDataType() -> DataTypes {
		return bottomMostDataType(in: parts)
	}

	private final func bottomMostDataType(in parts: [Any]) -> DataTypes {
		var index = cellTypes.count - 1
		while index >= 0 && cellTypes[index] != .dataType {
			index -= 1
		}
		return (parts[index] as! DataTypeInfo).dataType
	}

	private final func bottomMostDataTypeAbove(index: Int) -> DataTypes {
		for part in parts[0 ... index].reversed() {
			if part is DataTypeInfo {
				return (part as! DataTypeInfo).dataType
			}
		}
		return (parts[0] as! DataTypeInfo).dataType // this will never happen but the compiler can't know that
	}

	private final func closestDataType(aboveIndex: Int) -> DataTypes {
		var index = aboveIndex
		while index >= 0 && cellTypes[index] != .dataType {
			index -= 1
		}
		return (parts[index] as! DataTypeInfo).dataType
	}

	private final func partWasAdded() {
		let indexPath = IndexPath(row: cellTypes.count - 1, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}

	private final func buildAndRunQuery(_ controller: ResultsViewController) {
		let query = buildQuery()

		query.runQuery { (result: QueryResult?, error: Error?) in
			if error != nil {
				controller.error = error
				return
			}
			controller.samples = result?.samples
			controller.extraInformation = [ExtraInformation]()
		}
	}

	private final func buildQuery() -> Query {
		let partsSplitByQuery = splitPartsByQuery()
		var currentTopmostQuery: Query? = nil
		for parts in partsSplitByQuery {
			var currentQuery: Query

			let dataTypeInfo = parts[0] as! DataTypeInfo
			switch (dataTypeInfo.dataType) {
				case .heartRate:
					currentQuery = DependencyInjector.query.heartRateQuery()
					break
				case .mood:
					currentQuery = DependencyInjector.query.moodQuery()
					break
				case .weight:
					currentQuery = DependencyInjector.query.weightQuery()
					break
				case .bmi:
					currentQuery = DependencyInjector.query.bmiQuery()
					break
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

	private final func buildQuery(_ query: inout Query, from parts: [Any]) {
		for part in parts.reversed() {
			if part is AttributeRestriction {
				query.attributeRestrictions.append((part as! AttributeRestriction))
			} else if !(part is DataTypeInfo) {
				os_log("query part is of unknown type: %@", type: .error, String(describing: type(of: part)))
			}
		}
	}

	private final func splitPartsByQuery() -> [[Any]] {
		var partsSplitByQuery = [[Any]]()
		var currentParts = [Any]()
		for part in parts {
			if part is DataTypeInfo && !currentParts.isEmpty {
				partsSplitByQuery.append(currentParts)
				currentParts = [Any]()
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
			if part is DataTypeInfo {
				return distance
			}
			distance += 1
		}
		return distance
	}
}

extension QueryViewController: UIPopoverPresentationControllerDelegate {

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}
}
