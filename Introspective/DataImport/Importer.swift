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
	var customImportMessage: String? { get }
	var lastImport: Date? { get }
	var isPaused: Bool { get }
	var importOnlyNewData: Bool { get set }

	func importData(from url: URL) throws
	func resetLastImportDate() throws

	func pause()
	func resume() throws
}
