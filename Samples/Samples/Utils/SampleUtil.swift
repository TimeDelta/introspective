//
//  SampleUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

import Attributes
import Common
import DependencyInjection

// sourcery: AutoMockable
public protocol SampleUtil {
	func getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?) -> [Sample]
	func getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?) -> [SampleType]
	func sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>) -> Bool
	func aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, for attribute: Attribute)
		throws -> [Date: [Sample]]
	func aggregate<SampleType: Sample>(
		samples: [SampleType],
		by aggregationUnit: Calendar.Component,
		for attribute: Attribute
	)
		throws -> [Date: [SampleType]]
	func sort(samples: [Sample], by aggregationUnit: Calendar.Component)
		throws -> [(date: Date, samples: [Sample])]
	func sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component)
		throws -> [(date: Date, samples: [SampleType])]
	/// - Note: behavior is undefined when passing `ComparisonResult.orderedSame`
	func sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult) -> [Sample]
	/// - Note: behavior is undefined when passing `ComparisonResult.orderedSame`
	func sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType, in order: ComparisonResult)
		-> [SampleType]
	func convertOneDateSamplesToTwoDateSamples(
		_ samples: [Sample],
		samplesShouldNotBeJoined: (Sample, Sample) -> Bool,
		joinSamples: ([Sample], Date, Date) -> Sample
	) -> [Sample]
	func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(
		_ samples: [SampleType],
		samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool,
		joinSamples: ([SampleType], Date, Date) -> SampleType
	) -> [SampleType]
	/// - Precondition: input array has at least one element.
	func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: SampleType1, in samples: [SampleType2])
		-> SampleType2
	/// - Precondition: input array has at least one element.
	func closestInTimeTo(sample: Sample, in samples: [Sample]) -> Sample
	/// Get the shortest distance between two samples in the specified calendar unit.
	/// This will look at the distance between all 4 possible combinations of start and
	/// end dates for the given samples then choose the lowest interval of time.
	func distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component) -> Int
}

public extension SampleUtil {
	func sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult = .orderedAscending) -> [Sample] {
		sort(samples: samples, by: dateType, in: order)
	}

	func sort<SampleType: Sample>(
		samples: [SampleType],
		by dateType: DateType,
		in order: ComparisonResult = .orderedAscending
	) -> [SampleType] {
		sort(samples: samples, by: dateType, in: order)
	}

	func distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component = .nanosecond) -> Int {
		distance(between: sample1, and: sample2, in: unit)
	}
}

public final class SampleUtilImpl: SampleUtil {
	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SampleUtil"))

