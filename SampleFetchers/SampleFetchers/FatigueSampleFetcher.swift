//
//  FatigueSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 12/9/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Samples

public final class FatigueSampleFetcher: SampleFetcher {
	public let sampleTypePluralName = "Fatigue"

	public func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
		try injected(FatigueDAO.self).getFatigueRecords(from: minDate, to: maxDate)
	}
}
