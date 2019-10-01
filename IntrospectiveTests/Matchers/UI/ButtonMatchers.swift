//
//  ButtonMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 5/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

func hasTitle(_ expectedTitle: String) -> Matcher<UIButton> {
	return hasTitle(equalTo(expectedTitle))
}

func hasTitle(_ titleMatcher: Matcher<String>) -> Matcher<UIButton> {
	return Matcher("button has title " + titleMatcher.description) { (button: UIButton) -> MatchResult in
		if let title = button.currentTitle {
			return titleMatcher.matches(title)
		}
		return .mismatch("Current title is nil")
	}
}

func hasTitle(_ expectedTitle: String) -> Matcher<UIBarButtonItem> {
	return hasTitle(equalTo(expectedTitle))
}

func hasTitle(_ titleMatcher: Matcher<String>) -> Matcher<UIBarButtonItem> {
	return Matcher("button has title " + titleMatcher.description) { button -> MatchResult in
		if let title = button.title {
			return titleMatcher.matches(title)
		}
		return .mismatch("Current title is nil")
	}
}

// MARK: - Button Descriptions

let describeButtonWithCurrentTitle: (UIButton) -> String = { $0.currentTitle ?? "" }
fileprivate var buttonDescriber: (UIButton) -> String = describeButtonWithCurrentTitle

func useButtonDescriber(_ describerFunction: @escaping (UIButton) -> String) {
	buttonDescriber = describerFunction
}

func resetButtonDescriber() {
	buttonDescriber = describeButtonWithCurrentTitle
}

fileprivate func buttonDescription(_ button: UIButton) -> String {
	return buttonDescriber(button)
}

public extension UIButton {
	open override var description: String {
		return buttonDescription(self)
	}
}

// MARK: - Enabled

func isEnabled() -> Matcher<UIBarButtonItem> {
	return Matcher("is enabled") { (button: UIBarButtonItem) -> Bool in
		return button.isEnabled
	}
}
