//
//  Sources.swift
//  Introspective
//
//  Created by Bryan Nova on 12/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

/// This decouples the name of the source from the storage of the source
public final class Sources {

	// MARK: - Source Enums

	// ! Only add to the end of this list
	public enum ActivitySourceNum: Int16 {
		public typealias RawValue = Int16

		public static let values: [ActivitySourceNum] = [
			.introspective,
			.aTracker,
		]

		case introspective
		case aTracker

		public var description: String {
			switch (self) {
				case .introspective: return "Introspective"
				case .aTracker: return "ATracker"
			}
		}
	}

	// ! Only add to the end of this list
	public enum MedicationSourceNum: Int16 {
		public typealias RawValue = Int16

		public static let values: [MedicationSourceNum] = [
			.introspective,
			.easyPill,
		]

		case introspective
		case easyPill

		public var description: String {
			switch (self) {
				case .introspective: return "Introspective"
				case .easyPill: return "EasyPill"
			}
		}
	}

	// ! Only add to the end of this list
	public enum MoodSourceNum: Int16 {
		public typealias RawValue = Int16

		public static let values: [MoodSourceNum] = [
			.introspective,
			.wellness,
		]

		case introspective
		case wellness

		public var description: String {
			switch (self) {
				case .introspective: return "Introspective"
				case .wellness: return "Wellness"
			}
		}
	}

	// MARK: - Source Resolvers

	public static func resolveActivitySource(_ num: Int16) -> ActivitySourceNum {
		return ActivitySourceNum.values[Int(num)]
	}

	public static func resolveMedicationSource(_ num: Int16) -> MedicationSourceNum {
		return MedicationSourceNum.values[Int(num)]
	}

	public static func resolveMoodSource(_ num: Int16) -> MoodSourceNum {
		return MoodSourceNum.values[Int(num)]
	}
}
