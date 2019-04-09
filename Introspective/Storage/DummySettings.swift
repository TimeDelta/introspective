//
//  DummySettings.swift
//  Introspective
//
//  Created by Bryan Nova on 4/5/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

/// This is only to be used to avoid an issue with functional tests where
/// the same manged object model gets loaded twice, causing:
/// `Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Introspective.Medication' so +entity is unable to disambiguate`
///
/// This happens because the settings object was accessed before the
/// functional test setup is able to set the dependency injector to use
/// a FunctionalTestDatabase object.
///
/// - Note: It is impossible to set up the dependency injection system
///         properly before the app starts, which means that the record
///         screen will trigger the awakeFromNib on `RecordMoodTableViewCell`
///         or `RecordDiscreteMoodTableViewCell` immediately after app finishes
///         loading, which accesses the Settings object, requiring an
///         instantiation of Database in order to create a settings object.
public final class DummySettings: Settings {

	public static var entityName: String = "Settings"

	private final let log = Log()

	public final let minMood: Double = 2
	public final func setMinMood(_ value: Double) {
		log.error("tried to set MinMood")
	}

	public final let maxMood: Double = 2
	public final func setMaxMood(_ value: Double) {
		log.error("tried to set MaxMood")
	}

	public final let discreteMoods: Bool = true
	public final func setDiscreteMoods(_ value: Bool) {
		log.error("tried to set DiscreteMoods")
	}

	public final let scaleMoodsOnImport: Bool = true
	public final func setScaleMoodsOnImport(_ value: Bool) {
		log.error("tried to set ScaleMoodsOnImport")
	}

	public final let autoIgnoreEnabled: Bool = true
	public final func setAutoIgnoreEnabled(_ value: Bool) {
		log.error("tried to set AutoIgnoreEnabled")
	}

	public final let autoIgnoreSeconds: Int = 2
	public final func setAutoIgnoreSeconds(_ value: Int) {
		log.error("tried to set AutoIgnoreSeconds")
	}

	public final let convertTimeZones: Bool = true
	public final func setConvertTimeZones(_ value: Bool) {
		log.error("tried to set ConvertTimeZones")
	}

	public final func changed(_ setting: Setting) -> Bool {
		log.error("tried to check if setting was changed")
		return false
	}

	public final func reset() {
		log.error("tried to reset settings")
	}

	public final func save() throws {
		log.error("tried to save settings")
	}
}