	// need this because protocols don't conform to themselves
	public final func getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?) -> [Sample] {
		getOnly(samples, startDate, endDate)
	}

	public final func getOnly<SampleType: Sample>(
		samples: [SampleType],
		from startDate: Date?,
		to endDate: Date?
	) -> [SampleType] {
		getOnly(samples, startDate, endDate) as! [SampleType]
	}

	/// Does the specified `HKSample` have any time overlap with any of the given days of the week?
	/// - Returns: `true` if the specified sample overlaps with one of the specifed days of the week or if the given `Set<DayOfWeek>` is empty, otherwise `false`.
	public final func sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>) -> Bool {
		if !daysOfWeek.isEmpty {
			let startDate = sample.dates()[.start]!
			if DependencyInjector.get(CalendarUtil.self).date(startDate, isOnOneOf: daysOfWeek) {
				return true
			}
			let endDate = sample.dates()[.end]
			if let endDate = endDate {
				return DependencyInjector.get(CalendarUtil.self).date(endDate, isOnOneOf: daysOfWeek)
			}
			return false
		}
		return true
	}

	// need this because protocols don't conform to themselves
	public final func aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, for attribute: Attribute)
		throws -> [Date: [Sample]] {
		try aggregate(samples, aggregationUnit, attribute)
	}

	public final func aggregate<SampleType: Sample>(
		samples: [SampleType],
		by aggregationUnit: Calendar.Component,
		for attribute: Attribute
	)
		throws -> [Date: [SampleType]] {
		try aggregate(samples, aggregationUnit, attribute) as! [Date: [SampleType]]
	}

	// need this because for some stupid reason, protocols don't conform to themselves
	public final func sort(
		samples: [Sample],
		by aggregationUnit: Calendar.Component
	) throws -> [(date: Date, samples: [Sample])] {
		let samplesByAggregation = try aggregate(
			samples: samples,
			by: aggregationUnit,
			for: CommonSampleAttributes.startDate
		)
		let sortedSamplesByAggregation = samplesByAggregation
			.sorted { (entry1: (key: Date, value: [Sample]), entry2: (key: Date, value: [Sample])) -> Bool in
				entry1.key.compare(entry2.key) == ComparisonResult.orderedAscending
			}
		return sortedSamplesByAggregation
			.map { (entry: (key: Date, value: [Sample])) -> (date: Date, samples: [Sample]) in
				(date: entry.key, samples: entry.value)
			}
	}

	public final func sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component)
		throws -> [(date: Date, samples: [SampleType])] {
		let samplesByAggregation = try aggregate(
			samples: samples,
			by: aggregationUnit,
			for: CommonSampleAttributes.startDate
		)
		let sortedSamplesByAggregation = samplesByAggregation
			.sorted { (entry1: (key: Date, value: [SampleType]), entry2: (key: Date, value: [SampleType])) -> Bool in
				entry1.key.compare(entry2.key) == ComparisonResult.orderedAscending
			}
		return sortedSamplesByAggregation
			.map { (entry: (key: Date, value: [SampleType])) -> (date: Date, samples: [SampleType]) in
				(date: entry.key, samples: entry.value)
			}
	}

	// need this because protocols don't conform to themselves
	/// - Note: behavior is undefined when passing `ComparisonResult.orderedSame`
	public final func sort(
		samples: [Sample],
		by dateType: DateType,
		in order: ComparisonResult = .orderedAscending
	) -> [Sample] {
		sort(samples, dateType, order)
	}

	/// - Note: behavior is undefined when passing `ComparisonResult.orderedSame`
	public final func sort<SampleType: Sample>(
		samples: [SampleType],
		by dateType: DateType,
		in order: ComparisonResult = .orderedAscending
	) -> [SampleType] {
		sort(samples, dateType, order) as! [SampleType]
	}

	// need this because protocols don't conform to themselves
	public final func convertOneDateSamplesToTwoDateSamples(
		_ samples: [Sample],
		samplesShouldNotBeJoined: (Sample, Sample) -> Bool,
		joinSamples: ([Sample], Date, Date) -> Sample
	)
		-> [Sample] {
		let sortedSamples = sort(samples: samples, by: .start)
		var twoDateSamples = [Sample]()
		var lastSample: Sample?
		var start: Date =
			Date() // have to initialize this here to make the compiler happy even though it would still always be initialized before getting used even without this
		var end: Date
		var samplesToJoin = [Sample]()
		var samplesJoined = false
		for sample in sortedSamples {
			samplesJoined = false
			if lastSample == nil {
				start = sample.dates()[.start]!
			} else if samplesShouldNotBeJoined(lastSample!, sample) {
				end = lastSample!.dates()[.start]!
				let twoDateSample = joinSamples(samplesToJoin, start, end)
				twoDateSamples.append(twoDateSample)
				start = sample.dates()[.start]!
				samplesToJoin = [Sample]()
				samplesJoined = true
			}
			samplesToJoin.append(sample)
			lastSample = sample
		}
		if !sortedSamples.isEmpty && samplesJoined == samplesShouldNotBeJoined(lastSample!, sortedSamples.last!) {
			end = sortedSamples.last!.dates()[.start]!
			let twoDateSample = joinSamples(samplesToJoin, start, end)
			twoDateSamples.append(twoDateSample)
		}
		return twoDateSamples
	}

	public final func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(
		_ samples: [SampleType],
		samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool,
		joinSamples: ([SampleType], Date, Date) -> SampleType
	)
		-> [SampleType] {
		let sortedSamples = sort(samples: samples, by: .start)
		var twoDateSamples = [SampleType]()
		var lastSample: SampleType?
		var start: Date =
			Date() // have to initialize this here to make the compiler happy even though it would still always be initialized before getting used even without this
		var end: Date
		var samplesToJoin = [SampleType]()
		var samplesJoined = false
		for sample in sortedSamples {
			samplesJoined = false
			if lastSample == nil {
				start = sample.dates()[.start]!
			} else if samplesShouldNotBeJoined(lastSample!, sample) {
				end = lastSample!.dates()[.start]!
				let twoDateSample = joinSamples(samplesToJoin, start, end)
				twoDateSamples.append(twoDateSample)
				start = sample.dates()[.start]!
				samplesToJoin = [SampleType]()
				samplesJoined = true
			}
			samplesToJoin.append(sample)
			lastSample = sample
		}
		if !sortedSamples.isEmpty && samplesJoined == samplesShouldNotBeJoined(lastSample!, sortedSamples.last!) {
			end = sortedSamples.last!.dates()[.start]!
			let twoDateSample = joinSamples(samplesToJoin, start, end)
			twoDateSamples.append(twoDateSample)
		}
		return twoDateSamples
	}

	/// - Precondition: input array has at least one element.
	public final func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(
		sample: SampleType1,
		in samples: [SampleType2]
	) -> SampleType2 {
		precondition(!samples.isEmpty, "Precondition violated: input array must have at least one element")

		return DependencyInjector.get(SearchUtil.self)
			.closestItem(to: sample, in: samples) { (sample1: Sample, sample2: Sample) -> Int in
				abs(distance(between: sample1, and: sample2))
			} as! SampleType2
	}

	/// - Precondition: input array has at least one element.
	public final func closestInTimeTo(sample: Sample, in samples: [Sample]) -> Sample {
		precondition(!samples.isEmpty, "Precondition violated: input array must have at least one element")

		return DependencyInjector.get(SearchUtil.self)
			.closestItem(to: sample, in: samples) { (sample1: Sample, sample2: Sample) -> Int in
				abs(distance(between: sample1, and: sample2))
			}
	}

	public final func distance(
		between sample1: Sample,
		and sample2: Sample,
		in unit: Calendar.Component = .nanosecond
	) -> Int {
		let start1 = sample1.dates()[.start]!
		let start2 = sample2.dates()[.start]!
		let end1 = sample1.dates()[.end]
		let end2 = sample2.dates()[.end]

		var closestDistance: Int = distance(start1, start2, unit)
		if let end1 = end1 {
			let end1ToStart2 = distance(end1, start2, unit)
			closestDistance = min(closestDistance, end1ToStart2)
		}
		if let end2 = end2 {
			let start1ToEnd2 = distance(start1, end2, unit)
			closestDistance = min(closestDistance, start1ToEnd2)
		}
		if let end1 = end1, let end2 = end2 {
			let end1ToEnd2 = distance(end1, end2, unit)
			closestDistance = min(closestDistance, end1ToEnd2)
		}
		return closestDistance
	}

	private final func getOnly(_ samples: [Sample], _ startDate: Date?, _ endDate: Date?) -> [Sample] {
		var filteredSamples = samples
		if let startDate = startDate {
			filteredSamples = filteredSamples.filter { (sample: Sample) -> Bool in
				sample.dates()[.start]!.isAfterDate(startDate, granularity: .nanosecond)
			}
		}
		if let endDate = endDate {
			filteredSamples = filteredSamples.filter { (sample: Sample) -> Bool in
				var date = sample.dates()[.start]!
				if let end = sample.dates()[.end] {
					date = end
				}
				return date.isBeforeDate(endDate, granularity: .nanosecond)
			}
		}
		return filteredSamples
	}

	private final func aggregate(
		_ samples: [Sample],
		_ aggregationUnit: Calendar.Component,
		_ attribute: Attribute
	) throws -> [Date: [Sample]] {
		let samplesWithSpecifiedDateAttribute = try samples.filter { try $0.value(of: attribute) != nil }
		return try Dictionary(grouping: samplesWithSpecifiedDateAttribute, by: { sample in
			let value = try sample.value(of: attribute)
			guard let date = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: value))
			}
			return DependencyInjector.get(CalendarUtil.self).start(of: aggregationUnit, in: date)
		})
	}

	private final func sort(
		_ samples: [Sample],
		_ dateType: DateType,
		_ order: ComparisonResult = .orderedAscending
	) -> [Sample] {
		samples.sorted(by: { (sample1: Sample, sample2: Sample) -> Bool in
			let date1 = sample1.dates()[dateType]
			let date2 = sample2.dates()[dateType]

			return DependencyInjector.get(CalendarUtil.self).compare(date1, date2) == order
		})
	}

	private final func distance(_ date1: Date, _ date2: Date, _ unit: Calendar.Component) -> Int {
		abs(Calendar.autoupdatingCurrent.dateComponents([unit], from: date1, to: date2).in(unit)!)
	}
}
