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
	}

	fileprivate var parts: [Any]!
	fileprivate var cellTypes: [CellType]!

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
		if segue.destination is EditDataTypeViewController || segue.destination is AddToAdvancedQuestionViewController {
            segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
            segue.destination.popoverPresentationController!.delegate = self
		}

		if segue.destination is EditDataTypeViewController {
			let controller = (segue.destination as! EditDataTypeViewController)
			let source = (sender as! UITableViewCell)
			controller.selectedIndex = EditDataTypeViewController.indexFor(type: source.textLabel!.text!)
		}
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

	@IBAction func runButtonPressed(_ sender: Any) {
	}

	@IBAction func saveEditedDataType(_ segue: UIStoryboardSegue) {
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
