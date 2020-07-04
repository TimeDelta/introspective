//
//  StringUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol StringUtil {
	func isNumber(_ str: String) -> Bool
	func isInteger(_ str: String) -> Bool
	func rangeOfNumberIn(_ str: String) -> Range<String.Index>?
	func isDayOfWeek(_ str: String) -> Bool
}

public final class StringUtilImpl: StringUtil {
	private typealias Me = StringUtilImpl

	private static let numberRegex = "[0-9]*\\.?[0-9]+"
	private static let integerRegex = "^[0-9]+$"

	public final func isNumber(_ str: String) -> Bool {
		str.range(of: "^" + Me.numberRegex + "$", options: .regularExpression, range: nil, locale: nil) != nil
	}

	public final func isInteger(_ str: String) -> Bool {
		str.range(of: Me.integerRegex, options: .regularExpression, range: nil, locale: nil) != nil
	}

	public final func rangeOfNumberIn(_ str: String) -> Range<String.Index>? {
		str.range(of: Me.numberRegex, options: .regularExpression, range: nil, locale: nil)
	}

	public final func isDayOfWeek(_ str: String) -> Bool {
		let dayName = str.lowercased()
		for day in DayOfWeek.allDays {
			if dayName.contains(day.abbreviation.lowercased()) {
				return true
			}
		}
		return false
	}
}
