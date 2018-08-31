//
//  ExtraInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol ExtraInformation {

	var key: String { get }
	var startDate: Date? { get set }
	var endDate: Date? { get set }
	var attribute: Attribute { get set }

	init(_ attribute: Attribute)

	func compute(forSamples: [Sample]) throws -> String
}

// An abstract base class for everything that implements ExtraInformation
public class AnyInformation: ExtraInformation {

	public var key: String { get { fatalError("Must override") } }
	public final var attribute: Attribute

	public final var startDate: Date?
	public final var endDate: Date?

	public required init(_ attribute: Attribute) {
		self.attribute = attribute
	}

	public func compute(forSamples: [Sample]) -> String {
		fatalError("Must override")
	}
}
