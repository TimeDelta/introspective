//
//  StringUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol StringUtil {
	func isNumber(_ str: String) -> Bool
	func isInteger(_ str: String) -> Bool
}

public final class StringUtilImpl: StringUtil {

	private typealias Me = StringUtilImpl

	private static let numberRegex = "^[0-9]*.?[0-9]+$"
	private static let integerRegex = "^[0-9]+$"

	public final func isNumber(_ str: String) -> Bool {
		return str.range(of: Me.numberRegex, options: .regularExpression, range: nil, locale: nil) != nil
	}

	public final func isInteger(_ str: String) -> Bool {
		return str.range(of: Me.integerRegex, options: .regularExpression, range: nil, locale: nil) != nil
	}
}
