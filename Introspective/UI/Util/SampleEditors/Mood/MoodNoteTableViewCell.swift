//
//  MoodNoteTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

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
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnChange,
				object: self,
				userInfo: self.info([
					.text: textView.text,
				])
			)
		}
	}
}
