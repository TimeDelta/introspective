//
//  DatabaseConnector.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SQLite

class DatabaseConnector: NSObject {

	let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

	var db: Connection?

	override init() {
	}

	func connect() throws {
		do {
			self.db = try Connection("\(path)/db.sqlite3")
		}
	}
}
