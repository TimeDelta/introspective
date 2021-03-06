//
//  Exportable.swift
//  Introspective
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CSV
import Foundation

/// To use the provided export functions, conform to this protocol.
public protocol Exportable {
	static var exportFileDescription: String { get }
	static func exportHeaderRow(to csv: CSVWriter) throws

	func export(to csv: CSVWriter) throws
}
