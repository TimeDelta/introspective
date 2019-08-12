//
//  GenericUIMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

func isEnabled<Type: UIControl>() -> Matcher<Type> {
	return Matcher("is enabled") { (control: Type) -> Bool in
		return control.isEnabled
	}
}

func userInteractionIsEnabled<Type: UIView>() -> Matcher<Type> {
	return Matcher("user interaction is enabled") { view -> Bool in
		return view.isUserInteractionEnabled
	}
}

func isHidden<Type: UIView>() -> Matcher<Type> {
	return Matcher("is hidden") { (view: Type) -> Bool in
		return view.isHidden
	}
}

func hasAccessibilityValue<Type: NSObject>(_ expected: String?) -> Matcher<Type?> {
	return hasAccessibilityValue(equalTo(expected))
}

func hasAccessibilityValue<Type: NSObject>(_ valueMatcher: Matcher<String?>) -> Matcher<Type?> {
	return Matcher("has accessibility value " + valueMatcher.description) { object -> MatchResult in
		guard let object = object else {
			return .mismatch("object was nil")
		}
		return valueMatcher.matches(object.accessibilityValue)
	}
}
