//
//  Settings+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence

public enum Setting {
	/// The minimum rating value for a mood.
	/// - Tag: minMood
	case minMood
	/// The maximum rating value for a mood.
	/// - Tag: maxMood
	case maxMood
	/// Whether or not to use discrete mood ratings.
	/// - Tag: discreteMoods
	case discreteMoods
	/// Whether or not imported mood ratings should automatically be scaled to the current min / max ratings
	/// - Tag: scaleMoodsOnImport
	case scaleMoodsOnImport

	/// The minimum rating value for a fatigue entry.
	/// - Tag: minFatigue
	case minFatigue
	/// The maximum rating value for a fatigue entry.
	/// - Tag: maxFatigue
	case maxFatigue
	/// Whether or not to use discrete fatigue ratings.
	/// - Tag: discreteFatigue
	case discreteFatigue

	/// Whether or not to ignore stopped activities with duration less than [autoIgnoreSeconds](x-source-tag://autoIgnoreSeconds).
	/// - Tag: autoIgnoreEnabled
	case autoIgnoreEnabled
	/// The minimum number of seconds that a stopped activity must be in order to be kept (only from record screens).
	/// - Tag: autoIgnoreSeconds
	case autoIgnoreSeconds
	/// Whether or not each line of activity notes should be automatically trimmed of any leading or trailing whitespace.
	/// - Tag: autoTrimWhitespaceInActivityNotes
	case autoTrimWhitespaceInActivityNotes

	/// Whether or not to convert dates back to their original time zone before using them in any queries. charts, etc.
	/// - Tag: convertTimeZones
	case convertTimeZones

	/// The default amount of time away from a given sample to look when performing the search nearby action on the results screen
	/// - Tag: defaultSearchNearbyDuration
	case defaultSearchNearbyDuration
}

// sourcery: AutoMockable
public protocol Settings: CoreDataObject {
	// have to do it this way because the dependency injection system does not allow assignment

	/// - See [minMood](x-source-tag://minMood)
	var minMood: Double { get }
	func setMinMood(_ value: Double)

	/// - See [maxMood](x-source-tag://maxMood)
	var maxMood: Double { get }
	func setMaxMood(_ value: Double)

	/// - See [discreteMoods](x-source-tag://discreteMoods)
	var discreteMoods: Bool { get }
	func setDiscreteMoods(_ value: Bool)

	/// - See [scaleMoodsOnImport](x-source-tag://scaleMoodsOnImport)
	var scaleMoodsOnImport: Bool { get }
	func setScaleMoodsOnImport(_ value: Bool)

	/// - See [minFatigue](x-source-tag://minFatigue)
	var minFatigue: Double { get }
	func setMinFatigue(_ value: Double)

	/// - See [maxFatigue](x-source-tag://maxFatigue)
	var maxFatigue: Double { get }
	func setMaxFatigue(_ value: Double)

	/// - See [discreteFatigue](x-source-tag://discreteFatigue)
	var discreteFatigue: Bool { get }
	func setDiscreteFatigue(_ value: Bool)

	/// - See [autoIgnoreEnabled](x-source-tag://autoIgnoreEnabled)
	var autoIgnoreEnabled: Bool { get }
	func setAutoIgnoreEnabled(_ value: Bool)

	/// - See [autoIgnoreSeconds](x-source-tag://autoIgnoreSeconds)
	var autoIgnoreSeconds: Int { get }
	func setAutoIgnoreSeconds(_ value: Int)

	/// - See [autoTrimWhitespaceInActivityNotes](x-source-tag://autoTrimWhitespaceInActivityNotes)
	var autoTrimWhitespaceInActivityNotes: Bool { get }
	func setAutoTrimWhitespaceInActivityNotes(_ value: Bool)

	/// - See [convertTimeZones](x-source-tag://convertTimeZones)
	var convertTimeZones: Bool { get }
	func setConvertTimeZones(_ value: Bool)

	/// - See [defaultSearchNearbyDuration](x-source-tag://defaultSearchNearbyDuration)
	var defaultSearchNearbyDuration: TimeDuration { get }
	func setDefaultSearchNearbyDuration(_ value: TimeDuration)

