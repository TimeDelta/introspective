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

func activityExists(_ matcher: Matcher<Activity>) -> Matcher<Database> {
	return Matcher("Activity exists \(matcher.description)") { database -> MatchResult in
		guard let activities = try? database.query(Activity.fetchRequest()) else {
			return .mismatch("an error occurred")
		}
		for activity in activities {
			if matcher.matches(activity).boolValue {
				return .match
			}
		}
		if activities.count > 0 {
			return .mismatch("No matching activity exists")
		}
		return .mismatch("No activities exist")
	}
}

func isStopped() -> Matcher<Activity> {
	return Matcher("is stopped") { activity -> Bool in
		return activity.end != nil
	}
}

func hasDefinition(_ definition: ActivityDefinition) -> Matcher<Activity> {
	return hasDefinition(equals(definition))
}

func hasDefinition(_ matcher: Matcher<ActivityDefinition>) -> Matcher<Activity> {
	return Matcher("has definition \(matcher.description)") { activity -> MatchResult in
		return matcher.matches(activity.definition)
	}
}

func hasStartDate(_ date: Date) -> Matcher<Activity> {
	return hasStartDate(equalTo(date))
}

func hasStartDate(_ matcher: Matcher<Date>) -> Matcher<Activity> {
	return Matcher("has start date \(matcher.description)") { activity -> MatchResult in
		return matcher.matches(activity.start)
	}
}

func hasEndDate(_ date: Date) -> Matcher<Activity> {
	return hasEndDate(equalTo(date))
}

func hasEndDate(_ matcher: Matcher<Date?>) -> Matcher<Activity> {
	return Matcher("has end date \(matcher.description)") { activity -> MatchResult in
		return matcher.matches(activity.end)
	}
}

func hasNote(_ note: String) -> Matcher<Activity> {
	return hasNote(equalTo(note))
}

func hasNote(_ matcher: Matcher<String?>) -> Matcher<Activity> {
	return Matcher("has note \(matcher.description)") { activity -> MatchResult in
		return matcher.matches(activity.note)
	}
}

func hasTags(_ tagNames: Set<String>) -> Matcher<Activity> {
	return hasTags(equalTo(tagNames))
}

func hasTags(_ matcher: Matcher<Set<String>>) -> Matcher<Activity> {
	return Matcher("has tags \(matcher.description)") { activity -> MatchResult in
		return matcher.matches(Set(activity.tagsArray().map{ $0.name }))
	}
}
