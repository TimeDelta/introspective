//
//  QueryError.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol QueryError: DisplayableError {

	var dataType: DataTypes { get }

	init(dataType: DataTypes)
}

public class NoSamplesFoundQueryError: QueryError {

	public fileprivate(set) var dataType: DataTypes
	public var displayableDescription: String {
		let dataText = dataType.description.lowercased()
		return "No \(dataText) samples found. Are you sure you authorized this app to read \(dataText) data?"
	}

	public required init(dataType: DataTypes) {
		self.dataType = dataType
	}
}

public class UnauthorizedQueryError: QueryError {

	public fileprivate(set) var dataType: DataTypes
	public var displayableDescription: String {
		return "You must authorize this app to read \(dataType.description) data"
	}

	public required init(dataType: DataTypes) {
		self.dataType = dataType
	}
}