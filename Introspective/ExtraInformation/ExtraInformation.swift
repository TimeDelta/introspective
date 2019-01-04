//
//  ExtraInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

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
			os_log("Must override name", type: .error)
			return ""
		}
	}
	public var description: String {
		get {
			os_log("Must override description", type: .error)
			return ""
		}
	}
	public final var attribute: Attribute

	public final var startDate: Date?
	public final var endDate: Date?

	public required init(_ attribute: Attribute) {
		self.attribute = attribute
	}

	public func compute(forSamples samples: [Sample]) -> String {
		os_log("Must override compute()", type: .error)
		return ""
	}
	public func computeGraphable(forSamples samples: [Sample]) -> String {
		os_log("Must override computeGraphable()", type: .error)
		return ""
	}

	public func equalTo(_ other: ExtraInformation) -> Bool {
		os_log("Must override equalTo()", type: .error)
		return type(of: self) == type(of: other)
	}
}
