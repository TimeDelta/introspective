//
//  ActivityDefinitionDescriptionTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIExtensions
import UIKit

public final class ActivityDefinitionDescriptionTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var descriptionView: UITextView!

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var activityDescription: String? {
		didSet {
			descriptionView.text = activityDescription ?? ""
			descriptionView.delegate = self
		}
	}

	// MARK: - Helper Functions

	private final func sendDescriptionChangeNotification() {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnChange,
				object: self,
				userInfo: self.info([
					.text: self.descriptionView.text,
				])
			)
		}
	}
}

// MARK: - UITextViewDelegate

extension ActivityDefinitionDescriptionTableViewCell: UITextViewDelegate {
	public final func textViewDidChange(_: UITextView) {
		sendDescriptionChangeNotification()
	}

	public final func textViewDidBeginEditing(_: UITextView) {
		sendDescriptionChangeNotification()
	}

	public final func textViewDidEndEditing(_: UITextView) {
		sendDescriptionChangeNotification()
	}
}
