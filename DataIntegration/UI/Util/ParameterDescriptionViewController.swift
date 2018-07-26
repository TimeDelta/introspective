//
//  ParameterDescriptionViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class ParameterDescriptionViewController: UIViewController {

	public var descriptionText: String!

	@IBOutlet weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
		descriptionTextView.text = descriptionText
    }
}
