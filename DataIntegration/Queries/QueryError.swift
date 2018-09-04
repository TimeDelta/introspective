//
//  QueryError.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol QueryError: DisplayableError {

	var sampleType: Sample.Type { get }

	init(sampleType: Sample.Type)
}

public class NoSamplesFoundQueryError: QueryError {

	public final let sampleType: Sample.Type
	public var displayableDescription: String {
		return "No \(sampleType.name.lowercased()) entries found."
	}

	public required init(sampleType: Sample.Type) {
		self.sampleType = sampleType
	}
}

public final class NoHealthKitSamplesFoundQueryError: NoSamplesFoundQueryError {

	public final override var displayableDescription: String {
		let dataText = sampleType.name.lowercased()
		return "No \(dataText) entries found. Are you sure you authorized this app to read \(dataText) data?"
	}

	public required init(sampleType: Sample.Type) {
		super.init(sampleType: sampleType)
	}
}

public final class UnauthorizedQueryError: QueryError {

	public final let sampleType: Sample.Type
	public final var displayableDescription: String {
		return "You must authorize this app to read \(sampleType.name.lowercased()) data"
	}

	public required init(sampleType: Sample.Type) {
		self.sampleType = sampleType
	}
}
