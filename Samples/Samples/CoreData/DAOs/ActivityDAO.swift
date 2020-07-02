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
import Settings

//sourcery: AutoMockable
public protocol ActivityDAO {

	func getMostRecentActivityEndDate() throws -> Date?
	func getMostRecentActivity(_ activityDefinition: ActivityDefinition) throws -> Activity?
	func getMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) throws -> Activity?
	/// Get the activity definition with the specified name (if it exists).
	/// - Throws: If there is more than one activity definition with the given name.
	/// - Returns: The matching activity definition if it exists. Otherwise, `nil`.
	func getDefinitionWith(name: String) throws -> ActivityDefinition?
	/// - Parameter name: case-insensitive activity name for which to search
	func activityDefinitionWithNameExists(_ name: String) throws -> Bool

	@discardableResult
	func startActivity(_ definition: ActivityDefinition, withNote note: String?) throws -> Activity
	@discardableResult
	func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) throws -> Activity
	@discardableResult
	func stopMostRecentlyStartedIncompleteActivity() throws -> Activity
	/// - Returns: Any activities that are eligible for auto-note
	@discardableResult
	func stopAllActivities() throws -> [Activity]
	/// - Parameter end: If provided, use this as the stop date / time.
	/// - Returns: Whether or not the activity was ignored
	func autoIgnoreIfAppropriate(_ activity: Activity, end: Date) -> Bool

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
		extraTags: [Tag],
		using transaction: Transaction?
	) throws -> Activity
}

extension ActivityDAO {

	/// - Parameter end: If provided, use this as the stop date / time.
	/// - Returns: Whether or not the activity was ignored
	public func autoIgnoreIfAppropriate(_ activity: Activity, end: Date = Date()) -> Bool {
		return autoIgnoreIfAppropriate(activity, end: end)
	}

	@discardableResult
	public func startActivity(_ definition: ActivityDefinition, withNote note: String? = nil) throws -> Activity {
		return try startActivity(definition, withNote: note)
	}

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
		extraTags: [Tag] = [],
		using transaction: Transaction? = nil
	) throws -> Activity {
		return try createActivity(
			definition: definition,
			startDate: startDate,
			source: source,
			endDate: endDate,
			note: note,
			extraTags: extraTags,
			using: transaction)
	}
}

public class ActivityDAOImpl: ActivityDAO {

	private final let log = Log()

	// MARK: - Getters

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
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			NSPredicate(format: "definition ==[cd] %@", activityDefinition),
			NSPredicate(format: "%K == nil", endDateVariableName),
		])
		let incompleteActivities = try DependencyInjector.get(Database.self).query(fetchRequest)

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

	/// Get the activity definition with the specified name (if it exists).
	/// - Throws: If there is more than one activity definition with the given name.
	/// - Returns: The matching activity definition if it exists. Otherwise, `nil`.
	public final func getDefinitionWith(name: String) throws -> ActivityDefinition? {
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let results = try DependencyInjector.get(Database.self).query(fetchRequest)
		if results.count == 0 {
			return nil
		}
		if results.count == 1 {
			return results[0]
		}
		let errorMessage = String(format: "Found %d activity definitions with the same name: %{private}@", results.count, name)
		throw GenericError(errorMessage)
	}

	@discardableResult
	public final func startActivity(_ definition: ActivityDefinition, withNote note: String?) throws -> Activity {
		let transaction = DependencyInjector.get(Database.self).transaction()
		let activity = try transaction.new(Activity.self)
		activity.setSource(.introspective)
		let definition = try DependencyInjector.get(Database.self).pull(savedObject: definition, fromSameContextAs: activity)
		activity.definition = definition
		activity.start = Date()
		activity.note = note
		definition.addToActivities(activity)
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return try DependencyInjector.get(Database.self).pull(savedObject: activity)
	}

	@discardableResult
	public final func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) throws -> Activity {
		let endDateVariableName = CommonSampleAttributes.endDate.variableName!
		let incompleteActivities = activityDefinition.activities.filtered(
			using: NSPredicate(format: "%K == nil", endDateVariableName)
		) as! Set<Activity>

		if incompleteActivities.count > 0 {
			let sortedIncompleteActivities = incompleteActivities.sorted(by: { $0.start > $1.start })
			let transaction = DependencyInjector.get(Database.self).transaction()
			let activity = try transaction.pull(savedObject: sortedIncompleteActivities[0])
			let now = Date()
			if !autoIgnoreIfAppropriate(activity, end: now) {
				activity.end = now
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			}
			return try DependencyInjector.get(Database.self).pull(savedObject: activity)
		}
		let message = String(format: "Activity named %{private}@ is not currently active", activityDefinition.name)
		throw GenericDisplayableError(title: message)
	}

	@discardableResult
	public final func stopMostRecentlyStartedIncompleteActivity() throws -> Activity {
		let endDateVariableName = CommonSampleAttributes.endDate.variableName!
		let startDateVariableName = CommonSampleAttributes.startDate.variableName!
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "%K == nil", endDateVariableName)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: startDateVariableName, ascending: false)]
		fetchRequest.fetchLimit = 1

		let transaction = DependencyInjector.get(Database.self).transaction()
		let activities = try transaction.query(fetchRequest)
		if activities.count == 0 {
			throw GenericDisplayableError(title: "No activities currently running")
		}
		let now = Date()
		let activity = activities[0]
		if !autoIgnoreIfAppropriate(activity, end: now) {
			activity.end = now
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		}
		return activity
	}

	@discardableResult
	public final func stopAllActivities() throws -> [Activity] {
		let endDateVariableName = CommonSampleAttributes.endDate.variableName!
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "%K == nil", endDateVariableName)
		let activitiesToStop = try DependencyInjector.get(Database.self).query(fetchRequest)
		let now = Date()
		var activitiesToAutoNote = [Activity]()
		for activity in activitiesToStop {
			if !autoIgnoreIfAppropriate(activity, end: now) {
				let transaction = DependencyInjector.get(Database.self).transaction()
				activity.end = now
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				if activity.definition.autoNote {
					activitiesToAutoNote.append(activity)
				}
			}
		}
		return activitiesToAutoNote
	}

	/// - Parameter end: If provided, use this as the stop date / time.
	/// - Returns: Whether or not the activity was ignored
	public final func autoIgnoreIfAppropriate(_ activity: Activity, end: Date = Date()) -> Bool {
		if DependencyInjector.get(Settings.self).autoIgnoreEnabled {
			let minSeconds = DependencyInjector.get(Settings.self).autoIgnoreSeconds
			if Duration(start: activity.start, end: end).inUnit(.second) < Double(minSeconds) {
				do {
					let transaction = DependencyInjector.get(Database.self).transaction()
					// can't really explain this to the user
					try retryOnFail({ try transaction.delete(activity) }, maxRetries: 2)
					try transaction.commit()
					return true
				} catch {
					log.error("Failed to delete activity that should be auto-ignored: %@", errorInfo(error))
				}
			}
		}
		return false
	}

	// MARK: - Creators

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
		extraTags: [Tag],
		using transaction: Transaction?
	) throws -> Activity {
		let transaction = transaction ?? DependencyInjector.get(Database.self).transaction()
		let activity = try transaction.new(Activity.self)
		let sameContextDefinition = try transaction.pull(savedObject: definition)

		activity.definition = sameContextDefinition
		activity.note = note
		activity.start = startDate
		activity.end = endDate
		activity.setSource(source)
		extraTags.forEach(activity.addToTags(_:))

		sameContextDefinition.addToActivities(activity)

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return try DependencyInjector.get(Database.self).pull(savedObject: activity)
	}
}
