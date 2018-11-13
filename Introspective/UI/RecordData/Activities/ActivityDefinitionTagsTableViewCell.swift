//
//  ActivityDefinitionTagsTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import WSTagsField
import CoreData
import os

public final class ActivityDefinitionTagsTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	/// This field automatically prevents duplication of tags
	@IBOutlet weak final var tagsField: WSTagsField! {
		didSet {
			guard let tagsField = tagsField else { return }
			tagsField.spaceBetweenLines = 20
			tagsField.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
			tagsField.returnKeyType = .next
			tagsField.onDidAddTag = addedTag
			tagsField.onDidRemoveTag = removedTag
			tagsField.textField.accessibilityLabel = "activity tags"

			do {
				let tags = try DependencyInjector.db.query(Tag.fetchRequest() as NSFetchRequest<Tag>)
				tagsField.textField.filterStrings(tags.map{ $0.name })
			} catch {
				os_log("Auto complete failure: %@", type: .error, error.localizedDescription)
			}
		}
	}

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var tagNames = Set<String>() {
		didSet {
			// this gets executed every time something is inserted into the set
			guard !initialTagsSet else { return }
			tagsField.addTags(tagNames.map{ $0 })
			setAccessibilityValue()
			initialTagsSet = true
		}
	}
	private final var initialTagsSet = false

	// MARK: - Helper Functions

	private final func addedTag(_ field: WSTagsField, _ tag: WSTag) {
		guard initialTagsSet else { return } // avoid sending pointless updates
		tagNames.insert(tag.text)
		setAccessibilityValue()
		sendTagsChangedNotification()
	}

	private final func removedTag(_ field: WSTagsField, _ tag: WSTag) {
		tagNames.remove(tag.text)
		setAccessibilityValue()
		sendTagsChangedNotification()
	}

	private final func setAccessibilityValue() {
		tagsField.accessibilityValue = tagNames.map{ $0 }.joined(separator: ";")
		tagsField.textField.accessibilityValue = tagNames.map{ $0 }.joined(separator: ";")
	}

	private final func sendTagsChangedNotification() {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnChange, object: self.tagNames)
		}
	}
}
