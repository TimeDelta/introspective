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
		} else if segue.destination is EditAttributeRestrictionViewController {
			let controller = (segue.destination as! EditAttributeRestrictionViewController)
			let source = (sender as! UITableViewCell)
			editedIndex = tableView.indexPath(for: source)!.row
			controller.attributeRestriction = (parts[editedIndex] as! AttributeRestriction)
			controller.dataType = closestDataType(aboveIndex: editedIndex)
		} else if segue.destination is ResultsViewController<HeartRate> {
//			let controller = (segue.destination as! ResultsViewController<HeartRate>)
//			controller.dataType = .heartRate
//			let query = HeartRateQuery()
//			query.runQuery { (result: QueryResult<HeartRateQuery.SampleType>?, error: Error?) in
//				if error != nil {
//					controller.error = error
//					return
//				}
//				controller.samples = result?.samples
//				controller.extraInformation = result?.extraInformation
//			}
		}
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

	@IBAction func runButtonPressed(_ sender: Any) {
		let dataType = (parts[0] as! DataTypeInfo).dataType
		switch (dataType) {
			case .heartRate:
				let controller: ResultsViewController<HeartRate> = buildAndRunQuery()
				present(controller, animated: true, completion: nil)
		}
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
					let timeConstraint = TimeConstraint()
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

	fileprivate func buildQuery<SampleType: Sample>() -> SampleQuery<SampleType> {
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
		return currentTopmostQuery! as! SampleQuery<SampleType>
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
		return partsSplitByQuery
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

	fileprivate func buildAndRunQuery<SampleType: Sample>() -> ResultsViewController<SampleType> {
		// TODO - build the query
		let query: SampleQuery<SampleType> = buildQuery()
		let controller = ResultsViewController<SampleType>()

		query.runQuery { (result: SampleQueryResult<SampleType>?, error: Error?) in
			if error != nil {
				controller.error = error
				return
			}
			controller.samples = result?.typedSamples
			controller.extraInformation = result?.sampleInformation
		}
		return controller
	}
}
