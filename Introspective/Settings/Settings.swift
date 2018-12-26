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
	case autoIgnoreEnabled
	case autoIgnoreSeconds
}

//sourcery: AutoMockable
public protocol Settings: CoreDataObject {

	// have to do it this way because the dependency injection system does not allow assignment
	var minMood: Double { get }
	func setMinMood(_ value: Double)

	var maxMood: Double { get }
	func setMaxMood(_ value: Double)

	var autoIgnoreEnabled: Bool { get }
	func setAutoIgnoreEnabled(_ value: Bool)

	var autoIgnoreSeconds: Int { get }
	func setAutoIgnoreSeconds(_ value: Int)

	func changed(_ setting: Setting) -> Bool

	func reset()
	func save()
}

public final class SettingsImpl: NSManagedObject, Settings {

	// MARK: - Static Variables

	private typealias Me = SettingsImpl
	public static let entityName = "Settings"

	// MARK: - Min Mood

	private final var newMinMood: Double? = nil
	public final var minMood: Double {
		return newMinMood ?? storedMinMood
	}
	public final func setMinMood(_ value: Double) {
		if value != storedMinMood {
			newMinMood = value
		}
	}

	// MARK: - Max Mood

	private final var newMaxMood: Double? = nil
	public final var maxMood: Double {
		return newMaxMood ?? storedMaxMood
	}
	public final func setMaxMood(_ value: Double) {
		if value != storedMaxMood {
			newMaxMood = value
		}
	}

	// MARK: - Auto Ignore Enabled

	private final var newAutoIgnoreEnabled: Bool? = nil
	public final var autoIgnoreEnabled: Bool {
		return newAutoIgnoreEnabled ?? storedAutoIgnoreEnabled
	}
	public final func setAutoIgnoreEnabled(_ value: Bool) {
		if value != storedAutoIgnoreEnabled {
			newAutoIgnoreEnabled = value
		}
	}

	// MARK: - Auto Ignore Seconds

	private final var newAutoIgnoreSeconds: Int? = nil
	public final var autoIgnoreSeconds: Int {
		return newAutoIgnoreSeconds ?? storedAutoIgnoreSeconds
	}
	public final func setAutoIgnoreSeconds(_ value: Int) {
		if value != storedAutoIgnoreSeconds {
			newAutoIgnoreSeconds = value
		}
	}

	// MARK: - Other Functions

	public final func changed(_ setting: Setting) -> Bool {
		switch (setting) {
			case .minMood: return newMinMood != nil
			case .maxMood: return newMaxMood != nil
			case .autoIgnoreEnabled: return newAutoIgnoreEnabled != nil
			case .autoIgnoreSeconds: return newAutoIgnoreSeconds != nil
		}
	}

	public final func reset() {
		newMinMood = nil
		newMaxMood = nil
		newAutoIgnoreEnabled = nil
		newAutoIgnoreSeconds = nil
	}

	public final func save() {
		storedMinMood = minMood
		storedMaxMood = maxMood
		storedAutoIgnoreEnabled = autoIgnoreEnabled
		storedAutoIgnoreSeconds = autoIgnoreSeconds
		DependencyInjector.db.save()
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
	@NSManaged fileprivate var storedAutoIgnoreEnabled: Bool
	@NSManaged fileprivate var storedAutoIgnoreSeconds: Int
}
