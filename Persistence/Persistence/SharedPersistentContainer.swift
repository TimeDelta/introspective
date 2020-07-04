//
//  SharedPersistentContainer.swift
//  Persistence
//
//  Created by Bryan Nova on 10/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

public class SharedPersistentContainer: NSPersistentContainer {
	override open class func defaultDirectoryURL() -> URL {
		let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Introspective")?
			.appendingPathComponent("Introspective.sqlite")
		return storeURL!
	}
}
