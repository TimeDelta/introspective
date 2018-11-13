//
//  ActivityDefinitionDescriptionTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class ActivityDefinitionDescriptionTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var descriptionView: UITextView!

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var activityDescription: String? {
		didSet {
			descriptionView.text = activityDescription ?? ""
			descriptionView.delegate = self
		}
	}

	// MARK: - Helper Functions

	private final func sendNameChangeNotification() {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnChange, object: self.descriptionView.text)
		}
	}
}

// MARK: - UITextViewDelegate

extension ActivityDefinitionDescriptionTableViewCell: UITextViewDelegate {

	public final func textViewDidChange(_ textView: UITextView) {
		sendNameChangeNotification()
	}

	public final func textViewDidBeginEditing(_ textView: UITextView) {
		sendNameChangeNotification()
	}

	public final func textViewDidEndEditing(_ textView: UITextView) {
		sendNameChangeNotification()
	}
}
