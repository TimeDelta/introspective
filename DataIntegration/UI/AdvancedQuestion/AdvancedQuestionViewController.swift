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

		public static let allTypes: [CellType] = [dataType, timeConstraint, attributeRestriction]

		var description: String {
			switch(self) {
				case .dataType: return "Data Type"
				case .timeConstraint: return "Time Constraint"
				case .attributeRestriction: return "Attribute Restriction"
			}
		}
	}

	fileprivate struct DataTypeInfo {
		var dataType: DataTypes = .heartRate
		init() {}
		init(_ dataType: DataTypes) {
			self.dataType = dataType
		}
	}

	fileprivate var parts: [Any]!
	fileprivate var cellTypes: [CellType]!
	fileprivate var editedIndex: Int!

	override func viewDidLoad() {
		super.viewDidLoad()
		cellTypes = [CellType]()
		parts = [Any]()

		cellTypes.append(.dataType)
		parts.append(DataTypeInfo())

		partWasAdded()
		// TODO - disallow deletion of topmost data type (will always be at index 0)
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return parts.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let index = indexPath.row
		let cellType = cellTypes[index]
		let identifier = cellType.description
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

		let part = parts[index]
        switch(cellType) {
			case .dataType:
				cell.textLabel?.text = (part as! DataTypeInfo).dataType.description
				break
			case .timeConstraint:
				(cell as! TimeConstraintTableViewCell).timeConstraint = (parts[index] as! TimeConstraint)
				break
			case .attributeRestriction:
				(cell as! AttributeRestrictionTableViewCell).attributeRestriction = (parts[index] as! AttributeRestriction)
				break
		}

        return cell
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
		}
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

	@IBAction func runButtonPressed(_ sender: Any) {
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

	@IBAction func addQuestionPart(_ segue: UIStoryboardSegue) {
		if segue.identifier == "addQuestionPart" {
			let controller = (segue.source as! AddToAdvancedQuestionViewController)
			let cellType = controller.cellType!
			cellTypes.append(cellType)
			switch (cellType) {
				case .dataType:
					parts.append(DataTypeInfo())
					break
				case .timeConstraint:
					var timeConstraint = TimeConstraint()
					timeConstraint.specificDate = Date()
					parts.append(timeConstraint)
					break
				case .attributeRestriction:
					let lastDataType = bottomMostDataType()
					let attributeRestriction = AttributeRestriction(lastDataType.defaultAttribute)
					parts.append(attributeRestriction)
					break
			}

			partWasAdded()
		}
	}

	@IBAction func cancel(_ segue: UIStoryboardSegue) {} // do nothing

	fileprivate func bottomMostDataType() -> DataTypes {
		var index = cellTypes.count - 1
		while index >= 0 && cellTypes[index] != .dataType {
			index -= 1
		}
		return (parts[index] as! DataTypeInfo).dataType
	}

	fileprivate func partWasAdded() {
		let indexPath = IndexPath(row: cellTypes.count - 1, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}
}
