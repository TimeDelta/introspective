//
//  RecordDataTableViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class RecordDataTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	@IBOutlet weak var toolbar: UIToolbar!

	fileprivate var viewParams: [(id: String, height: CGFloat)] = [
		(id: "mood", height: 100.0),
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		toolbar.setItems([self.editButtonItem], animated: false)
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewParams.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: viewParams[indexPath.row].id, for: indexPath)
		if cell is RecordMoodTableViewCell {
			(cell as! RecordMoodTableViewCell).addNoteButton.addTarget(self, action: #selector(presentMoodNoteController), for: .touchUpInside)
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		viewParams.swapAt(fromIndexPath.row, to.row)
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return viewParams[indexPath.row].height
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	// MARK: - Helper Functions

	@objc fileprivate func presentMoodNoteController(_ sender: UIButton) {
		let controller = UIStoryboard(name: "RecordData", bundle: nil).instantiateViewController(withIdentifier: "moodNote") as! MoodNoteViewController
		controller.note = ""
		controller.modalPresentationStyle = UIModalPresentationStyle.popover
		controller.popoverPresentationController!.delegate = self
		controller.popoverPresentationController!.sourceRect = sender.bounds
		controller.popoverPresentationController!.sourceView = sender
		present(controller, animated: true, completion: nil)
	}
}
