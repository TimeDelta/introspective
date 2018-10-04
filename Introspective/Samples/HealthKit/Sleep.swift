//
//  Sleep.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import os

public final class Sleep: HealthKitCategorySample {

	private typealias Me = Sleep

	public enum State: CustomStringConvertible {
		case awake
		case inBed
		case asleep

		public static var allValues: [State] = [awake, inBed, asleep]

		public var description: String {
			switch (self) {
				case .awake: return "Awake"
				case .inBed: return "In bed"
				case .asleep: return "Asleep"
			}
		}

		public var rawValue: Int {
			switch (self) {
				case .awake: return HKCategoryValueSleepAnalysis.awake.rawValue
				case .inBed: return HKCategoryValueSleepAnalysis.inBed.rawValue
				case .asleep: return HKCategoryValueSleepAnalysis.asleep.rawValue
			}
		}
	}

	// MARK: - HealthKit Stuff

	public static let categoryType: HKCategoryType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
	public static let sampleType: HKSampleType = categoryType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])

	// MARK: - Display Information

	public static let name: String = "Sleep"
	public static let description: String = ""

	// MARK: - Attributes

	public static let state = TypedSelectOneAttribute<State>(
		name: "Waking state",
		variableName: HKPredicateKeyPathCategoryValue,
		possibleValues: State.allValues,
		possibleValueToString: { $0.description },
		areEqual: { $0 == $1 })
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitStartDate, CommonSampleAttributes.healthKitEndDate, state]
	public static let defaultDependentAttribute: Attribute = state
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitStartDate
	public final var attributes: [Attribute] { return Me.attributes }

	// MARK: - Instance Member Variables

	public final var name: String = Me.name
	public final var description: String = Me.description
	public final var startDate: Date
	public final var endDate: Date
	public final var state: State

	// MARK: - Initializers

	public init(_ state: State = .awake, startDate: Date = Date(), endDate: Date = Date()) {
		self.startDate = startDate
		self.endDate = endDate
		self.state = state
	}

	public required init(_ sample: HKCategorySample) {
		switch (sample.value) {
			case HKCategoryValueSleepAnalysis.awake.rawValue:
				state = .awake
				break
			case HKCategoryValueSleepAnalysis.inBed.rawValue:
				state = .inBed
				break
			case HKCategoryValueSleepAnalysis.asleep.rawValue:
				state = .asleep
				break
			default:
				os_log("Unknown state: %d", type: .error, sample.value)
				state = .awake
				break
		}
		startDate = sample.startDate
		endDate = sample.endDate
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		return HKCategorySample(type: Me.categoryType, value: state.rawValue, start: startDate, end: endDate, metadata: nil)
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: startDate, .end: endDate]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.state) {
			return state
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) {
			return startDate
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) {
			return endDate
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(Me.state) {
			guard let castedValue = value as? State else { throw AttributeError.typeMismatch }
			state = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			startDate = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			endDate = castedValue
			return
		}
		throw AttributeError.unknownAttribute
	}
}

// MARK: - Equatable

extension Sleep: Equatable {

	public static func ==(lhs: Sleep, rhs: Sleep) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Sleep) { return false }
		let other = otherAttributed as! Sleep
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Sleep) { return false }
		let other = otherSample as! Sleep
		return equalTo(other)
	}

	public final func equalTo(_ other: Sleep) -> Bool {
		return startDate == other.startDate && state == other.state
	}
}

// MARK: - Debug

extension Sleep: CustomDebugStringConvertible {

	public final var debugDescription: String {
		return "Sleep with state \(state) from " + DependencyInjector.util.calendarUtil.string(for: startDate) + " to " + DependencyInjector.util.calendarUtil.string(for: endDate)
	}
}
