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
	public static let addInformation = Notification.Name("addInformation")
	public static let edit = Notification.Name("edit")
	public static let deleteAllSamples = Notification.Name("deleteAllSamples")

	public final var currentlyEditing: Bool!
	public final var sampleType: String!

	@IBOutlet weak final var editButton: UIButton!
	@IBOutlet weak final var deleteAllButton: UIButton!

	public final override func viewDidLoad() {
		if currentlyEditing != nil && currentlyEditing {
			editButton.setTitle("Done Editing", for: .normal)
		}
		deleteAllButton.setTitle("Delete All " + sampleType! + " Entries", for: .normal)
	}

	@IBAction final func graph(sender: Any?) {
		NotificationCenter.default.post(name: Me.graphSamples, object: nil)
		dismiss(animated: true, completion: nil)
	}

	@IBAction final func addInformation(sender: Any?) {
		NotificationCenter.default.post(name: Me.addInformation, object: nil)
		dismiss(animated: true, completion: nil)
	}

	@IBAction final func edit(sender: Any?) {
		NotificationCenter.default.post(name: Me.edit, object: nil)
		dismiss(animated: true, completion: nil)
	}

	@IBAction final func deleteAll(sender: Any?) {
		NotificationCenter.default.post(name: Me.deleteAllSamples, object: nil)
		dismiss(animated: true, completion: nil)
	}
}
