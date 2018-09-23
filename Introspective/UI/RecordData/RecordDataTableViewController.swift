//
//  RecordDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class RecordDataTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	// MARK: - Static Member Variables

	private typealias Me = RecordDataTableViewController
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var toolbar: UIToolbar!

	// MARK: - Instance Member Variables

	private final var viewParams: [(id: String, height: CGFloat)] = [
		(id: "mood", height: 100.0),
	]

	// MARK: - UIViewCOntroller Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		toolbar.setItems([self.editButtonItem], animated: false)
	}

	// MARK: - Table view data source

	final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewParams.count
	}

	// MARK: - Table view delegate

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: viewParams[indexPath.row].id, for: indexPath)
		if cell is RecordMoodTableViewCell {
			(cell as! RecordMoodTableViewCell).addNoteButton.addTarget(self, action: #selector(presentMoodNoteController), for: .touchUpInside)
		}
		return cell
	}

	final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		viewParams.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return viewParams[indexPath.row].height
	}

	// MARK: - Helper Functions

	@objc private final func presentMoodNoteController(_ sender: UIButton) {
		let controller = UIStoryboard(name: "RecordData", bundle: nil).instantiateViewController(withIdentifier: "moodNote") as! MoodNoteViewController
		controller.note = ""
		customPresentViewController(Me.presenter, viewController: controller, animated: true)
	}
}
