//
//  ActivityMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 5/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
@testable import Introspective

func equivalentDoesNotExistInDatabase() -> Matcher<Activity> {
	return Matcher("does not exist") { activity -> MatchResult in
		let activities = try! DependencyInjector.db.query(Activity.fetchRequest())
		if activities.contains(where: { $0.equalTo(activity) }) {
			return .mismatch("\(activity.debugDescription) exists in database")
		}
		return .match
	}
}
