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

	// MARK: - Source Names

	// ! Only add to the end of this list
	public static let activitySources = [
		"Introspective",
		"ATracker",
	]
	// ! Only add to the end of this list
	public static let medicationSources = [
		"Introspective",
		"EasyPill",
	]
	// ! Only add to the end of this list
	public static let moodSources = [
		"Introspective",
		"Wellness",
	]

	// MARK: - Source Enums

	// ! Only add to the end of this list
	public enum ActivitySourceNum: Int16 {
		public typealias RawValue = Int16

		case introspective
		case aTracker
	}

	// ! Only add to the end of this list
	public enum MedicationSourceNum: Int16 {
		public typealias RawValue = Int16

		case introspective
		case easyPill
	}

	// ! Only add to the end of this list
	public enum MoodSourceNum: Int16 {
		public typealias RawValue = Int16

		case introspective
		case wellness
	}

	// MARK: - Source Resolvers

	public static func resolveActivitySource(_ num: Int16) -> String {
		return activitySources[Int(num)]
	}

	public static func resolveMedicationSource(_ num: Int16) -> String {
		return medicationSources[Int(num)]
	}

	public static func resolveMoodSource(_ num: Int16) -> String {
		return moodSources[Int(num)]
	}
}
