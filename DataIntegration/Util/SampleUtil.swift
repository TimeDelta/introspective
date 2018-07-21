//
//  SampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SampleUtil {

	// need this because for some stupid reason, protocols don't conform to themselves
	public func getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?) -> [Sample] {
		return getOnly(samples, startDate, endDate)
	}

	public func getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?) -> [SampleType] {
		return getOnly(samples, startDate, endDate) as! [SampleType]
	}

	/// Does the specified `HKSample` have any time overlap with any of the given days of the week?
	/// - Returns: `true` if the specified sample overlaps with one of the specifed days of the week or if the given `Set<DayOfWeek>` is empty, otherwise `false`.
	public func sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>) -> Bool {
		if !daysOfWeek.isEmpty {
			let startDate = sample.dates[.start]!
			let calendar = Calendar.current
			let startSampleDayOfWeek = calendar.component(.weekday, from: startDate)

			var endSampleDayOfWeek: Int?
			if sample.dates[.end] != nil {
				endSampleDayOfWeek = calendar.component(.weekday, from: sample.dates[.end]!)
			}
			for dayOfWeek in daysOfWeek {
				if startSampleDayOfWeek == dayOfWeek.intValue {
					return true
				}
				if endSampleDayOfWeek != nil && endSampleDayOfWeek! == dayOfWeek.intValue {
					return true
				}
			}
			return false
		}
		return true
	}

	// need this because for some stupid reason, protocols don't conform to themselves
	public func aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, dateType: DateType = .start) -> [Date: [Sample]] {
		return aggregate(samples, aggregationUnit, dateType)
	}

	public func aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, dateType: DateType = .start) -> [Date: [SampleType]] {
		return aggregate(samples, aggregationUnit, dateType) as! [Date: [SampleType]]
	}

	// need this because for some stupid reason, protocols don't conform to themselves
	public func sort(samples: [Sample], by aggregationUnit: Calendar.Component) -> [(date: Date, samples: [Sample])] {
		let samplesByAggregation = aggregate(samples: samples, by: aggregationUnit)
		let sortedSamplesByAggregation = samplesByAggregation.sorted { (entry1: (key: Date, value: [Sample]), entry2: (key: Date, value: [Sample])) -> Bool in
			return entry1.key.compare(entry2.key) == ComparisonResult.orderedAscending
		}
		return sortedSamplesByAggregation.map({ (entry: (key: Date, value: [Sample])) -> (date: Date, samples: [Sample]) in
			return (date: entry.key, samples: entry.value)
		})
	}

	public func sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component) -> [(date: Date, samples: [SampleType])] {
		let samplesByAggregation = aggregate(samples: samples, by: aggregationUnit)
		let sortedSamplesByAggregation = samplesByAggregation.sorted { (entry1: (key: Date, value: [SampleType]), entry2: (key: Date, value: [SampleType])) -> Bool in
			return entry1.key.compare(entry2.key) == ComparisonResult.orderedAscending
		}
		return sortedSamplesByAggregation.map({ (entry: (key: Date, value: [SampleType])) -> (date: Date, samples: [SampleType]) in
			return (date: entry.key, samples: entry.value)
		})
	}

	// need this because for some stupid reason, protocols don't conform to themselves
	/// - Note: behavior is undefined when passing `ComparisonResult.orderedSame`
	public func sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult = .orderedAscending) -> [Sample] {
		return sort(samples, dateType, order)
	}

	/// - Note: behavior is undefined when passing `ComparisonResult.orderedSame`
	public func sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType, in order: ComparisonResult = .orderedAscending) -> [SampleType] {
		return sort(samples, dateType, order) as! [SampleType]
	}

	// need this because for some stupid reason, protocols don't conform to themselves
	public func convertOneDateSamplesToTwoDateSamples(
		_ samples: [Sample],
		samplesShouldNotBeJoined: (Sample, Sample) -> Bool,
		joinSamples: ([Sample], Date, Date) -> Sample)
	-> [Sample] {
		let sortedSamples = sort(samples: samples, by: .start)
		var twoDateSamples = [Sample]()
		var lastSample: Sample? = nil
		var start: Date = Date() // have to initialize this here to make the compiler happy even though it would still always be initialized before getting used even without this
		var end: Date
		var samplesToJoin = [Sample]()
		for sample in sortedSamples {
			if lastSample == nil {
				start = sample.dates[.start]!
			} else if samplesShouldNotBeJoined(lastSample!, sample) {
				end = lastSample!.dates[.start]!
				let twoDateSample = joinSamples(samplesToJoin, start, end)
				twoDateSamples.append(twoDateSample)
				start = sample.dates[.start]!
				samplesToJoin = [Sample]()
			}
			samplesToJoin.append(sample)
			lastSample = sample
		}
		return twoDateSamples
	}

	public func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(
		_ samples: [SampleType],
		samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool,
		joinSamples: ([SampleType], Date, Date) -> SampleType)
	-> [SampleType] {
		let sortedSamples = sort(samples: samples, by: .start)
		var twoDateSamples = [SampleType]()
		var lastSample: SampleType? = nil
		var start: Date = Date() // have to initialize this here to make the compiler happy even though it would still always be initialized before getting used even without this
		var end: Date
		var samplesToJoin = [SampleType]()
		for sample in sortedSamples {
			if lastSample == nil {
				start = sample.dates[.start]!
			} else if samplesShouldNotBeJoined(lastSample!, sample) {
				end = lastSample!.dates[.start]!
				let twoDateSample = joinSamples(samplesToJoin, start, end)
				twoDateSamples.append(twoDateSample)
				start = sample.dates[.start]!
				samplesToJoin = [SampleType]()
			}
			samplesToJoin.append(sample)
			lastSample = sample
		}
		return twoDateSamples
	}

	/// - Precondition: input array has at least one element.
	public func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: SampleType1, in samples: [SampleType2]) -> SampleType2 {
		assert(samples.count > 0, "Precondition violated: input array must have at least one element")

		return DependencyInjector.util.searchUtil.closestItem(to: sample, in: samples) { (sample1: Sample, sample2: Sample) -> Int in
			return distance(between: sample1, and: sample2)
		} as! SampleType2
	}

	public func distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component = .nanosecond) -> Int {
		let start1 = sample1.dates[.start]!
		let start2 = sample2.dates[.start]!
		let end1 = sample2.dates[.end]
		let end2 = sample2.dates[.end]

		var closestDistance: Int = distance(start1, start2, unit)
		if end1 != nil {
			let end1ToStart2 = distance(end1!, start2, unit)
			closestDistance = min(closestDistance, end1ToStart2)
		}
		if end2 != nil {
			let start1ToEnd2 = distance(start1, end2!, unit)
			closestDistance = min(closestDistance, start1ToEnd2)
		}
		if end1 != nil && end2 != nil {
			let end1ToEnd2 = distance(end1!, end2!, unit)
			closestDistance = min(closestDistance, end1ToEnd2)
		}
		return closestDistance
	}

	fileprivate func getOnly(_ samples: [Sample], _ startDate: Date?, _ endDate: Date?) -> [Sample] {
		var filteredSamples = samples
		if startDate != nil {
			filteredSamples = filteredSamples.filter { (sample: Sample) -> Bool in
				return sample.dates[.start]!.isAfterDate(startDate!, granularity: .nanosecond)
			}
		}
		if endDate != nil {
			filteredSamples = filteredSamples.filter { (sample: Sample) -> Bool in
				var date = sample.dates[.start]!
				if sample.dates[.end] != nil {
					date = sample.dates[.end]!
				}
				return date.isAfterDate(endDate!, granularity: .nanosecond)
			}
		}
		return filteredSamples
	}

	fileprivate func aggregate(_ samples: [Sample], _ aggregationUnit: Calendar.Component, _ dateType: DateType = .start) -> [Date: [Sample]] {
		var samplesByAggregation = [Date: [Sample]]()
		for sample in samples {
			let date = sample.dates[dateType]
			if date != nil {
				let aggregationDate = DependencyInjector.util.calendarUtil.start(of: aggregationUnit, in: date!)
				var samplesForAggregationDate = samplesByAggregation[aggregationDate]
				if samplesForAggregationDate == nil {
					samplesForAggregationDate = [Sample]()
				}
				samplesForAggregationDate!.append(sample)
				samplesByAggregation[aggregationDate] = samplesForAggregationDate
			}
		}
		return samplesByAggregation
	}

	fileprivate func sort(_ samples: [Sample], _ dateType: DateType, _ order: ComparisonResult = .orderedAscending) -> [Sample] {
		return samples.sorted(by: { (sample1: Sample, sample2: Sample) -> Bool in
			let date1 = sample1.dates[dateType]
			let date2 = sample2.dates[dateType]

			return DependencyInjector.util.calendarUtil.compare(date1, date2) == order
		})
	}

	fileprivate func distance(_ date1: Date, _ date2: Date, _ unit: Calendar.Component) -> Int {
		return Calendar.current.dateComponents([unit], from: date1, to: date2).in(unit)!
	}
}