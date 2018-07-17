//
//  SubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SubQueryMatcher: CustomStringConvertible {

	static var genericDescription: String { get }
	func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [SubQuerySampleType]) -> [QuerySampleType]
}
