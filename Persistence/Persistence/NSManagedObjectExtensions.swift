//
//  NSManagedObjectExtensions.swift
//  Persistence
//
//  Created by Bryan Nova on 7/31/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import DependencyInjection

public extension NSManagedObject {
	/// Turn this object back into a fault, removing any strong reference cycles so that it can be cleaned up normally by ARC.
	func cleanUp() {
		DependencyInjector.get(Database.self).cleanUpManagedObjectWithStrongReferenceCycle(self)
	}
}
