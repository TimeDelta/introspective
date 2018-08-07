//
//  EarliestDateInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class OldestDateInformation: AnyInformation {

	public override var key: String { get { return "Oldest" } }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		if filteredSamples.count == 0 {
			return "No samples between given start and end dates"
		}

		var oldestSampleDate = try! filteredSamples[0].value(of: attribute) as! Date
		for sample in filteredSamples {
			let date = try! sample.value(of: attribute) as! Date
			if date.isBeforeDate(oldestSampleDate, granularity: .nanosecond) {
				oldestSampleDate = date
			}
		}
		return DependencyInjector.util.calendarUtil.string(for: oldestSampleDate)
	}
}
