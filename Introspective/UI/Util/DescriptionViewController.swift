//
//  DescriptionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class DescriptionViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var descriptionTextView: UITextView!

	// MARK: - Member Variables

	public final var descriptionText: String!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		descriptionTextView.text = descriptionText
	}
}
