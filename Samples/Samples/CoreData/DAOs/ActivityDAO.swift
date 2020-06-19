//
//  ActivityDAO.swift
//  Introspective
//
//  Created by Bryan Nova on 8/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

import Common
import DependencyInjection
import Persistence

//sourcery: AutoMockable
public protocol ActivityDAO {

	func getMostRecentActivityEndDate() throws -> Date?
	func getMostRecentActivity(_ activityDefinition: ActivityDefinition) throws -> Activity?
	func getMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) throws -> Activity?

	/// - Parameter name: case-insensitive activity name for which to search
	func activityDefinitionWithNameExists(_ name: String) throws -> Bool

	@discardableResult
	func startActivity(_ definition: ActivityDefinition) throws -> Activity

	@discardableResult
	func createDefinition(
		name: String,
		description: String?,
		source: Sources.ActivitySourceNum,
		recordScreenIndex: Int16?,
		autoNote: Bool?,
		using transaction: Transaction?
	) throws -> ActivityDefinition
	@discardableResult
	func createActivity(
		definition: ActivityDefinition,
		startDate: Date,
		source: Sources.ActivitySourceNum,
		endDate: Date?,
		note: String?,
		using transaction: Transaction?
	) throws -> Activity
}

extension ActivityDAO {

	public func createDefinition(
		name: String,
		description: String? = nil,
		source: Sources.ActivitySourceNum = .introspective,
		recordScreenIndex: Int16? = nil,
		autoNote: Bool? = nil,
		using transaction: Transaction? = nil
	) throws -> ActivityDefinition {
		return try createDefinition(
			name: name,
			description: description,
			source: source,
			recordScreenIndex: recordScreenIndex,
			autoNote: autoNote,
			using: transaction)
	}
	@discardableResult
	public func createActivity(
		definition: ActivityDefinition,
		startDate: Date = Date(),
		source: Sources.ActivitySourceNum = .introspective,
		endDate: Date? = nil,
		note: String? = nil,
		using transaction: Transaction? = nil
	) throws -> Activity {
		return try createActivity(
			definition: definition,
			startDate: startDate,
			source: source,
			endDate: endDate,
			note: note,
			using: transaction)
	}
}

public class ActivityDAOImpl: ActivityDAO {

	private final let log = Log()

	public final func getMostRecentActivityEndDate() throws -> Date? {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "endDate != nil")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: false)]
		let activities = try DependencyInjector.get(Database.self).query(fetchRequest)
		if activities.count > 0 {
			return activities[0].end
		}
		return nil
	}

	public final func getMostRecentActivity(_ activityDefinition: ActivityDefinition) throws -> Activity? {
		let keyName = CommonSampleAttributes.startDate.variableName!
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "definition.name == %@", activityDefinition.name)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: keyName, ascending: false)]
		let activities = try DependencyInjector.get(Database.self).query(fetchRequest)
		if activities.count > 0 {
			return activities[0]
		}
		return nil
	}

	public final func getMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) throws -> Activity? {
		let endDateVariableName = CommonSampleAttributes.endDate.variableName!
		let incompleteActivities = activityDefinition.activities.filtered(
			using: NSPredicate(format: "%K == nil", endDateVariableName)
		) as! Set<Activity>

		if incompleteActivities.count > 0 {
			let sortedIncompleteActivities = incompleteActivities.sorted(by: { $0.start > $1.start })
			return sortedIncompleteActivities[0]
		}
		return nil
	}

	public final func activityDefinitionWithNameExists(_ name: String) throws -> Bool {
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let results = try DependencyInjector.get(Database.self).query(fetchRequest)
		return results.count > 0
	}

	@discardableResult
	public final func startActivity(_ definition: ActivityDefinition) throws -> Activity {
		let transaction = DependencyInjector.get(Database.self).transaction()
		let activity = try transaction.new(Activity.self)
		activity.setSource(.introspective)
		let definition = try DependencyInjector.get(Database.self).pull(savedObject: definition, fromSameContextAs: activity)
		activity.definition = definition
		activity.start = Date()
		definition.addToActivities(activity)
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return try DependencyInjector.get(Database.self).pull(savedObject: activity)
	}

	@discardableResult
	public final func createDefinition(
		name: String,
		description: String?,
		source: Sources.ActivitySourceNum,
		recordScreenIndex: Int16?,
		autoNote: Bool?,
		using transaction: Transaction?
	) throws -> ActivityDefinition {
		let transaction = transaction ?? DependencyInjector.get(Database.self).transaction()
		let activityDefinition = try transaction.new(ActivityDefinition.self)
		activityDefinition.name = name
		activityDefinition.activityDescription = description
		activityDefinition.setSource(.introspective)

		if let recordScreenIndex = recordScreenIndex {
			activityDefinition.recordScreenIndex = recordScreenIndex
		} else {
			let numDefinitions = try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest()).count
			activityDefinition.recordScreenIndex = Int16(numDefinitions)
		}

		if let autoNote = autoNote {
			activityDefinition.autoNote = autoNote
		}

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)

		return activityDefinition
	}

	@discardableResult
	public final func createActivity(
		definition: ActivityDefinition,
		startDate: Date,
		source: Sources.ActivitySourceNum,
		endDate: Date?,
		note: String?,
		using transaction: Transaction?
	) throws -> Activity {
		let transaction = transaction ?? DependencyInjector.get(Database.self).transaction()
		let activity = try transaction.new(Activity.self)

		activity.definition = definition
		activity.note = note
		activity.start = startDate
		activity.end = endDate
		activity.setSource(source)

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return activity
	}
}
