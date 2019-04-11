//
//  Matchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
import CoreData
@testable import Introspective

func groupExists(withDate date: Date, andSamples samples: [Sample]) -> Matcher<[(Any, [Sample])]> {
	return Matcher("Group with date \(date.debugDescription)") { groups -> MatchResult in
		guard let group = groups.first(where: { group in return group.0 as? Date == date }) else {
			return .mismatch("Missing group with date: \(date)")
		}
		let unexpectedSamples = group.1.filter({ sample in !samples.contains(where: { $0.equalTo(sample) }) })
		var mismatchMessage = ""
		if unexpectedSamples.count != 0 {
			mismatchMessage += "\(unexpectedSamples.count) unexpected Samples: \(unexpectedSamples.debugDescription)\n"
		}
		let missingSamples = samples[0...1].filter({ expectedSample in return !group.1.contains(where: { $0.equalTo(expectedSample) }) })
		if missingSamples.count != 0 {
			mismatchMessage += "\(missingSamples.count) missing Samples for \(date.description): \(missingSamples.debugDescription)"
		}
		if !mismatchMessage.isEmpty {
			return .mismatch(mismatchMessage)
		}
		return .match
	}
}

func noneStoredInDatabase<Type: NSManagedObject & CoreDataObject>() -> Matcher<Type.Type> {
	return Matcher("No \(Type.entityName) exists") { _ -> MatchResult in
		let count = try! DependencyInjector.db.query(Type.fetchRequest() as! NSFetchRequest<Type>).count
		if count == 0 { return .match }
		return .mismatch("Found \(count) \(Type.entityName)")
	}
}

func equivalentDoesNotExistInDatabase() -> Matcher<Activity> {
	return Matcher("does not exist") { activity -> MatchResult in
		let activities = try! DependencyInjector.db.query(Activity.fetchRequest())
		if activities.contains(where: { $0.equalTo(activity) }) {
			return .mismatch("\(activity.debugDescription) exists in database")
		}
		return .match
	}
}
