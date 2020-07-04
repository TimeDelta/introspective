//
//  Sleep.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Attributes
import Common
import DependencyInjection

public final class Sleep: HealthKitCategorySample, SearchableSample {
	private typealias Me = Sleep

	public enum State: CustomStringConvertible {
		case awake
		case inBed
		case asleep

		public static var allValues: [State] = [awake, inBed, asleep]

		public var description: String {
			switch self {
			case .awake: return "Awake"
			case .inBed: return "In bed"
			case .asleep: return "Asleep"
			}
		}

		public var rawValue: Int {
			switch self {
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

	public static func initUnits() {
		// nothing to init
	}

	// MARK: - Display Information

	public static let name: String = "Sleep"
	public static let description: String = ""

	// MARK: - Attributes

	public static let stateAttribute = TypedSelectOneAttribute<State>(
		name: "Waking state",
		typeName: "Waking state",
		variableName: HKPredicateKeyPathCategoryValue,
		possibleValues: State.allValues,
		possibleValueToString: { $0.description },
		areEqual: { $0 == $1 }
	)
	public static let durationAttribute = DurationAttribute()
	public static let attributes: [Attribute] = [
		durationAttribute,
		CommonSampleAttributes.healthKitStartDate,
		CommonSampleAttributes.healthKitEndDate,
		stateAttribute,
	]
	public static let defaultDependentAttribute: Attribute = durationAttribute
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitStartDate
	public final var attributes: [Attribute] { Me.attributes }

	// MARK: - Searching

	public func matchesSearchString(_ searchString: String) -> Bool {
		state.description.localizedCaseInsensitiveContains(searchString)
	}

	// MARK: - Instance Variables

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var startDate: Date
	public final var endDate: Date
	public final var state: State

	private final let log = Log()

	// MARK: - Initializers

	public init(_ state: State = .awake, startDate: Date = Date(), endDate: Date = Date()) {
		self.startDate = startDate
		self.endDate = endDate
		self.state = state
	}

	public required init(_ sample: HKCategorySample) {
		switch sample.value {
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
			log.error("Unknown state: %d", sample.value)
			state = .awake
			break
		}
		startDate = sample.startDate
		DependencyInjector.get(HealthKitUtil.self).setTimeZoneIfApplicable(for: &startDate, from: sample)
		endDate = sample.endDate
		DependencyInjector.get(HealthKitUtil.self).setTimeZoneIfApplicable(for: &endDate, from: sample)
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
			return Duration(start: startDate, end: endDate).inUnit(.hour)
		}
		return try value(of: attribute)
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.durationAttribute) {
			return Duration(start: startDate, end: endDate)
		}
		if attribute.equalTo(Me.stateAttribute) {
			return state
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
		if attribute.equalTo(Me.stateAttribute) {
			guard let castedValue = value as? State else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
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
		"Sleep with state \(state) from " + DependencyInjector.get(CalendarUtil.self)
			.string(for: startDate) + " to " + DependencyInjector.get(CalendarUtil.self).string(for: endDate)
	}
}
