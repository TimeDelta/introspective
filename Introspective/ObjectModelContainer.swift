//
//  ObjectModelContainer.swift
//  Persistence
//
//  Created by Bryan Nova on 10/1/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public final class ObjectModelContainer {

	// avoid issues with loading the managed object model multiple times in a single app
	// caused by tearing down and recreating the persistent container for each functional test
	public static let objectModel: NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
}
