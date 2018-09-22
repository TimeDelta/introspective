//
//  ErrorMessageViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ErrorMessageViewController: UIViewController {

	public final var errorMessage: String!

	@IBOutlet weak final var textView: UITextView!

	final override func viewDidLoad() {
		super.viewDidLoad()
		textView.text = errorMessage
	}

	@IBAction func dismiss(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}
