//
//  MedicationDoseSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Samples

public final class MedicationDoseSampleFetcher: SampleFetcher {
	public let sampleTypePluralName = "Medication Doses"

	public func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
		try fetchOnMainQueue { try injected(MedicationDAO.self).getMedicationDoses(from: minDate, to: maxDate) }
	}
}
