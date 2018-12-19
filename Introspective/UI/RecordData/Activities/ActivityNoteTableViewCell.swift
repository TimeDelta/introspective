//
//  ActivityNoteTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class ActivityNoteTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var noteView: UITextView! {
		didSet { updateUI() }
	}

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var note: String? {
		didSet {
			noteSet = true
			updateUI()
		}
	}
	public final var autoFocus: Bool! {
		didSet { updateUI() }
	}

	private final var noteSet = false

	// MARK: - Helper Functions

	private final func updateUI() {
		guard let noteView = noteView else { return }
		guard let autoFocus = autoFocus else { return }
		guard noteSet else { return }
		noteView.text = note ?? ""
		noteView.delegate = self
		if autoFocus {
			noteView.becomeFirstResponder()
		}
	}
}

// MARK: - UITextViewDelegate

extension ActivityNoteTableViewCell: UITextViewDelegate {

	public final func textViewDidChange(_ textView: UITextView) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnChange, object: textView.text)
		}
	}
}
