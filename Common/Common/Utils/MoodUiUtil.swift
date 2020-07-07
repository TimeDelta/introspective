//
//  MoodUiUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import UIKit

import DependencyInjection

// sourcery: AutoMockable
public protocol MoodUiUtil {
	func valueToString(_ value: Double) -> String
	func colorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor
	func feedbackMessage(for rating: Double, min: Double, max: Double) -> String
}

public final class MoodUiUtilImpl: MoodUiUtil {
	private typealias Me = MoodUiUtilImpl

	private static let lowMoodMessages = [
		"You've got this. Just hang in there. (%@)",
		"Take a deep breath and know that everything will be okay. (%@)",
		"Hang in there! It's gonna be okay. (%@)",
	]
	private static let mediumMoodMessages = [
		"Got it. You're at a %@",
	]
	private static let highMoodMessages = [
		"Yay! You're feeling pretty good. (%@)",
		"I'm glad you're feeling well. (%@)",
	]

	public static let minRatingChanged = Notification.Name("minimumMoodRatingChanged")
	public static let maxRatingChanged = Notification.Name("maximumMoodRatingChanged")
	public static let useDiscreteMoodChanged = Notification.Name("useDiscreteMoodChanged")

	public static let minRatingColor = UIColor.black
	public static let maxRatingColor = UIColor.yellow

	public func valueToString(_ value: Double) -> String {
		let numFormatter = NumberFormatter()
		numFormatter.numberStyle = .decimal
		return numFormatter.string(from: NSNumber(value: value))!
	}

	public func colorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		scaledColor(
			minColor: Me.minRatingColor,
			maxColor: Me.maxRatingColor,
			rating: rating,
			min: minRating,
			max: maxRating
		)
	}

	public final func feedbackMessage(for rating: Double, min: Double, max: Double) -> String {
		let valueString = valueToString(rating)
		let range = max - min
		if rating < 0.33 * range + min {
			return String(format: Me.lowMoodMessages[Int.random(in: 0 ..< Me.lowMoodMessages.count)], valueString)
		}
		if rating < 0.66 * range + min {
			return String(format: Me.mediumMoodMessages[Int.random(in: 0 ..< Me.mediumMoodMessages.count)], valueString)
		}
		return String(format: Me.highMoodMessages[Int.random(in: 0 ..< Me.highMoodMessages.count)], valueString)
	}

	// MARK: - Helper Functions

	private func scaledColor(
		minColor: UIColor,
		maxColor: UIColor,
		rating: Double,
		min: Double,
		max: Double
	) -> UIColor {
		var maxRed: CGFloat = 0
		var maxGreen: CGFloat = 0
		var maxBlue: CGFloat = 0
		var maxAlpha: CGFloat = 0
		maxColor.getRed(&maxRed, green: &maxGreen, blue: &maxBlue, alpha: &maxAlpha)

		var minRed: CGFloat = 0
		var minGreen: CGFloat = 0
		var minBlue: CGFloat = 0
		var minAlpha: CGFloat = 0
		minColor.getRed(&minRed, green: &minGreen, blue: &minBlue, alpha: &minAlpha)

		let valueRatio = CGFloat(rating / (max - min))

		return UIColor(
			red: (maxRed - minRed) * valueRatio + minRed,
			green: (maxGreen - minGreen) * valueRatio + minGreen,
			blue: (maxBlue - minBlue) * valueRatio + minBlue,
			alpha: (maxAlpha - minAlpha) * valueRatio + minAlpha
		)
	}
}
