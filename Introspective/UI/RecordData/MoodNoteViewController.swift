//
//  MoodNoteViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class MoodNoteViewController: UIViewController {

	private typealias Me = MoodNoteViewController

	public static let noteSavedNotification = Notification.Name("moodNoteSaved")

	public final var note: String!

	@IBOutlet weak final var textView: UITextView!

	final override func viewDidLoad() {
		super.viewDidLoad()
		if note != nil {
			textView.text = note
		}

		UiUtil.addDoneButtonToKeyboardFor(textView, target: self, action: #selector(doneClicked))
	}

	@objc private final func doneClicked() {
		NotificationCenter.default.post(name: Me.noteSavedNotification, object: textView.text, userInfo: nil)
		self.dismiss(animated: true, completion: nil)
	}
}
