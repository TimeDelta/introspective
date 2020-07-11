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
	case minMood
	case maxMood

	/// Whether or not to use discrete mood ratings.
	case discreteMoods

	/// Whether or not imported mood ratings should automatically be scaled to the current min / max ratings
	case scaleMoodsOnImport

	/// Whether or not to ignore stopped activities with duration less than [autoIgnoreSeconds](x-source-tag://autoIgnoreSeconds).
	case autoIgnoreEnabled
	/// The minimum number of seconds that a stopped activity must be in order to be kept (only from record screens).
	/// - Tag: autoIgnoreSeconds
	case autoIgnoreSeconds

	case convertTimeZones

	case defaultSearchNearbyDuration
}

// sourcery: AutoMockable
public protocol Settings: CoreDataObject {
	// have to do it this way because the dependency injection system does not allow assignment
	var minMood: Double { get }
	func setMinMood(_ value: Double)

	var maxMood: Double { get }
	func setMaxMood(_ value: Double)

	var discreteMoods: Bool { get }
	func setDiscreteMoods(_ value: Bool)

	var scaleMoodsOnImport: Bool { get }
	func setScaleMoodsOnImport(_ value: Bool)

	var autoIgnoreEnabled: Bool { get }
	func setAutoIgnoreEnabled(_ value: Bool)

	var autoIgnoreSeconds: Int { get }
	func setAutoIgnoreSeconds(_ value: Int)

	var convertTimeZones: Bool { get }
	func setConvertTimeZones(_ value: Bool)

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

	// MARK: Default Search Nearby TimeDuration

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
		case .autoIgnoreEnabled: return newAutoIgnoreEnabled != nil
		case .autoIgnoreSeconds: return newAutoIgnoreSeconds != nil
		case .convertTimeZones: return newConvertTimeZones != nil
		case .defaultSearchNearbyDuration: return newDefaultSearchNearbyDuration != nil
		}
	}

	public final func reset() {
		newMinMood = nil
		newMaxMood = nil
		newDiscreteMoods = nil
		newScaleMoodsOnImport = nil
		newAutoIgnoreEnabled = nil
		newAutoIgnoreSeconds = nil
		newConvertTimeZones = nil
		newDefaultSearchNearbyDuration = nil
	}

	public final func save() throws {
		let transaction = DependencyInjector.get(Database.self).transaction()
		storedMinMood = minMood
		storedMaxMood = maxMood
		storedDiscreteMoods = discreteMoods
		storedScaleMoodsOnImport = scaleMoodsOnImport
		storedAutoIgnoreEnabled = autoIgnoreEnabled
		storedAutoIgnoreSeconds = autoIgnoreSeconds
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

	@NSManaged fileprivate var storedAutoIgnoreEnabled: Bool
	@NSManaged fileprivate var storedAutoIgnoreSeconds: Int

	@NSManaged fileprivate var storedConvertTimeZones: Bool

	@NSManaged fileprivate var storedDefaultSearchNearbyDuration: TimeDuration?
}
