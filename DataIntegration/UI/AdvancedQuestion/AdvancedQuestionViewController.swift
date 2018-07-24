//
//  AdvancedQueryViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AdvancedQuestionViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	fileprivate typealias Me = AdvancedQuestionViewController

	public enum CellType: CustomStringConvertible {
		case dataType
		case timeConstraint
		case attributeRestriction
		case subDataType

		public static let allTypes: [CellType] = [dataType, timeConstraint, attributeRestriction]

		var description: String {
			switch (self) {
				case .dataType: return "Data Type"
				case .timeConstraint: return "Time Constraint"
				case .attributeRestriction: return "Attribute Restriction"
				case .subDataType: return "Sub Data Type"
			}
		}
	}

	fileprivate struct DataTypeInfo {
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

	fileprivate var parts: [Any]!
	fileprivate var cellTypes: [CellType]!
	fileprivate var editedIndex: Int!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = self.editButtonItem

		cellTypes = [CellType]()
		parts = [Any]()

		cellTypes.append(.dataType)
		parts.append(DataTypeInfo())

		partWasAdded()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return parts.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
				break
			case .timeConstraint:
				(cell as! TimeConstraintTableViewCell).timeConstraint = (part as! TimeConstraint)
				break
			case .attributeRestriction:
				(cell as! AttributeRestrictionTableViewCell).attributeRestriction = (part as! AttributeRestriction)
				break
		}

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }

	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != 0
	}

	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		parts.swapAt(fromIndexPath.row, to.row)
		cellTypes.swapAt(fromIndexPath.row, to.row)
    }

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			self.parts.remove(at: indexPath.row)
			self.cellTypes.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is AddToAdvancedQuestionViewController {
            segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
            segue.destination.popoverPresentationController!.delegate = self
		} else if segue.destination is EditDataTypeViewController {
			let controller = (segue.destination as! EditDataTypeViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.selectedIndex = EditDataTypeViewController.indexFor(type: source.textLabel!.text!)
		} else if segue.destination is EditTimeConstraintViewController {
			let controller = (segue.destination as! EditTimeConstraintViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.timeConstraint = (parts[editedIndex] as! TimeConstraint)
		} else if segue.destination is EditAttributeRestrictionViewController {
			let controller = (segue.destination as! EditAttributeRestrictionViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.attributeRestriction = (parts[editedIndex] as! AttributeRestriction)
			controller.dataType = closestDataType(aboveIndex: editedIndex)
		} else if segue.destination is EditSubDataTypeViewController {
			let controller = (segue.destination as! EditSubDataTypeViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.dataType = (parts[editedIndex] as! DataTypeInfo).dataType
			controller.matcher = (parts[editedIndex] as! DataTypeInfo).matcher
		} else if segue.destination is ResultsViewController {
			let controller = (segue.destination as! ResultsViewController)
			controller.dataType = (parts[0] as! DataTypeInfo).dataType
			buildAndRunQuery(controller)
		}
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

	@IBAction func saveEditedDataType(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! EditDataTypeViewController)
		let index = controller.dataTypeSelector.selectedRow(inComponent: 0)
		parts[editedIndex] = DataTypeInfo(DataTypes.allTypes[index])
		tableView.reloadData()
	}

	@IBAction func saveEditedTimeConstraint(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! EditTimeConstraintViewController)
		parts[editedIndex] = controller.timeConstraint
		tableView.reloadData()
	}

	@IBAction func saveEditedAttributeRestriction(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! EditAttributeRestrictionViewController)
		parts[editedIndex] = controller.attributeRestriction
		tableView.reloadData()
	}

	@IBAction func saveEditedSubQueryDataType(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! EditSubDataTypeViewController)
		parts[editedIndex] = DataTypeInfo(controller.dataType, controller.matcher)
		tableView.reloadData()
	}

	@IBAction func addQuestionPart(_ segue: UIStoryboardSegue) {
		if segue.identifier == "addQuestionPart" {
			let controller = (segue.source as! AddToAdvancedQuestionViewController)
			let cellType = controller.cellType!
			cellTypes.append(cellType)
			switch (cellType) {
				case .dataType, .subDataType:
					parts.append(DataTypeInfo())
					break
				case .timeConstraint:
					let timeConstraint = TimeConstraint()
					timeConstraint.specificDate = Date()
					parts.append(timeConstraint)
					break
				case .attributeRestriction:
					let lastDataType = bottomMostDataType()
					let attributeRestriction = AttributeRestriction(lastDataType.defaultDependentAttribute)
					parts.append(attributeRestriction)
					break
			}

			partWasAdded()
		}
	}

	@IBAction func cancel(_ segue: UIStoryboardSegue) {} // do nothing

	fileprivate func bottomMostDataType() -> DataTypes {
		return bottomMostDataType(in: parts)
	}

	fileprivate func bottomMostDataType(in parts: [Any]) -> DataTypes {
		var index = cellTypes.count - 1
		while index >= 0 && cellTypes[index] != .dataType {
			index -= 1
		}
		return (parts[index] as! DataTypeInfo).dataType
	}

	fileprivate func closestDataType(aboveIndex: Int) -> DataTypes {
		var index = aboveIndex
		while index >= 0 && cellTypes[index] != .dataType {
			index -= 1
		}
		return (parts[index] as! DataTypeInfo).dataType
	}

	fileprivate func partWasAdded() {
		let indexPath = IndexPath(row: cellTypes.count - 1, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}

	fileprivate func buildAndRunQuery(_ controller: ResultsViewController) {
		let query = buildQuery()

		query.runQuery { (result: QueryResult?, error: Error?) in
			if error != nil {
				controller.error = error
				return
			}
			controller.samples = result?.samples
			controller.extraInformation = result?.extraInformation
		}
	}

	fileprivate func buildQuery() -> Query {
		let partsSplitByQuery = splitPartsByQuery()
		var currentTopmostQuery: Query? = nil
		for parts in partsSplitByQuery.reversed() {
			var currentQuery: Query

			let dataType = (parts[0] as! DataTypeInfo).dataType
			switch (dataType) {
				case .heartRate:
					currentQuery = (buildQuery(from: parts) as SampleQuery<HeartRate>)
					break
			}

			if currentTopmostQuery != nil {
				currentTopmostQuery?.subQuery = (matcher: SameDatesSubQueryMatcher(), query: currentQuery)
			} else {
				currentTopmostQuery = currentQuery
			}
		}
		return currentTopmostQuery!
	}

	fileprivate func buildQuery<SampleType: Sample>(from parts: [Any]) -> SampleQuery<SampleType> {
		let query = try! DependencyInjector.query.queryFor(sampleType: SampleType.self)
		for part in parts {
			if part is DataTypeInfo {
				return query
			} else if part is TimeConstraint {
				query.timeConstraints.insert((part as! TimeConstraint))
			} else if part is AttributeRestriction {
				query.attributeRestrictions.append((part as! AttributeRestriction))
			} else {
				fatalError("query part is of unknown type")
			}
		}
		return query
	}

	fileprivate func splitPartsByQuery() -> [[Any]] {
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

	// TODO - use this function to determine if data type cell should include "where" after data type name
	fileprivate func distanceToNextDataType(index: Int) -> Int {
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
