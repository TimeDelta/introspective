//
//  MoodSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Samples

public final class MoodSampleFetcher: SampleFetcher {
	public let sampleTypePluralName = "Moods"

	public func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
		try injected(MoodDAO.self).getMoods(from: minDate, to: maxDate)
	}
}
