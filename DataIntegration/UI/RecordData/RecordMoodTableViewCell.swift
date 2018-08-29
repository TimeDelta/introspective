//
//  RecordMoodTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class RecordMoodTableViewCell: UITableViewCell {

	@IBOutlet var ratingSlider: UISlider!
	@IBOutlet var outOfMaxRatingLabel: UILabel!
	@IBOutlet var doneButon: UIButton!
	@IBOutlet var addNoteButton: UIButton!

	var note: String? = nil

	public override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		NotificationCenter.default.addObserver(self, selector: #selector(noteSaved), name: MoodNoteViewController.noteSavedNotification, object: nil)
	}

	@IBAction func ratingChanged(_ sender: Any) {
		let newValue = Double(ratingSlider.value) * MoodImpl.maxRating

		ratingSlider.thumbTintColor = MoodUiUtil.colorForMood(rating: newValue)

		outOfMaxRatingLabel.text = MoodUiUtil.valueToString(newValue) + " / " + MoodUiUtil.valueToString(MoodImpl.maxRating)
	}

	@IBAction func doneButtonPressed(_ sender: Any) {
		let mood = DependencyInjector.dataType.mood()
		mood.timestamp = Date()
		mood.rating = Double(ratingSlider.value) * MoodImpl.maxRating
		mood.note = note
		DependencyInjector.db.save()

		reset()
	}

	@objc fileprivate func noteSaved(notification: Notification) {
		note = (notification.object as! String)
		addNoteButton.setTitle(note, for: .normal)
	}

	fileprivate func reset() {
		note = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		ratingSlider.value = (ratingSlider.maximumValue - ratingSlider.minimumValue) / 2.0
		ratingChanged(self)
	}
}
