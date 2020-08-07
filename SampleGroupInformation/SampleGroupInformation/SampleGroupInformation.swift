//
//  SampleGroupInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

// sourcery: AutoMockable
public protocol SampleGroupInformation: CustomStringConvertible {
	var name: String { get }
	var startDate: Date? { get set }
	var endDate: Date? { get set }
	var attribute: Attribute { get set }
	var description: String { get } // include this here so that SwiftyMocky properly mocks it

	init(_ attribute: Attribute)

	func compute(forSamples samples: [Sample]) throws -> String
	func computeGraphable(forSamples samples: [Sample]) throws -> String
	func equalTo(_ other: SampleGroupInformation) -> Bool
}

// An abstract base class for everything that implements SampleGroupInformation
public class AnyInformation: SampleGroupInformation {
	private typealias Me = AnyInformation
	private static let log = Log()

	public var name: String {
		Me.log.error("Must override name")
		return ""
	}

	public var description: String {
		Me.log.error("Must override description")
		return ""
	}

	public final var attribute: Attribute

	public final var startDate: Date?
	public final var endDate: Date?

	public required init(_ attribute: Attribute) {
		self.attribute = attribute
	}

	public func compute(forSamples _: [Sample]) throws -> String {
		Me.log.error("Must override compute()")
		return ""
	}

	public func computeGraphable(forSamples _: [Sample]) throws -> String {
		Me.log.error("Must override computeGraphable()")
		return ""
	}

	public func equalTo(_ other: SampleGroupInformation) -> Bool {
		Me.log.error("Must override equalTo()")
		return type(of: self) == type(of: other)
	}

	func filterSamples<Type>(_ samples: [Sample], as _: Type.Type) throws -> [Sample] {
		let filteredSamples = injected(SampleUtil.self)
			.getOnly(samples: samples, from: startDate, to: endDate)
		return try filteredSamples.filter {
			do {
				let include = try $0.value(of: attribute) as? Type != nil
				if !include && !attribute.optional {
					Me.log.error(
						"Found nil value for non-optional attribute '%@' in %@ sample",
						attribute.name,
						$0.attributedName
					)
				}
				return include
			} catch {
				Me.log.error(
					"Failed to get value of '%@' for '%@' sample while filtering: %@",
					attribute.name,
					$0.attributedName,
					errorInfo(error)
				)
				throw error
			}
		}
	}
}
