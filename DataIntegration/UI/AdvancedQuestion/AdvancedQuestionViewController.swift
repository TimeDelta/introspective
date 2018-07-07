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

	static let addDataTypeAccepted = Notification.Name("addDataTypeAccepted")
	static let editDataTypeAccepted = Notification.Name("editDataTypeAccepted")

	enum CellType: CustomStringConvertible {
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
		var dataType: DataTypes
	}

	fileprivate var parts: [Any]!
	fileprivate var cellTypes: [CellType]!

	override func viewDidLoad() {
		super.viewDidLoad()
		cellTypes = [CellType]()
		parts = [Any]()
		NotificationCenter.default.addObserver(forName: Me.addDataTypeAccepted, object: nil, queue: OperationQueue.main, using: addDataTypeAccepted)
		NotificationCenter.default.addObserver(forName: Me.editDataTypeAccepted, object: nil, queue: OperationQueue.main, using: editDataTypeAccepted)
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
			let controller = (segue.destination as! SourceDefinitionViewController)
		}
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

	@IBAction func runButtonPressed(_ sender: Any) {
	}

	fileprivate func addDataTypeAccepted(_ notification: Notification) {
	}

	fileprivate func editDataTypeAccepted(_ notification: Notification) {
	}
}
