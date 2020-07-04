//
//  StringMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 5/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

/// - Note: Will fail match if actual is nil
func containsLine(_ matcher: Matcher<String>) -> Matcher<String?> {
	return Matcher("Contains line \(matcher.description)") { (text: String?) -> MatchResult in
		guard let text = text else {
			return .mismatch("String is nil")
		}
		let lines = text.split(separator: "\n")
		if lines.count == 0 {
			return .mismatch("String is empty")
		}
		for line in lines {
			if matcher.matches(String(line)).boolValue {
				return .match
			}
		}
		return .mismatch("No line found \(matcher.description)")
	}
}

/// - Note: Will fail match if actual is nil
/// - Parameter lineNumber: Indexes start at 1
func line(_ lineNumber: Int, _ matcher: Matcher<String>) -> Matcher<String?> {
	return Matcher("Line \(lineNumber) \(matcher.description)") { (text: String?) -> MatchResult in
		guard let text = text else {
			return .mismatch("String is nil")
		}
		let lines = text.split(separator: "\n")
		if lines.count == 0 {
			return .mismatch("String is empty")
		}
		if lines.count < lineNumber {
			return .mismatch("Only \(lines.count) lines found")
		}
		return matcher.matches(String(lines[lineNumber - 1]))
	}
}
