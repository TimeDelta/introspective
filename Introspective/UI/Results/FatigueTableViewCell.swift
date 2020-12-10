//
//  FatigueTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/9/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

public protocol FatigueTableViewCell: UITableViewCell {
	var fatigue: Fatigue! { get set }
}

final class FatigueTableViewCellImpl: UITableViewCell, FatigueTableViewCell {
	public final var fatigue: Fatigue! {
		didSet {
			guard let fatigue = fatigue else { return }
			fatigueRatingColorLabel.backgroundColor = injected(FatigueUiUtil.self).colorForFatigue(
				rating: fatigue.rating,
				minRating: fatigue.minRating,
				maxRating: fatigue.maxRating
			)
			fatigueRatingColorLabel.text = nil
			let ratingText = injected(FatigueUiUtil.self).valueToString(fatigue.rating)
			let minText = injected(FatigueUiUtil.self).valueToString(fatigue.minRating)
			let maxText = injected(FatigueUiUtil.self).valueToString(fatigue.maxRating)
			fatigueRatingLabel.text = ratingText + " (\(minText)-\(maxText))"
			timestampLabel.text = injected(CalendarUtil.self)
				.string(for: fatigue.date, dateStyle: .medium, timeStyle: .short)
			if let note = fatigue.note {
				if !note.isEmpty {
					noteLabel.text = fatigue.note
				}
			}
			fatigueRatingLabel.accessibilityValue = fatigueRatingLabel.text
			timestampLabel.accessibilityValue = timestampLabel.text
			noteLabel.accessibilityValue = noteLabel.text
		}
	}

	@IBOutlet final var fatigueRatingColorLabel: UILabel!
	@IBOutlet final var fatigueRatingLabel: UILabel!
	@IBOutlet final var timestampLabel: UILabel!
	@IBOutlet final var noteLabel: UILabel!

	override func prepareForReuse() {
		fatigue = nil
		fatigueRatingColorLabel.text = nil
		fatigueRatingLabel.text = nil
		timestampLabel.text = nil
		noteLabel.text = nil
	}
}
