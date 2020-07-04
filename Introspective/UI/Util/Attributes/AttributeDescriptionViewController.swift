//
//  AttributeDescriptionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class AttributeDescriptionViewController: UIViewController {
	public final var descriptionText: String!

	@IBOutlet final var descriptionTextView: UITextView!

	override final func viewDidLoad() {
		super.viewDidLoad()
		descriptionTextView.text = descriptionText
	}
}
