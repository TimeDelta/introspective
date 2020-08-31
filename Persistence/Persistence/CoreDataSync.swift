//
//  CoreDataSync.swift
//  Persistence
//
//  Created by Bryan Nova on 8/7/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

/// Used to determine sync status
public final class CoreDataSync: NSManagedObject, CoreDataObject {
	@nonobjc static func fetchRequest() -> NSFetchRequest<CoreDataSync> {
		NSFetchRequest<CoreDataSync>(entityName: entityName)
	}

	public static var entityName: String = "CoreDataSync"

	/// Whether or not the CoreData ManagedObjectContext was modified by a different app in current app group
	@NSManaged var externallyModified: Bool
}
