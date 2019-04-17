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
	/// This will be displayed to the user as the message of the "Import new data only?" prompt
	var customImportMessage: String? { get }
	var lastImport: Date? { get }
	var isPaused: Bool { get }
	var isCancelled: Bool { get }
	var importOnlyNewData: Bool { get set }

	func importData(from url: URL) throws
	func resetLastImportDate() throws

	/// - Returns: A value between 0 and 1
	func percentComplete() -> Double

	/// Once cancelled, an import cannot be resumed.
	func cancel()
	func pause()
	func resume() throws

	func equalTo(_ other: Importer) -> Bool
}

extension Importer {
	public func equalTo(_ other: Importer) -> Bool {
		return type(of: self) == type(of: other) && lastImport == other.lastImport
	}
}
