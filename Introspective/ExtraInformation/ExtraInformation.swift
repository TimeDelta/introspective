//
//  ExtraInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol ExtraInformation: CustomStringConvertible {

	var name: String { get }
	var startDate: Date? { get set }
	var endDate: Date? { get set }
	var attribute: Attribute { get set }
	var description: String { get } // include this here so that SwiftyMocky properly mocks it

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

	public func compute(forSamples samples: [Sample]) throws -> String {
		log.error("Must override compute()")
		return ""
	}
	public func computeGraphable(forSamples samples: [Sample]) throws -> String {
		log.error("Must override computeGraphable()")
		return ""
	}

	public func equalTo(_ other: ExtraInformation) -> Bool {
		log.error("Must override equalTo()")
		return type(of: self) == type(of: other)
	}

	func filterSamples<Type>(_ samples: [Sample], as: Type.Type) throws -> [Sample] {
		let filteredSamples = DependencyInjector.util.sample.getOnly(samples: samples, from: startDate, to: endDate)
		return try filteredSamples.filter{
			do {
				let include = try $0.value(of: attribute) as? Type != nil
				if !include && !attribute.optional {
					log.error("Found nil value for non-optional attribute '%@' in %@ sample", attribute.name, $0.attributedName)
				}
				return include
			} catch {
				log.error(
					"Failed to get value of '%@' for '%@' sample while filtering: %@",
					attribute.name,
					$0.attributedName,
					errorInfo(error))
				throw error
			}
		}
	}
}
