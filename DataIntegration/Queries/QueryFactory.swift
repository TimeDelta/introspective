//
//  QueryFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol QueryFactory {
	func heartRateQuery() -> HeartRateQuery
	func queryFor<SampleType: Sample>(sampleType: SampleType.Type) throws -> SampleQuery<SampleType>
}

public class QueryFactoryImpl: QueryFactory {

	public enum Errors: Error {
		case UnknownSampleType
	}

	public func heartRateQuery() -> HeartRateQuery {
		return HeartRateQuery()
	}

	public func queryFor<SampleType: Sample>(sampleType: SampleType.Type) throws -> SampleQuery<SampleType> {
		if (sampleType == HeartRate.self) {
			return HeartRateQuery() as! SampleQuery<SampleType>
		}
		throw Errors.UnknownSampleType
	}
}
