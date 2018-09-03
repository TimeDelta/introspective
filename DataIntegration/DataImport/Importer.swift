//
//  Importer.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Importer {

	func importData(from url: URL) throws
}
