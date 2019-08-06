//
//  Settings+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

public enum Setting {
	case minMood
	case maxMood
	case discreteMoods
	case scaleMoodsOnImport
	case autoIgnoreEnabled
	case autoIgnoreSeconds
	case bubbleRunningActivitiesToTop
	case convertTimeZones
}

//sourcery: AutoMockable
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

	var bubbleRunningActivitiesToTop: Bool { get }
	func setBubbleRunningActivitiesToTop(_ value: Bool)

	var convertTimeZones: Bool { get }
	func setConvertTimeZones(_ value: Bool)

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
	private final var newMinMood: Double? = nil
	public final var minMood: Double {
		return newMinMood ?? storedMinMood
	}
	public final func setMinMood(_ value: Double) {
		if value != storedMinMood {
			newMinMood = value
		}
	}

	// MARK: Max Mood
	private final var newMaxMood: Double? = nil
	public final var maxMood: Double {
		return newMaxMood ?? storedMaxMood
	}
	public final func setMaxMood(_ value: Double) {
		if value != storedMaxMood {
			newMaxMood = value
		}
	}

	// MARK: Discrete Moods
	private final var newDiscreteMoods: Bool? = nil
	public final var discreteMoods: Bool {
		return newDiscreteMoods ?? storedDiscreteMoods
	}
	public final func setDiscreteMoods(_ value: Bool) {
		if value != storedDiscreteMoods {
			newDiscreteMoods = value
		}
	}

	// MARK: Scale Moods On Import
	private final var newScaleMoodsOnImport: Bool? = nil
	public final var scaleMoodsOnImport: Bool {
		return newScaleMoodsOnImport ?? storedScaleMoodsOnImport
	}
	public final func setScaleMoodsOnImport(_ value: Bool) {
		if value != storedScaleMoodsOnImport {
			newScaleMoodsOnImport = value
		}
	}

	// MARK: - Activities

	// MARK: Auto Ignore Enabled
	private final var newAutoIgnoreEnabled: Bool? = nil
	public final var autoIgnoreEnabled: Bool {
		return newAutoIgnoreEnabled ?? storedAutoIgnoreEnabled
	}
	public final func setAutoIgnoreEnabled(_ value: Bool) {
		if value != storedAutoIgnoreEnabled {
			newAutoIgnoreEnabled = value
		}
	}

	// MARK: Auto Ignore Seconds
	private final var newAutoIgnoreSeconds: Int? = nil
	public final var autoIgnoreSeconds: Int {
		return newAutoIgnoreSeconds ?? storedAutoIgnoreSeconds
	}
	public final func setAutoIgnoreSeconds(_ value: Int) {
		if value != storedAutoIgnoreSeconds {
			newAutoIgnoreSeconds = value
		}
	}

	// MARK: Bubble Running Activities To Top
	private final var newBubbleRunningActivitiesToTop: Bool? = nil
	public final var bubbleRunningActivitiesToTop: Bool {
		return newBubbleRunningActivitiesToTop ?? storedBubbleRunningActivitiesToTop
	}
	public final func setBubbleRunningActivitiesToTop(_ value: Bool) {
		if value != storedBubbleRunningActivitiesToTop {
			newBubbleRunningActivitiesToTop = value
		}
	}

	// MARK: - General

	// MARK: Convert Time Zones
	private final var newConvertTimeZones: Bool? = nil
	public final var convertTimeZones: Bool {
		return newConvertTimeZones ?? storedConvertTimeZones
	}
	public final func setConvertTimeZones(_ value: Bool) {
		if value != storedConvertTimeZones {
			newConvertTimeZones = value
		}
	}

	// MARK: - Other Functions

	public final func changed(_ setting: Setting) -> Bool {
		switch (setting) {
			case .minMood: return newMinMood != nil
			case .maxMood: return newMaxMood != nil
			case .discreteMoods: return newDiscreteMoods != nil
			case .scaleMoodsOnImport: return newScaleMoodsOnImport != nil
			case .autoIgnoreEnabled: return newAutoIgnoreEnabled != nil
			case .autoIgnoreSeconds: return newAutoIgnoreSeconds != nil
			case .bubbleRunningActivitiesToTop: return newBubbleRunningActivitiesToTop != nil
			case .convertTimeZones: return newConvertTimeZones != nil
		}
	}

	public final func reset() {
		newMinMood = nil
		newMaxMood = nil
		newDiscreteMoods = nil
		newScaleMoodsOnImport = nil
		newAutoIgnoreEnabled = nil
		newAutoIgnoreSeconds = nil
		newBubbleRunningActivitiesToTop = nil
		newConvertTimeZones = nil
	}

	public final func save() throws {
		let transaction = DependencyInjector.db.transaction()
		storedMinMood = minMood
		storedMaxMood = maxMood
		storedDiscreteMoods = discreteMoods
		storedScaleMoodsOnImport = scaleMoodsOnImport
		storedAutoIgnoreEnabled = autoIgnoreEnabled
		storedAutoIgnoreSeconds = autoIgnoreSeconds
		storedBubbleRunningActivitiesToTop = bubbleRunningActivitiesToTop
		storedConvertTimeZones = convertTimeZones
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		reset()
	}
}

// MARK: - Stored Values

extension SettingsImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsImpl> {
		return NSFetchRequest<SettingsImpl>(entityName: "Settings")
	}

	@NSManaged fileprivate var storedMinMood: Double
	@NSManaged fileprivate var storedMaxMood: Double
	@NSManaged fileprivate var storedDiscreteMoods: Bool
	@NSManaged fileprivate var storedScaleMoodsOnImport: Bool
	@NSManaged fileprivate var storedAutoIgnoreEnabled: Bool
	@NSManaged fileprivate var storedAutoIgnoreSeconds: Int
	@NSManaged fileprivate var storedBubbleRunningActivitiesToTop: Bool
	@NSManaged fileprivate var storedConvertTimeZones: Bool
}
