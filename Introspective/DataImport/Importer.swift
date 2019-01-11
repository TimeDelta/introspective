//
//  Importer.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Importer {

	var dataTypePluralName: String { get }
	var sourceName: String { get }
	var lastImport: Date? { get }
	var importOnlyNewData: Bool { get set }

	func importData(from url: URL) throws
	func resetLastImportDate() throws
	/// - Note: This function is idempotent
	func cancel()

	/// - Returns: True if and only if the passed importer has the same internal unique id as this importer.
	func equalTo(_ otherImporter: Importer) -> Bool
}
