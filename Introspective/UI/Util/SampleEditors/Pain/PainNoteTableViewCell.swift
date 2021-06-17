//
//  PainNoteTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

public final class PainNoteTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var noteView: UITextView!

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var note: String? {
		didSet {
			noteView.text = note ?? ""
			noteView.delegate = self
			noteView.becomeFirstResponder()
		}
	}
}

// MARK: - UITextViewDelegate

extension PainNoteTableViewCell: UITextViewDelegate {
	public final func textViewDidChange(_ textView: UITextView) {
		post(
			notificationToSendOnChange,
			userInfo: [
				.text: textView.text as Any,
			]
		)
	}
}
