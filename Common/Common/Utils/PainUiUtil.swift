//
//  PainUiUtil.swift
//  Common
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation
import UIKit

import DependencyInjection

// sourcery: AutoMockable
public protocol PainUiUtil {
	func valueToString(_ value: Double) -> String
	func colorForPain(rating: Double, minRating: Double, maxRating: Double) -> UIColor
	func feedbackMessage(for rating: Double, min: Double, max: Double) -> String
}

public final class PainUiUtilImpl: PainUiUtil {
	private typealias Me = PainUiUtilImpl

	private static let highPainMessages = [
		"You've got this. Just hang in there. (%@)",
		"Take a deep breath and know that everything will be okay. (%@)",
		"Hang in there! It's gonna be okay. (%@)",
	]
	private static let mediumPainMessages = [
		"Got it. You're at a %@",
	]
	private static let lowPainMessages = [
		"Yay! You're at a %@. I'm glad you have energy.",
	]

	public static let minRatingChanged = Notification.Name("minimumPainRatingChanged")
	public static let maxRatingChanged = Notification.Name("maximumPainRatingChanged")
	public static let useDiscretePainChanged = Notification.Name("useDiscretePainChanged")

	public static let minRatingColor = UIColor.yellow
	public static let maxRatingColor = UIColor.black

	private let log = Log()

	public func valueToString(_ value: Double) -> String {
		let numFormatter = NumberFormatter()
		numFormatter.numberStyle = .decimal
		return numFormatter.string(from: NSNumber(value: value))!
	}

	public func colorForPain(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
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
		if rating <= 0.33 * range + min {
			return String(format: randomMessage(from: Me.lowPainMessages), valueString)
		}
		if rating <= 0.66 * range + min {
			return String(format: randomMessage(from: Me.mediumPainMessages), valueString)
		}
		return String(format: randomMessage(from: Me.highPainMessages), valueString)
	}

	// MARK: - Helper Functions

	private final func randomMessage(from messages: [String]) -> String {
		messages[Int.random(in: 0 ..< messages.count)]
	}

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
