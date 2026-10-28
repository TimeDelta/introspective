//
//  StoredBooleanExpression.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 6/27/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import Persistence

@objc(BooleanExpression)
open class StoredBooleanExpression: NSManagedObject {
	open func convert() throws -> BooleanExpression {
		throw GenericError("must override")
	}
}
