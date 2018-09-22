//
//  Settings.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData
import os

public enum Setting {
	case maxMood
}

//sourcery: AutoMockable
public protocol Settings: CoreDataObject {

	// have to do it this way because the dependency injection system does not allow assignment
	var maximumMood: Double { get }
	func setMaxMood(_ value: Double)

	func changed(_ setting: Setting) -> Bool

	func reset()
	func save()
}

public final class SettingsImpl: NSManagedObject, Settings {

	private typealias Me = SettingsImpl
	public static let entityName = "Settings"

	private final var newMaxMood: Double? = nil
	public final var maximumMood: Double {
		if newMaxMood != nil {
			return newMaxMood!
		}
		return maxMood
	}

	public final func changed(_ setting: Setting) -> Bool {
		switch (setting) {
			case .maxMood: return newMaxMood != nil
		}
	}

	public final func setMaxMood(_ value: Double) {
		newMaxMood = value
	}

	public final func reset() {
		newMaxMood = nil
	}

	public final func save() {
		maxMood = newMaxMood ?? maxMood
		DependencyInjector.db.save()
		reset()
	}
}
