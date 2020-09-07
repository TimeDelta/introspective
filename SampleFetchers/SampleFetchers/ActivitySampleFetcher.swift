//
//  ActivitySampleFetcher.swift
//  Samples
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Samples

public final class ActivitySampleFetcher: SampleFetcher {
	public let sampleTypePluralName = "Activities"

	public func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
		try injected(ActivityDAO.self).getActivities(from: minDate, to: maxDate)
	}
}
