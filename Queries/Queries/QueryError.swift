//
//  QueryError.swift
//  Introspective
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import Samples

public protocol QueryError: DisplayableError {

	var sampleType: Sample.Type { get }

	init(sampleType: Sample.Type)
}

public class NoSamplesFoundQueryError: QueryError {

	public final let sampleType: Sample.Type
	public final let displayableTitle: String
	public var displayableDescription: String? { return "" }
	public final var localizedDescription: String {
		var text = displayableTitle
		if let description = displayableDescription {
			text += ": \(description)"
		}
		return text
	}

	public required init(sampleType: Sample.Type) {
		self.sampleType = sampleType
		displayableTitle =  "No \(sampleType.name.lowercased()) entries found."
	}
}

public final class NoHealthKitSamplesFoundQueryError: NoSamplesFoundQueryError {

	public final override var displayableDescription: String? {
		return "Are you sure you authorized this app to read \(sampleType.name.lowercased()) data?"
	}

	public required init(sampleType: Sample.Type) {
		super.init(sampleType: sampleType)
	}
}
