//
//  RecordMoodTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class RecordMoodTableViewCell: UITableViewCell {

	fileprivate typealias Me = RecordMoodTableViewCell
	fileprivate static let minRatingColor = UIColor.black
	fileprivate static let maxRatingColor = UIColor.yellow

	@IBOutlet weak var ratingSlider: UISlider!
	@IBOutlet weak var outOfMaxRatingLabel: UILabel!
	@IBOutlet weak var doneButon: UIButton!
	@IBOutlet weak var addNoteButton: UIButton!

	fileprivate var note: String? = nil

	public override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		NotificationCenter.default.addObserver(self, selector: #selector(noteSaved), name: MoodNoteViewController.noteSavedNotification, object: nil)
	}

	@IBAction func ratingChanged(_ sender: Any) {
		var maxRed: CGFloat = 0
		var maxGreen: CGFloat = 0
		var maxBlue: CGFloat = 0
		var maxAlpha: CGFloat = 0
		Me.maxRatingColor.getRed(&maxRed, green: &maxGreen, blue: &maxBlue, alpha: &maxAlpha)

		var minRed: CGFloat = 0
		var minGreen: CGFloat = 0
		var minBlue: CGFloat = 0
		var minAlpha: CGFloat = 0
		Me.minRatingColor.getRed(&minRed, green: &minGreen, blue: &minBlue, alpha: &minAlpha)

		let valueRatio = CGFloat(ratingSlider.value)

		ratingSlider.thumbTintColor = UIColor(
			red: (maxRed - minRed) * valueRatio + minRed,
			green: (maxGreen - minGreen) * valueRatio + minGreen,
			blue: (maxBlue - minBlue) * valueRatio + minBlue,
			alpha: (maxAlpha - minAlpha) * valueRatio + minAlpha)

		let newValue = Double(ratingSlider.value) * Mood.maxRating
		outOfMaxRatingLabel.text = valueToString(newValue) + " / " + valueToString(Mood.maxRating)
	}

	@IBAction func doneButtonPressed(_ sender: Any) {
		let mood = DependencyInjector.dataType.mood()
		mood.timestamp = Date()
		mood.rating = Double(ratingSlider.value) * Mood.maxRating
		mood.note = note
		DependencyInjector.db.save()

		reset()
	}

	@objc fileprivate func noteSaved(notification: Notification) {
		note = (notification.object as! String)
		addNoteButton.setTitle(note, for: .normal)
	}

	fileprivate func reset() {
		addNoteButton.setTitle("Add Note", for: .normal)
		ratingSlider.value = (ratingSlider.maximumValue - ratingSlider.minimumValue) / 2.0
		ratingChanged(self)
	}

	fileprivate func valueToString(_ value: Double) -> String {
		let numFormatter = NumberFormatter()
		numFormatter.numberStyle = .decimal
		return numFormatter.string(from: NSNumber(value: value))!
	}
}
