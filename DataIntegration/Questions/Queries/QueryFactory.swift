//
//  QueryFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class QueryFactory: NSObject {

	public enum Errors: Error {
		case UnknownSampleType
	}

	public func heartRateQuery() -> HeartRateQuery {
		return HeartRateQuery()
	}

	public func queryFor<SampleType: Sample>(sampleType: SampleType.Type) throws -> Query<SampleType> {
		if (sampleType == HeartRate.self) {
			return Query<HeartRate>(HeartRateQuery()) as! Query<SampleType>
		}
		throw Errors.UnknownSampleType
	}
}
