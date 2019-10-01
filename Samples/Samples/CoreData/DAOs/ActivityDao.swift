//
//  ActivityDao.swift
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
public protocol ActivityDao {

	func getMostRecentActivityDate() -> Date?
}

public class ActivityDaoImpl: ActivityDao {

	private final let log = Log()

	public func getMostRecentActivityDate() -> Date? {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "endDate != nil")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: false)]
		do {
			let activities = try DependencyInjector.get(Database.self).query(fetchRequest)
			if activities.count > 0 {
				return activities[0].end
			}
		} catch {
			log.error("Failed to fetch most recent activity: %@", errorInfo(error))
		}
		return nil
	}
}
