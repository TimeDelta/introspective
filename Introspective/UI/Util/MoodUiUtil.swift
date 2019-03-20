//
//  MoodUiUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import UIKit

public final class MoodUiUtil {

	private typealias Me = MoodUiUtil

	public static let minRatingChanged = Notification.Name("minimumMoodRatingChanged")
	public static let maxRatingChanged = Notification.Name("maximumMoodRatingChanged")
	public static let useDiscreteMoodChanged = Notification.Name("useDiscreteMoodChanged")

	public static let minRatingColor = UIColor.black
	public static let maxRatingColor = UIColor.yellow

	public static func valueToString(_ value: Double) -> String {
		let numFormatter = NumberFormatter()
		numFormatter.numberStyle = .decimal
		return numFormatter.string(from: NSNumber(value: value))!
	}

	public static func colorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		return scaledColor(
			minColor: Me.minRatingColor,
			maxColor: Me.maxRatingColor,
			rating: rating,
			min: minRating,
			max: maxRating)
	}

	public static func inverseColorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		return scaledColor(
			minColor: Me.maxRatingColor,
			maxColor: Me.minRatingColor,
			rating: rating,
			min: minRating,
			max: maxRating)
	}

	// MARK: - Helper Functions

	private static func scaledColor(minColor: UIColor, maxColor: UIColor, rating: Double, min: Double, max: Double) -> UIColor {
		var maxRed: CGFloat = 0
		var maxGreen: CGFloat = 0
		var maxBlue: CGFloat = 0
		var maxAlpha: CGFloat = 0
		minColor.getRed(&maxRed, green: &maxGreen, blue: &maxBlue, alpha: &maxAlpha)

		var minRed: CGFloat = 0
		var minGreen: CGFloat = 0
		var minBlue: CGFloat = 0
		var minAlpha: CGFloat = 0
		maxColor.getRed(&minRed, green: &minGreen, blue: &minBlue, alpha: &minAlpha)

		let valueRatio = CGFloat(rating / (max - min))

		return UIColor(
			red: (maxRed - minRed) * valueRatio + minRed,
			green: (maxGreen - minGreen) * valueRatio + minGreen,
			blue: (maxBlue - minBlue) * valueRatio + minBlue,
			alpha: (maxAlpha - minAlpha) * valueRatio + minAlpha)
	}
}
