//
//  ResultsActionsPopupViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class ResultsActionsPopupViewController: UIViewController {

	public var currentlyEditing: Bool!

	@IBOutlet weak var graphButton: UIButton!
	@IBOutlet weak var addInformationButton: UIButton!
	@IBOutlet weak var editButton: UIButton!

	public override func viewDidLoad() {
		if currentlyEditing != nil && currentlyEditing {
			editButton.setTitle("Done Editing", for: .normal)
		}
	}

	@IBAction func dismissVIew(sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
}