	func changed(_ setting: Setting) -> Bool

	func reset()
	func save() throws
}

public final class SettingsImpl: NSManagedObject, Settings {
	// MARK: - Static Variables

	private typealias Me = SettingsImpl
	public static let entityName = "Settings"

	// MARK: - Moods

	// MARK: Min Mood

	private final var newMinMood: Double?
	public final var minMood: Double {
		newMinMood ?? storedMinMood
	}

	public final func setMinMood(_ value: Double) {
		if value != storedMinMood {
			newMinMood = value
		}
	}

	// MARK: Max Mood

	private final var newMaxMood: Double?
	public final var maxMood: Double {
		newMaxMood ?? storedMaxMood
	}

	public final func setMaxMood(_ value: Double) {
		if value != storedMaxMood {
			newMaxMood = value
		}
	}

	// MARK: Discrete Moods

	private final var newDiscreteMoods: Bool?
	public final var discreteMoods: Bool {
		newDiscreteMoods ?? storedDiscreteMoods
	}

	public final func setDiscreteMoods(_ value: Bool) {
		if value != storedDiscreteMoods {
			newDiscreteMoods = value
		}
	}

	// MARK: Scale Moods On Import

	private final var newScaleMoodsOnImport: Bool?
	public final var scaleMoodsOnImport: Bool {
		newScaleMoodsOnImport ?? storedScaleMoodsOnImport
	}

	public final func setScaleMoodsOnImport(_ value: Bool) {
		if value != storedScaleMoodsOnImport {
			newScaleMoodsOnImport = value
		}
	}

	// MARK: - Fatigue

	// MARK: Min Fatigue

	private final var newMinFatigue: Double?
	public final var minFatigue: Double {
		newMinFatigue ?? storedMinFatigue
	}

	public final func setMinFatigue(_ value: Double) {
		if value != storedMinFatigue {
			newMinFatigue = value
		}
	}

	// MARK: Max Fatigue

	private final var newMaxFatigue: Double?
	public final var maxFatigue: Double {
		newMaxFatigue ?? storedMaxFatigue
	}

	public final func setMaxFatigue(_ value: Double) {
		if value != storedMaxFatigue {
			newMaxFatigue = value
		}
	}

	// MARK: Discrete Fatigue Ratings

	private final var newDiscreteFatigue: Bool?
	public final var discreteFatigue: Bool {
		newDiscreteFatigue ?? storedDiscreteFatigue
	}

	public final func setDiscreteFatigue(_ value: Bool) {
		if value != storedDiscreteFatigue {
			newDiscreteFatigue = value
		}
	}

	// MARK: - Activities

	// MARK: Auto Ignore Enabled

	private final var newAutoIgnoreEnabled: Bool?
	public final var autoIgnoreEnabled: Bool {
		newAutoIgnoreEnabled ?? storedAutoIgnoreEnabled
	}

	public final func setAutoIgnoreEnabled(_ value: Bool) {
		if value != storedAutoIgnoreEnabled {
			newAutoIgnoreEnabled = value
		}
	}

	// MARK: Auto Ignore Seconds

	private final var newAutoIgnoreSeconds: Int?
	public final var autoIgnoreSeconds: Int {
		newAutoIgnoreSeconds ?? storedAutoIgnoreSeconds
	}

	public final func setAutoIgnoreSeconds(_ value: Int) {
		if value != storedAutoIgnoreSeconds {
			newAutoIgnoreSeconds = value
		}
	}

	// MARK: Auto Trim Whitespace In Activity Notes

	private final var newAutoTrimWhitespaceInActivityNotes: Bool?
	public final var autoTrimWhitespaceInActivityNotes: Bool {
		newAutoTrimWhitespaceInActivityNotes ?? storedAutoTrimWhitespaceInActivityNotes
	}

	public final func setAutoTrimWhitespaceInActivityNotes(_ value: Bool) {
		if value != storedAutoTrimWhitespaceInActivityNotes {
			newAutoTrimWhitespaceInActivityNotes = value
		}
	}

	// MARK: - General

	// MARK: Convert Time Zones

	private final var newConvertTimeZones: Bool?
	public final var convertTimeZones: Bool {
		newConvertTimeZones ?? storedConvertTimeZones
	}

