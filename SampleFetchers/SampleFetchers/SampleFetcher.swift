//
//  SampleFetcher.swift
//  Samples
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

public protocol SampleFetcher {
	var sampleTypePluralName: String { get }

	func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample]
}
