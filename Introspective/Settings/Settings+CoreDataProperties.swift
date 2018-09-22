//
//  Settings+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension SettingsImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsImpl> {
		return NSFetchRequest<SettingsImpl>(entityName: "Settings")
	}

	@NSManaged public var maxMood: Double
}
