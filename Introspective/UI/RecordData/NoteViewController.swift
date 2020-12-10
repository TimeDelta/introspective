//
//  NoteViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

final class NoteViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var textView: UITextView!

	// MARK: - Instance Variables

	public final var note: String!
	/// Must be set before view loads
	public final var noteSavedNotification: Notification.Name!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if note != nil {
			textView.text = note
		}

		injected(UiUtil.self).addSaveButtonToKeyboardFor(
			textView,
			target: self,
			action: #selector(saveTapped)
		)
		textView.becomeFirstResponder()
	}

	// MARK: - Actions

	@objc private final func saveTapped() {
		post(
			noteSavedNotification,
			userInfo: [
				.text: textView.text as Any,
			]
		)
		dismiss(animated: false, completion: nil)
	}
}
