//
//  MoodNoteViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

final class MoodNoteViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = MoodNoteViewController
	public static let noteSavedNotification = Notification.Name("moodNoteSaved")

	// MARK: - IBOutlets

	@IBOutlet final var textView: UITextView!

	// MARK: - Instance Variables

	public final var note: String!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if note != nil {
			textView.text = note
		}

		injected(UiUtil.self)
			.addSaveButtonToKeyboardFor(textView, target: self, action: #selector(saveClicked))
		textView.becomeFirstResponder()
	}

	// MARK: - Actions

	@objc private final func saveClicked() {
		NotificationCenter.default.post(
			name: Me.noteSavedNotification,
			object: self,
			userInfo: info([
				.text: textView.text,
			])
		)
		dismiss(animated: false, completion: nil)
	}
}
