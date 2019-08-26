//
//  TableViewCellMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/9/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

func hasText(_ text: String) -> Matcher<UITableViewCell> {
	return hasText(equalTo(text))
}

func hasText(_ textMatcher: Matcher<String>) -> Matcher<UITableViewCell> {
	return Matcher("has text \(textMatcher.description)") { cell -> MatchResult in
		guard let cellTextLabel = cell.textLabel else {
			return .mismatch("Cell has no text label")
		}
		guard let text = cellTextLabel.text else {
			return .mismatch("Text was nil")
		}
		return textMatcher.matches(text)
	}
}

func hasIndentationLevel(_ expectedLevel: Int) -> Matcher<UITableViewCell> {
	return hasIndentationLevel(equalTo(expectedLevel))
}

func hasIndentationLevel(_ indentationMatcher: Matcher<Int>) -> Matcher<UITableViewCell> {
	return Matcher("has indentation level \(indentationMatcher.description)") { cell -> MatchResult in
		return indentationMatcher.matches(cell.indentationLevel)
	}
}

func hasDetailText(_ text: String) -> Matcher<UITableViewCell> {
	return hasDetailText(equalTo(text))
}

func hasDetailText(_ textMatcher: Matcher<String>) -> Matcher<UITableViewCell> {
	return Matcher("has detail text \(textMatcher.description)") { cell -> MatchResult in
		guard let detailTextLabel = cell.detailTextLabel else {
			return .mismatch("Cell has no detail text label")
		}
		guard let detailText = detailTextLabel.text else {
			return .mismatch("Detail text was nil")
		}
		return textMatcher.matches(detailText)
	}
}
