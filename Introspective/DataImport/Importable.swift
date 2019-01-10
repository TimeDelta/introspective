//
//  Importable.swift
//  Introspective
//
//  Created by Bryan Nova on 1/10/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Importable)
public class Importable: NSManagedObject {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Importable> {
		return NSFetchRequest<Importable>(entityName: "Importable")
	}

	@NSManaged public var partOfCurrentImport: Bool
}
