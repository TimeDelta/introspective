//
//  MoodNoteTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public final class MoodNoteTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var noteView: UITextView!

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var note: String? {
		didSet {
			noteView.text = note ?? ""
			noteView.delegate = self
		}
	}
}

// MARK: - UITextViewDelegate

extension MoodNoteTableViewCell: UITextViewDelegate {
	public final func textViewDidChange(_ textView: UITextView) {
		// Editing events and Save run on main. Publish this event's value before
		// another control can save or a table reload can replace the note view.
		NotificationCenter.default.post(
			name: notificationToSendOnChange,
			object: self,
			userInfo: [UserInfoKey.text: textView.text ?? ""]
		)
	}
}
