//
//  Sleep.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import SwiftDate

import Attributes
import Common
import DependencyInjection

public final class Sleep: HealthKitCategorySample, SearchableSample {
	private typealias Me = Sleep

	private static let log = Log()

	public enum State: Equatable, CustomStringConvertible {
		case awake
		case inBed
		case asleep
		case asleepCore
		case asleepDeep
		case asleepREM
		case unknown(Int)

		// Keep the original positions: stored query selections use these indexes.
		public static var allValues: [State] = [awake, inBed, asleep, asleepCore, asleepDeep, asleepREM]

		public init(rawValue: Int) {
			switch rawValue {
			case HKCategoryValueSleepAnalysis.awake.rawValue: self = .awake
			case HKCategoryValueSleepAnalysis.inBed.rawValue: self = .inBed
			case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue: self = .asleep
			case HKCategoryValueSleepAnalysis.asleepCore.rawValue: self = .asleepCore
			case HKCategoryValueSleepAnalysis.asleepDeep.rawValue: self = .asleepDeep
			case HKCategoryValueSleepAnalysis.asleepREM.rawValue: self = .asleepREM
			default: self = .unknown(rawValue)
			}
		}

		public var description: String {
			switch self {
			case .awake: return "Awake"
			case .inBed: return "In bed"
			case .asleep: return "Asleep (unspecified)"
			case .asleepCore: return "Core sleep"
			case .asleepDeep: return "Deep sleep"
			case .asleepREM: return "REM sleep"
			case let .unknown(value): return "Unknown sleep state (\(value))"
			}
		}

		public var rawValue: Int {
			switch self {
			case .awake: return HKCategoryValueSleepAnalysis.awake.rawValue
			case .inBed: return HKCategoryValueSleepAnalysis.inBed.rawValue
			case .asleep: return HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue
			case .asleepCore: return HKCategoryValueSleepAnalysis.asleepCore.rawValue
			case .asleepDeep: return HKCategoryValueSleepAnalysis.asleepDeep.rawValue
			case .asleepREM: return HKCategoryValueSleepAnalysis.asleepREM.rawValue
			case let .unknown(value): return value
			}
		}
	}

	// MARK: - HealthKit Stuff

	public static let categoryType: HKCategoryType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
	public static let sampleType: HKSampleType = categoryType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])

	public static func initUnits() {
		// nothing to init
	}

	// MARK: - Display Information

	public static let name: String = "Sleep"
	public static let description: String = ""

	// MARK: - Attributes

	public static let stateAttribute = TypedSelectOneAttribute<State>(
		id: 0,
		name: "Waking state",
		typeName: "Waking state",
		variableName: HKPredicateKeyPathCategoryValue,
		possibleValues: State.allValues,
		possibleValueToString: { $0.description },
		areEqual: { $0 == $1 }
	)
	public static let durationAttribute = DurationAttribute(id: 1)
	public static let stateCodeAttribute = IntegerAttribute(id: 2, name: "Health state code",
		pluralName: "Health state codes", variableName: HKPredicateKeyPathCategoryValue)
	/// Groups all recognized asleep stages without conflating future unknown codes
	/// with either sleeping or waking. The original state choices retain their IDs.
	public static let isAsleepAttribute = BooleanAttribute(id: 3, name: "Is asleep",
		pluralName: "Is asleep", variableName: "isAsleep", optional: true)
	public static let attributes: [Attribute] = [
		durationAttribute,
		CommonSampleAttributes.healthKitStartDate,
		CommonSampleAttributes.healthKitEndDate,
		stateAttribute,
		stateCodeAttribute,
		isAsleepAttribute,
	]
	public static let defaultDependentAttribute: Attribute = durationAttribute
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitStartDate
	public final var attributes: [Attribute] { Me.attributes }
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.healthKitStartDate,
		.end: CommonSampleAttributes.healthKitEndDate,
	]

	// MARK: - Searching

	public func matchesSearchString(_ searchString: String) -> Bool {
		state.description.localizedCaseInsensitiveContains(searchString)
	}

	// MARK: - Instance Variables

	public private(set) var sourceIdentifier: UUID? = nil
	public private(set) var originalHealthSample: HKSample? = nil

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var startDate: Date
	public final var endDate: Date
	public final var state: State
	public final var isAsleep: Bool? {
		switch state {
		case .asleep, .asleepCore, .asleepDeep, .asleepREM: return true
		case .awake, .inBed: return false
		case .unknown: return nil
		}
	}
	public final var duration: TimeDuration {
		TimeDuration(endDate - startDate)
	}

	// MARK: - Initializers

	public init(_ state: State = .awake, startDate: Date = Date(), endDate: Date = Date()) {
		self.startDate = startDate
		self.endDate = endDate
		self.state = state
	}

	public required init(_ sample: HKCategorySample) {
		sourceIdentifier = sample.uuid
		originalHealthSample = sample
		state = State(rawValue: sample.value)
		startDate = sample.startDate
		injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &startDate, from: sample)
		endDate = sample.endDate
		injected(HealthKitUtil.self).setTimeZoneIfApplicable(for: &endDate, from: sample)
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		HKCategorySample(
			type: Me.categoryType,
			value: state.rawValue,
			start: startDate,
			end: endDate,
			metadata: [HKMetadataKeyTimeZone: TimeZone.autoupdatingCurrent.identifier]
		)
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: startDate, .end: endDate]
	}

	public final func graphableValue(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.durationAttribute) {
			return TimeDuration(start: startDate, end: endDate).inUnit(.hour)
		}
		return try value(of: attribute)
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.durationAttribute) {
			return TimeDuration(start: startDate, end: endDate)
		}
		if attribute.equalTo(Me.stateAttribute) {
			return state
		}
		if attribute.equalTo(Me.stateCodeAttribute) {
			return state.rawValue
		}
		if attribute.equalTo(Me.isAsleepAttribute) {
			return isAsleep
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) {
			return startDate
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) {
			return endDate
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.stateCodeAttribute) || attribute.equalTo(Me.isAsleepAttribute) {
			throw GenericDisplayableError(title: "Sleep state codes and stage summaries are read-only.",
				description: "Choose a waking state to change this record.")
		}
		if attribute.equalTo(Me.stateAttribute) {
			guard let castedValue = value as? State else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			if case .unknown = castedValue {
				throw GenericDisplayableError(title: "Unknown sleep states are read-only.",
					description: "Choose a recognized sleep state rather than an unsupported Health code.")
			}
			state = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			startDate = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			endDate = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
}

// MARK: - Equatable

extension Sleep: Equatable {
	public static func == (lhs: Sleep, rhs: Sleep) -> Bool {
		lhs.equalTo(rhs)
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
		startDate == other.startDate &&
			endDate == other.endDate &&
			state == other.state
	}
}

// MARK: - Debug

extension Sleep: CustomDebugStringConvertible {
	public final var debugDescription: String {
		"Sleep with state \(state) from " + startDate.debugDescription + " to " + endDate.debugDescription
	}
}
