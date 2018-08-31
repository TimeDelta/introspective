//
//  ResultsActionsPopupViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ResultsActionsPopupViewController: UIViewController {

	public final var currentlyEditing: Bool!

	@IBOutlet weak final var graphButton: UIButton!
	@IBOutlet weak final var addInformationButton: UIButton!
	@IBOutlet weak final var editButton: UIButton!

	public final override func viewDidLoad() {
		if currentlyEditing != nil && currentlyEditing {
			editButton.setTitle("Done Editing", for: .normal)
		}
	}

	@IBAction final func dismissVIew(sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
}
