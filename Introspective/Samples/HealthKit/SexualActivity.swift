//
//  SexualActivity.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class SexualActivity: HealthKitCategorySample {

	private typealias Me = SexualActivity

	public enum Protection: CustomStringConvertible {
		case notUsed
		case used
		case unspecified

		public static var allValues: [Protection] = [unspecified, notUsed, used]

		public var description: String {
			switch (self) {
				case .notUsed: return "Not used"
				case .used: return "Used"
				case .unspecified: return "Unspecified"
			}
		}
	}

	// MARK: - HealthKit Stuff

	public static let categoryType: HKCategoryType = HKCategoryType.categoryType(forIdentifier: .sexualActivity)!
	public static let sampleType: HKSampleType = categoryType
	public static let readPermissions: Set<HKObjectType> = Set([sampleType])
	public static let writePermissions: Set<HKSampleType> = Set([sampleType])

	// MARK: - Display Information

	public static let name: String = "Sexual Activity"
	public static let description: String = ""

	// MARK: - Attributes

	public static let protectionUsed = TypedSelectOneAttribute<Protection>(
		name: "Protection used",
		variableName: HKMetadataKeySexualActivityProtectionUsed,
		possibleValues: Protection.allValues,
		possibleValueToString: { $0.description },
		areEqual: { $0 == $1 })
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitTimestamp, protectionUsed]
	public static let defaultDependentAttribute: Attribute = protectionUsed
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitTimestamp
	public final var attributes: [Attribute] { return Me.attributes }

	// MARK: - Instance Variables

	public final var attributedName: String = Me.name
	public final var description: String = Me.description
	public final var timestamp: Date
	public final var protectionUsed: Protection

	// MARK: - Initializers

	public init(_ timestamp: Date = Date(), _ protection: Protection = .unspecified) {
		self.timestamp = timestamp
		protectionUsed = protection
	}

	public required init(_ sample: HKCategorySample) {
		if let protection = sample.metadata?[HKMetadataKeySexualActivityProtectionUsed] as? Bool {
			protectionUsed = protection ? .used : .notUsed
		} else {
			protectionUsed = .unspecified
		}
		timestamp = sample.startDate
		DependencyInjector.util.healthKit.setTimeZoneIfApplicable(for: &timestamp, from: sample)
	}

	// MARK: - HealthKitSample Functions

	public func hkSample() -> HKSample {
		var metadata: [String: Any] = [String: Any]()
		switch (protectionUsed) {
			case .unspecified: break
			case .used:
				metadata = [HKMetadataKeySexualActivityProtectionUsed: true]
				break
			case .notUsed:
				metadata = [HKMetadataKeySexualActivityProtectionUsed: false]
				break
		}
		metadata[HKMetadataKeyTimeZone] = TimeZone.autoupdatingCurrent.identifier
		return HKCategorySample(
			type: Me.categoryType,
			value: HKCategoryValue.notApplicable.rawValue,
			start: timestamp,
			end: timestamp,
			metadata: metadata)
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.protectionUsed) {
			return protectionUsed
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			return timestamp
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.protectionUsed) {
			guard let castedValue = value as? Protection else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			protectionUsed = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.healthKitTimestamp) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			timestamp = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
}

// MARK: - Equatable

extension SexualActivity: Equatable {

	public static func ==(lhs: SexualActivity, rhs: SexualActivity) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is SexualActivity) { return false }
		let other = otherAttributed as! SexualActivity
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is SexualActivity) { return false }
		let other = otherSample as! SexualActivity
		return equalTo(other)
	}

	public final func equalTo(_ other: SexualActivity) -> Bool {
		return timestamp == other.timestamp && protectionUsed == other.protectionUsed
	}
}

// MARK: - Debug

extension SexualActivity: CustomDebugStringConvertible {

	public final var debugDescription: String {
		return "SexualActivity with protection \(protectionUsed) at " + DependencyInjector.util.calendar.string(for: timestamp)
	}
}
