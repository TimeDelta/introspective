//
//  StringUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StringUtil {

	fileprivate typealias Me = StringUtil

	fileprivate static let numberRegex = "^[0-9]*.?[0-9]+$"
	fileprivate static let integerRegex = "^[0-9]+$"

	public func isNumber(_ str: String) -> Bool {
		return str.range(of: Me.numberRegex, options: .regularExpression, range: nil, locale: nil) != nil
	}

	public func isInteger(_ str: String) -> Bool {
		return str.range(of: Me.integerRegex, options: .regularExpression, range: nil, locale: nil) != nil
	}
}
