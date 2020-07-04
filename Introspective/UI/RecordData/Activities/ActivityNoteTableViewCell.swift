//
//  ActivityNoteTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIExtensions
import UIKit

public protocol ActivityNoteTableViewCell: UITableViewCell {
	var notificationToSendOnChange: Notification.Name! { get set }
	var note: String? { get set }
	var autoFocus: Bool! { get set }
}

public final class ActivityNoteTableViewCellImpl: UITableViewCell, ActivityNoteTableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var noteView: UITextView! {
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

	/// to avoid triggering it every time the containing table view is reloaded
	private final var autoFocusTriggered: Bool = false

	private final var noteSet = false

	// MARK: - Helper Functions

	private final func updateUI() {
		guard let noteView = noteView else { return }
		guard let autoFocus = autoFocus else { return }
		guard noteSet else { return }
		noteView.text = note ?? ""
		noteView.delegate = self
		if autoFocus && !autoFocusTriggered {
			autoFocusTriggered = true
			noteView.becomeFirstResponder()
		}
	}
}

// MARK: - UITextViewDelegate

extension ActivityNoteTableViewCellImpl: UITextViewDelegate {
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
