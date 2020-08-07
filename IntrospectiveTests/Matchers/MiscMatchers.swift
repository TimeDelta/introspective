//
//  MiscMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
import CoreData
@testable import Introspective
@testable import DependencyInjection
@testable import Persistence

func numberStoredInDatabase<Type: NSManagedObject & CoreDataObject>(_ expectedCount: Int) -> Matcher<Type.Type> {
	return numberStoredInDatabase(equalTo(expectedCount))
}

func numberStoredInDatabase<Type: NSManagedObject & CoreDataObject>(
	_ expectedCountMatcher: Matcher<Int>
) -> Matcher<Type.Type> {
	return Matcher("No \(Type.entityName) exists") { _ -> MatchResult in
		let count = try! injected(Database.self).query(Type.fetchRequest() as! NSFetchRequest<Type>).count
		return expectedCountMatcher.matches(count)
	}
}

func sameObject<SubType: AnyObject, Type>(_ expected: SubType) -> Matcher<Type> {
	return Matcher("") { (actual: Type) -> Bool in
		guard let actual = actual as? SubType else {
			return false
		}
		return actual === expected
	}
}

// MARK: - Helpers

func delegateMatching<T>(_ value: T, _ matcher: Matcher<T>, _ mismatchDescriber: (String?) -> String?) -> MatchResult {
	switch matcher.matches(value) {
		case .match:
			return .match
		case let .mismatch(mismatchDescription):
			return .mismatch(mismatchDescriber(mismatchDescription))
	}
}

func getMismatchDescription<T>(_ matcher: Matcher<T>, value: T) -> (MatchResult, String?) {
	let matchResult = matcher.matches(value)
	switch matchResult {
		case let .mismatch(mismatchDescription): return (matchResult, mismatchDescription)
		default: return (matchResult, nil)
	}
}
