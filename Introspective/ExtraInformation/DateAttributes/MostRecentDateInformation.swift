//
//  MostRecentDateInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class MostRecentDateInformation: AnyInformation {

	private typealias Me = OldestDateInformation
	static let noSamplesMessage = "No samples between given start and end dates"

	public final override var name: String { return "Most Recent" }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sample.getOnly(samples: samples, from: startDate, to: endDate)
		if filteredSamples.count == 0 {
			return Me.noSamplesMessage
		}

		var mostRecentDate = try! filteredSamples[0].value(of: attribute) as! Date
		for sample in filteredSamples {
			let value = try! sample.value(of: attribute)
			if let date = value as? Date {
				if date.isAfterDate(mostRecentDate, granularity: .nanosecond) {
					mostRecentDate = date
				}
			} else if !attribute.optional || value != nil {
				os_log("non-optional attribute (%@) of sample (%@) returned %@", type: .error, attribute.name, sample.attributedName, String(describing: value))
			}
		}
		return DependencyInjector.util.calendar.string(for: mostRecentDate)
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is MostRecentDateInformation && attribute.equalTo(other.attribute)
	}
}