	public final func setConvertTimeZones(_ value: Bool) {
		if value != storedConvertTimeZones {
			newConvertTimeZones = value
		}
	}

	// MARK: - Results

	// MARK: Default Search Nearby Duration

	private final var newDefaultSearchNearbyDuration: TimeDuration?
	public final var defaultSearchNearbyDuration: TimeDuration {
		// can't set default in .xcdatamodel file because TimeDuration is stored as a Transformable
		newDefaultSearchNearbyDuration ?? storedDefaultSearchNearbyDuration ?? TimeDuration(30.minutes)
	}

	public func setDefaultSearchNearbyDuration(_ value: TimeDuration) {
		if value != storedDefaultSearchNearbyDuration {
			newDefaultSearchNearbyDuration = value
		}
	}

	// MARK: - Other Functions

	public final func changed(_ setting: Setting) -> Bool {
		switch setting {
		case .minMood: return newMinMood != nil
		case .maxMood: return newMaxMood != nil
		case .discreteMoods: return newDiscreteMoods != nil
		case .scaleMoodsOnImport: return newScaleMoodsOnImport != nil
		case .minFatigue: return newMinFatigue != nil
		case .maxFatigue: return newMaxFatigue != nil
		case .discreteFatigue: return newDiscreteFatigue != nil
		case .autoIgnoreEnabled: return newAutoIgnoreEnabled != nil
		case .autoIgnoreSeconds: return newAutoIgnoreSeconds != nil
		case .autoTrimWhitespaceInActivityNotes: return newAutoTrimWhitespaceInActivityNotes != nil
		case .convertTimeZones: return newConvertTimeZones != nil
		case .defaultSearchNearbyDuration: return newDefaultSearchNearbyDuration != nil
		}
	}

	public final func reset() {
		newMinMood = nil
		newMaxMood = nil
		newDiscreteMoods = nil
		newScaleMoodsOnImport = nil

		newMinFatigue = nil
		newMaxFatigue = nil
		newDiscreteFatigue = nil

		newAutoIgnoreEnabled = nil
		newAutoIgnoreSeconds = nil
		newAutoTrimWhitespaceInActivityNotes = nil

		newConvertTimeZones = nil
		newDefaultSearchNearbyDuration = nil
	}

	public final func save() throws {
		let transaction = injected(Database.self).transaction()

		storedMinMood = minMood
		storedMaxMood = maxMood
		storedDiscreteMoods = discreteMoods
		storedScaleMoodsOnImport = scaleMoodsOnImport

		storedMinFatigue = minFatigue
		storedMaxFatigue = maxFatigue
		storedDiscreteFatigue = discreteFatigue

		storedAutoIgnoreEnabled = autoIgnoreEnabled
		storedAutoIgnoreSeconds = autoIgnoreSeconds
		storedAutoTrimWhitespaceInActivityNotes = autoTrimWhitespaceInActivityNotes

		storedConvertTimeZones = convertTimeZones
		storedDefaultSearchNearbyDuration = defaultSearchNearbyDuration

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		reset()
	}
}

// MARK: - Stored Values

public extension SettingsImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<SettingsImpl> {
		NSFetchRequest<SettingsImpl>(entityName: "Settings")
	}

	@NSManaged fileprivate var storedMinMood: Double
	@NSManaged fileprivate var storedMaxMood: Double
	@NSManaged fileprivate var storedDiscreteMoods: Bool
	@NSManaged fileprivate var storedScaleMoodsOnImport: Bool

	@NSManaged fileprivate var storedMinFatigue: Double
	@NSManaged fileprivate var storedMaxFatigue: Double
	@NSManaged fileprivate var storedDiscreteFatigue: Bool

	@NSManaged fileprivate var storedAutoIgnoreEnabled: Bool
	@NSManaged fileprivate var storedAutoIgnoreSeconds: Int
	@NSManaged fileprivate var storedAutoTrimWhitespaceInActivityNotes: Bool

	@NSManaged fileprivate var storedConvertTimeZones: Bool

	@NSManaged fileprivate var storedDefaultSearchNearbyDuration: TimeDuration?
}
