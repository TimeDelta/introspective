//
//  ResultsActionsPopupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ResultsActionsPopupViewController: UIViewController {

	private typealias Me = ResultsActionsPopupViewController
	public static let graphSamples = Notification.Name("graphSamples")
	public static let sort = Notification.Name("sort")
	public static let addInformation = Notification.Name("addInformation")
	public static let edit = Notification.Name("edit")
	public static let deleteAllSamples = Notification.Name("deleteAllSamples")

	public final var currentlyEditing: Bool!
	public final var sampleType: String!
	public final var sortable: Bool!
	public final var deletable: Bool!

	private final var buttons = [UIButton]()

	public final override func viewDidLoad() {
		setButtons()
		addButtons()
	}

	@objc private final func graph(sender: Any?) {
		NotificationCenter.default.post(name: Me.graphSamples, object: nil)
		dismiss(animated: true, completion: nil)
	}

	@objc private final func sort(sender: Any?) {
		NotificationCenter.default.post(name: Me.sort, object: nil)
	}

	@objc private final func addInformation(sender: Any?) {
		NotificationCenter.default.post(name: Me.addInformation, object: nil)
		dismiss(animated: true, completion: nil)
	}

	@objc private final func edit(sender: Any?) {
		NotificationCenter.default.post(name: Me.edit, object: nil)
		dismiss(animated: true, completion: nil)
	}

	@objc private final func deleteAll(sender: Any?) {
		NotificationCenter.default.post(name: Me.deleteAllSamples, object: nil)
		dismiss(animated: true, completion: nil)
	}

	private final func addButtons() {
		for button in buttons {
			view.addSubview(button)
		}
	}

	private final func setButtons() {
		buttons.append(getGraphButton(yValue: 0))
		if sortable {
			buttons.append(getSortButton(yValue: calculateYValue()))
		}
		buttons.append(getAddInformationButton(yValue: calculateYValue()))
		buttons.append(getEditButton(yValue: calculateYValue()))
		if deletable {
			buttons.append(getDeleteAllButton(yValue: calculateYValue()))
		}
	}

	private final func getGraphButton(yValue: CGFloat) -> UIButton {
		let graphButton = UIButton(type: .system)
		graphButton.frame = CGRect(x: 0, y: yValue, width: 300, height: 30)
		graphButton.setTitle("Graph", for: .normal)
		graphButton.addTarget(self, action: #selector(graph), for: .touchUpInside)
		return graphButton
	}

	private final func getSortButton(yValue: CGFloat) -> UIButton {
		let sortButton = UIButton(type: .system)
		sortButton.frame = CGRect(x: 0, y: yValue, width: 300, height: 30)
		sortButton.setTitle("Sort", for: .normal)
		sortButton.addTarget(self, action: #selector(sort), for: .touchUpInside)
		return sortButton
	}

	private final func getAddInformationButton(yValue: CGFloat) -> UIButton {
		let addInformationButton = UIButton(type: .system)
		addInformationButton.frame = CGRect(x: 0, y: yValue, width: 300, height: 30)
		addInformationButton.setTitle("Add Information", for: .normal)
		addInformationButton.addTarget(self, action: #selector(addInformation), for: .touchUpInside)
		return addInformationButton
	}

	private final func getEditButton(yValue: CGFloat) -> UIButton {
		let editButton = UIButton(type: .system)
		editButton.frame = CGRect(x: 0, y: yValue, width: 300, height: 30)
		if currentlyEditing != nil && currentlyEditing {
			editButton.setTitle("Done Editing", for: .normal)
		} else {
			editButton.setTitle("Edit", for: .normal)
		}
		editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
		return editButton
	}

	private final func getDeleteAllButton(yValue: CGFloat) -> UIButton {
		let deleteAllButton = UIButton(type: .system)
		deleteAllButton.frame = CGRect(x: 0, y: yValue, width: 300, height: 30)
		deleteAllButton.setTitle("Delete All " + sampleType! + " Entries", for: .normal)
		deleteAllButton.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
		return deleteAllButton
	}

	private final func calculateYValue() -> CGFloat {
		return buttons[buttons.count - 1].frame.maxY + 8
	}
}
