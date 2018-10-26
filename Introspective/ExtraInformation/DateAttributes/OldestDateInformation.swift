//
//  EarliestDateInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class OldestDateInformation: AnyInformation {

	private typealias Me = OldestDateInformation
	static let noSamplesMessage = "No samples between given start and end dates"

	public final override var name: String { return "Oldest" }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		if filteredSamples.count == 0 {
			return Me.noSamplesMessage
		}

		var oldestSampleDate = try! filteredSamples[0].value(of: attribute) as! Date
		for sample in filteredSamples {
			let value = try! sample.value(of: attribute)
			if let date = value as? Date {
				if date.isBeforeDate(oldestSampleDate, granularity: .nanosecond) {
					oldestSampleDate = date
				}
			} else if !attribute.optional || value != nil {
				os_log("non-optional attribute (%@) of sample (%@) returned %@", type: .error, attribute.name, sample.attributedName, String(describing: value))
			}
		}
		return DependencyInjector.util.calendarUtil.string(for: oldestSampleDate)
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is OldestDateInformation && attribute.equalTo(other.attribute)
	}
}
