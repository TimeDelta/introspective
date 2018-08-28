//
//  MostRecentDateInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class MostRecentDateInformation: AnyInformation {

	fileprivate typealias Me = OldestDateInformation
	static let noSamplesMessage = "No samples between given start and end dates"

	public override var key: String { get { return "Most Recent" } }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		if filteredSamples.count == 0 {
			return Me.noSamplesMessage
		}

		var mostRecentDate = try! filteredSamples[0].value(of: attribute) as! Date
		for sample in filteredSamples {
			let date = try! sample.value(of: attribute) as! Date
			if date.isAfterDate(mostRecentDate, granularity: .nanosecond) {
				mostRecentDate = date
			}
		}
		return DependencyInjector.util.calendarUtil.string(for: mostRecentDate)
	}
}
