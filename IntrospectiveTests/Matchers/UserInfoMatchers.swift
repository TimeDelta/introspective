//
//  UserInfoMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 5/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

typealias UserInfo = [AnyHashable: Any]

func userInfoHasKey(_ key: UserInfoKey) -> Matcher<UserInfo?> {
	return userInfoHasKey(key as AnyHashable)
}

func userInfoHasKey(_ key: AnyHashable) -> Matcher<UserInfo?> {
	return Matcher("User Info has \"\(key.description)\" key") { (userInfo: UserInfo?) -> MatchResult in
		guard let userInfo = userInfo else {
			return .mismatch("User Info was nil")
		}
		if !userInfo.keys.contains(key) {
			return .mismatch("User Info does not contain \"\(key.description)\" key")
		}
		return .match
	}
}

func userInfoHasKey<ValueType: Equatable>(_ key: UserInfoKey, withValue expectedValue: ValueType) -> Matcher<UserInfo?> {
	return userInfoHasKey(key as AnyHashable, withValue: expectedValue)
}

func userInfoHasKey<ValueType: Equatable>(_ key: AnyHashable, withValue expectedValue: ValueType) -> Matcher<UserInfo?> {
	return userInfoHasKey(key, withValue: equalTo(expectedValue))
}

func userInfoHasKey<ValueType>(
	_ key: UserInfoKey,
	withValue expectedValue: ValueType,
	_ equalTo: @escaping (ValueType, ValueType) -> Bool)
-> Matcher<UserInfo?> {
	return userInfoHasKey(key as AnyHashable, withValue: expectedValue, equalTo)
}

func userInfoHasKey<ValueType>(
	_ key: AnyHashable,
	withValue expectedValue: ValueType,
	_ equalTo: @escaping (ValueType, ValueType) -> Bool)
-> Matcher<UserInfo?> {
	let equalToMatcher = Matcher("equal to \(String(describing: expectedValue))") { (value: ValueType) -> MatchResult in
		if equalTo(value, expectedValue) {
			return .match
		}
		return .mismatch("'\(String(describing: value))' is not equal to '\(String(describing: expectedValue))'")
	}
	return userInfoHasKey(key, withValue: equalToMatcher)
}

func userInfoHasKey<ValueType>(_ key: UserInfoKey, withValue expectedValueMatcher: Matcher<ValueType>) -> Matcher<UserInfo?> {
	return userInfoHasKey(key as AnyHashable, withValue: expectedValueMatcher)
}

func userInfoHasKey<ValueType>(_ key: AnyHashable, withValue expectedValueMatcher: Matcher<ValueType>) -> Matcher<UserInfo?> {
	let matcherDescription = "User Info has \"\(key.description)\" key with value \"\(expectedValueMatcher.description))\""
	return Matcher(matcherDescription) { (userInfo: UserInfo?) -> MatchResult in
		guard let userInfo = userInfo else {
			return .mismatch("User Info was nil")
		}
		if !userInfo.keys.contains(key) {
			return .mismatch("User Info does not contain \"\(key.description)\" key")
		}
		guard let actualValue = userInfo[key] as? ValueType else {
			return .mismatch("Value for \"\(key.description)\" is not a \(String(describing: ValueType.self))")
		}
		return expectedValueMatcher.matches(actualValue)
	}
}
