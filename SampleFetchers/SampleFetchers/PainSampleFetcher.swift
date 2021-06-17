//
//  PainSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 6/17/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Samples

public final class PainSampleFetcher: SampleFetcher {
	public let sampleTypePluralName = "Pains"

	public func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
		try injected(PainDAO.self).getPainRecords(from: minDate, to: maxDate)
	}
}
