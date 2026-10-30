//
//  FatigueNoteTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/8/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public final class FatigueNoteTableViewCell: UITableViewCell {
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

extension FatigueNoteTableViewCell: UITextViewDelegate {
	public final func textViewDidChange(_ textView: UITextView) {
		NotificationCenter.default.post(
			name: notificationToSendOnChange,
			object: self,
			userInfo: [UserInfoKey.text: textView.text ?? ""]
		)
	}
}
