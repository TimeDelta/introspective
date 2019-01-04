//
//  ExtraInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol ExtraInformation: CustomStringConvertible {

	var name: String { get }
	var startDate: Date? { get set }
	var endDate: Date? { get set }
	var attribute: Attribute { get set }

	init(_ attribute: Attribute)

	func compute(forSamples samples: [Sample]) throws -> String
	func computeGraphable(forSamples samples: [Sample]) throws -> String
	func equalTo(_ other: ExtraInformation) -> Bool
}

// An abstract base class for everything that implements ExtraInformation
public class AnyInformation: ExtraInformation {

	public var name: String {
		get {
			log.error("Must override name")
			return ""
		}
	}
	public var description: String {
		get {
			log.error("Must override description")
			return ""
		}
	}
	public final var attribute: Attribute

	public final var startDate: Date?
	public final var endDate: Date?

	private final let log = Log()

	public required init(_ attribute: Attribute) {
		self.attribute = attribute
	}

	public func compute(forSamples samples: [Sample]) -> String {
		log.error("Must override compute()")
		return ""
	}
	public func computeGraphable(forSamples samples: [Sample]) -> String {
		log.error("Must override computeGraphable()")
		return ""
	}

	public func equalTo(_ other: ExtraInformation) -> Bool {
		log.error("Must override equalTo()")
		return type(of: self) == type(of: other)
	}
}
