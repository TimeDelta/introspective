//
//  UnaccountedForTimeMetaDataCalculator.swift
//  MetaData
//
//  Created by Bryan Nova on 8/4/21.
//

import Foundation

import Common
import DependencyInjection
import SampleFetchers
import Samples

public protocol UnaccountedForTimeMetaDataCalculator {
	func calculate(from startDate: Date, to endDate: Date) throws -> TimeDuration
}

public final class UnaccountedForTimeMetaDataCalculatorImpl: UnaccountedForTimeMetaDataCalculator {
	private struct DatePair {
		var start: Date
		var end: Date

		init(_ start: Date, _ end: Date) {
			self.start = start
			self.end = end
		}
	}

	public func calculate(from startDate: Date, to endDate: Date) throws -> TimeDuration {
		var allTwoDateSamples = [Sample]()
		let sleepFetcher = injected(SampleFetcherFactory.self).sleepSampleFetcher()
		allTwoDateSamples.append(contentsOf: try sleepFetcher.getSamples(from: startDate, to: endDate))
		let activitiesFetcher = injected(SampleFetcherFactory.self).activitySampleFetcher()
		allTwoDateSamples.append(contentsOf: try activitiesFetcher.getSamples(from: startDate, to: endDate))

		guard allTwoDateSamples.count > 0 else {
			return TimeDuration(start: startDate, end: endDate)
		}

		let mergedDatePairs = merge(allTwoDateSamples)
		var unaccountedTimePeriods = [DatePair]()
		for i in 0 ..< mergedDatePairs.count {
			var unaccountedStart: Date
			if i == 0 {
				unaccountedStart = startDate
			} else {
				unaccountedStart = mergedDatePairs[i].end
			}

			var unaccountedEnd: Date!
			if i == mergedDatePairs.count - 1 {
				unaccountedEnd = endDate
			} else {
				unaccountedEnd = mergedDatePairs[i + 1].start
			}
			unaccountedTimePeriods.append(DatePair(unaccountedStart, unaccountedEnd))
		}
		let lastEnd = mergedDatePairs[mergedDatePairs.count - 1].end
		if lastEnd < endDate {
			unaccountedTimePeriods.append(DatePair(lastEnd, endDate))
		}

		var totalDuration: TimeDuration = TimeDuration(0)
		for timePeriod in unaccountedTimePeriods {
			totalDuration += TimeDuration(start: timePeriod.end, end: timePeriod.start)
		}
		return totalDuration
	}

	/// Merge any overlapping samples into single start / end date pairs and convert any lone (non-contiguous-to-others) samples to date pairs.
	private func merge(_ allTwoDateSamples: [Sample]) -> [DatePair] {
		var finalDatePairs = [DatePair]()
		var currentMergeStartDate: Date?
		var currentMergeEndDate: Date?
		for sample in injected(SampleUtil.self).sort(samples: allTwoDateSamples, by: .start, in: .orderedAscending) {
			if currentMergeStartDate == nil {
				currentMergeStartDate = sample.dates()[.start]
			}
			if let nonNilCurrentMergeEndDate = currentMergeEndDate {
				let newStartDate = sample.dates()[.start]! // everything must have a start date
				guard let newEndDate = sample.dates()[.end] else {
					continue
				}
				if currentMergeStartDate! <= newStartDate && newStartDate <= nonNilCurrentMergeEndDate &&
					nonNilCurrentMergeEndDate < newEndDate {
					currentMergeEndDate = newEndDate
				} else {
					let datePair = DatePair(currentMergeStartDate!, nonNilCurrentMergeEndDate)
					currentMergeStartDate = nil
					currentMergeEndDate = nil
					finalDatePairs.append(datePair)
				}
			} else {
				currentMergeEndDate = sample.dates()[.end]
			}
		}
		return finalDatePairs
	}
}
