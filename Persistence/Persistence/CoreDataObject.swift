//
//  CoreDataObject.swift
//  Introspective
//
//  Created by Bryan Nova on 8/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol CoreDataObject {
	static var entityName: String { get }
}
