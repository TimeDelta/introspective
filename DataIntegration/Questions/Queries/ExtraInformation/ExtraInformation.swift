//
//  ExtraInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum InformationType {
	case statistics
}

public protocol ExtraInformation {

	var informationType: InformationType { get }
	var key: String { get }
	var startDate: Date? { get set }
	var endDate: Date? { get set }


	func compute(forSamples: [Sample]) throws -> String
}

// An abstract base class for everything that implements ExtraInformation
public class SampleInformation<SampleType: Sample>: ExtraInformation {

	public enum Errors: Error {
		case typeMismatch
	}

	public var informationType: InformationType { get { fatalError("Must override") } }
	public var key: String { get { fatalError("Must override") } }

	public var startDate: Date?
	public var endDate: Date?

	public func compute(forSamples: [SampleType]) -> String {
		fatalError("Must override")
	}
}

extension SampleInformation {

	public func compute(forSamples samples: [Sample]) throws -> String {
		guard let typedSamples = samples as? [SampleType] else {
			throw Errors.typeMismatch
		}
		return compute(forSamples: typedSamples)
	}
}
