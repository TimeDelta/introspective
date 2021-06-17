//
//  PainTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 6/17/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

public protocol PainTableViewCell: UITableViewCell {
	var pain: Pain! { get set }
}

final class PainTableViewCellImpl: UITableViewCell, PainTableViewCell {
	public final var pain: Pain! {
		didSet {
			guard let pain = pain else { return }
			painRatingColorLabel.backgroundColor = injected(PainUiUtil.self).colorForPain(
				rating: pain.rating,
				minRating: pain.minRating,
				maxRating: pain.maxRating
			)
			painRatingColorLabel.text = nil
			let ratingText = injected(PainUiUtil.self).valueToString(pain.rating)
			let minText = injected(PainUiUtil.self).valueToString(pain.minRating)
			let maxText = injected(PainUiUtil.self).valueToString(pain.maxRating)
			painRatingLabel.text = ratingText + " (\(minText)-\(maxText))"
			timestampLabel.text = injected(CalendarUtil.self)
				.string(for: pain.date, dateStyle: .medium, timeStyle: .short)
			if let note = pain.note {
				if !note.isEmpty {
					noteLabel.text = pain.note
				}
			}
			if let location = pain.location {
				locationLabel.text = location
			}
			painRatingLabel.accessibilityValue = painRatingLabel.text
			timestampLabel.accessibilityValue = timestampLabel.text
			noteLabel.accessibilityValue = noteLabel.text
		}
	}

	@IBOutlet final var painRatingColorLabel: UILabel!
	@IBOutlet final var painRatingLabel: UILabel!
	@IBOutlet final var timestampLabel: UILabel!
	@IBOutlet final var locationLabel: UILabel!
	@IBOutlet final var noteLabel: UILabel!

	override func prepareForReuse() {
		pain = nil
		painRatingColorLabel.text = nil
		painRatingLabel.text = nil
		timestampLabel.text = nil
		locationLabel.text = nil
		noteLabel.text = nil
	}
}
