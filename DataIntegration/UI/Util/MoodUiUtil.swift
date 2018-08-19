//
//  MoodUiUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import UIKit

public class MoodUiUtil {

	fileprivate typealias Me = MoodUiUtil

	public static let minRatingColor = UIColor.black
	public static let maxRatingColor = UIColor.yellow

	public static func valueToString(_ value: Double) -> String {
		let numFormatter = NumberFormatter()
		numFormatter.numberStyle = .decimal
		return numFormatter.string(from: NSNumber(value: value))!
	}

	public static func colorForMood(rating: Double) -> UIColor {
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

		let valueRatio = CGFloat(rating / MoodImpl.maxRating)

		return UIColor(
			red: (maxRed - minRed) * valueRatio + minRed,
			green: (maxGreen - minGreen) * valueRatio + minGreen,
			blue: (maxBlue - minBlue) * valueRatio + minBlue,
			alpha: (maxAlpha - minAlpha) * valueRatio + minAlpha)
	}
}
