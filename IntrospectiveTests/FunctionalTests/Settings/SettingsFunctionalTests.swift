//
//  SettingsFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/21/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective
@testable import DependencyInjection
@testable import Persistence
@testable import Settings

final class SettingsFunctionalTests: FunctionalTest {

	// MARK: - changed()

	func testGivenMinMoodNotChanged_changed_returnsFalse() {
		// given
		settings.setMinMood(settings.minMood)

		// when
		let changed = settings.changed(.minMood)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenMinMoodChanged_changed_returnsTrue() {
		// given
		settings.setMinMood(settings.minMood + 1)

		// when
		let changed = settings.changed(.minMood)

		// then
		XCTAssert(changed)
	}

	func testGivenMaxMoodNotChanged_changed_returnsFalse() {
		// given
		settings.setMaxMood(settings.maxMood)

		// when
		let changed = settings.changed(.maxMood)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenMaxMoodChanged_changed_returnsTrue() {
		// given
		settings.setMaxMood(settings.maxMood + 1)

		// when
		let changed = settings.changed(.maxMood)

		// then
		XCTAssert(changed)
	}

	func testGivenDiscreteMoodsNotChanged_changed_returnsFalse() {
		// given
		settings.setDiscreteMoods(settings.discreteMoods)

		// when
		let changed = settings.changed(.discreteMoods)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenDiscreteMoodsChanged_changed_returnsTrue() {
		// given
		settings.setDiscreteMoods(!settings.discreteMoods)

		// when
		let changed = settings.changed(.discreteMoods)

		// then
		XCTAssert(changed)
	}

	func testGivenScaleMoodsOnImportNotChanged_changed_returnsFalse() {
		// given
		settings.setScaleMoodsOnImport(settings.scaleMoodsOnImport)

		// when
		let changed = settings.changed(.scaleMoodsOnImport)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenScaleMoodsOnImportChanged_changed_returnsTrue() {
		// given
		settings.setScaleMoodsOnImport(!settings.scaleMoodsOnImport)

		// when
		let changed = settings.changed(.scaleMoodsOnImport)

		// then
		XCTAssert(changed)
	}

	func testGivenAutoIgnoreEnabledNotChanged_changed_returnsFalse() {
		// given
		settings.setAutoIgnoreEnabled(settings.autoIgnoreEnabled)

		// when
		let changed = settings.changed(.autoIgnoreEnabled)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenAutoIgnoreEnabledChanged_changed_returnsTrue() {
		// given
		settings.setAutoIgnoreEnabled(!settings.autoIgnoreEnabled)

		// when
		let changed = settings.changed(.autoIgnoreEnabled)

		// then
		XCTAssert(changed)
	}

	func testGivenAutoIgnoreSecondsNotChanged_changed_returnsFalse() {
		// given
		settings.setAutoIgnoreSeconds(settings.autoIgnoreSeconds)

		// when
		let changed = settings.changed(.autoIgnoreSeconds)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenAutoIgnoreSecondsChanged_changed_returnsTrue() {
		// given
		settings.setAutoIgnoreSeconds(settings.autoIgnoreSeconds + 1)

		// when
		let changed = settings.changed(.autoIgnoreSeconds)

		// then
		XCTAssert(changed)
	}

	func testGivenConvertTimeZonesNotChanged_changed_returnsFalse() {
		// given
		settings.setConvertTimeZones(settings.convertTimeZones)

		// when
		let changed = settings.changed(.convertTimeZones)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenConvertTimeZonesChanged_changed_returnsTrue() {
		// given
		settings.setConvertTimeZones(!settings.convertTimeZones)

		// when
		let changed = settings.changed(.convertTimeZones)

		// then
		XCTAssert(changed)
	}

	func testGivenAutoTrimWhitespaceInActivityNotesNotChanged_changed_returnsFalse() {
		// given
		settings.setAutoIgnoreEnabled(settings.autoIgnoreEnabled)

		// when
		let changed = settings.changed(.autoTrimWhitespaceInActivityNotes)

		// then
		XCTAssertFalse(changed)
	}

	func testGivenAutoTrimWhitespaceInActivityNotesChanged_changed_returnsTrue() {
		// given
		settings.setAutoTrimWhitespaceInActivityNotes(!settings.autoTrimWhitespaceInActivityNotes)

		// when
		let changed = settings.changed(.autoTrimWhitespaceInActivityNotes)

		// then
		XCTAssert(changed)
	}

	// MARK: - setMinMood()

	func testGivenNewMinMood_setMinMood_correctlySetsValue() {
		// given
		let expectedValue = settings.minMood + 1

		// when
		settings.setMinMood(expectedValue)

		// then
		XCTAssertEqual(settings.minMood, expectedValue)
	}

	// MARK: - setMaxMood()

	func testGivenNewMaxMood_setMaxMood_correctlySetsValue() {
		// given
		let expectedValue = settings.maxMood + 1

		// when
		settings.setMaxMood(expectedValue)

		// then
		XCTAssertEqual(settings.maxMood, expectedValue)
	}

	// MARK: - setDiscreteMoods()

	func testGivenNewDiscreteMoods_setDiscreteMoods_correctlySetsValue() {
		// given
		let expectedValue = !settings.discreteMoods

		// when
		settings.setDiscreteMoods(expectedValue)

		// then
		XCTAssertEqual(settings.discreteMoods, expectedValue)
	}

	// MARK: - setScaleMoodsOnImport()

	func testGivenNewScaleMoodsOnImport_setScaleMoodsOnImport_correctlySetsValue() {
		// given
		let expectedValue = !settings.scaleMoodsOnImport

		// when
		settings.setScaleMoodsOnImport(expectedValue)

		// then
		XCTAssertEqual(settings.scaleMoodsOnImport, expectedValue)
	}

	// MARK: - setAutoIgnoreEnabled()

	func testGivenNewAutoIgnoreEnabled_setAutoIgnoreEnabled_correctlySetsValue() {
		// given
		let expectedValue = !settings.autoIgnoreEnabled

		// when
		settings.setAutoIgnoreEnabled(expectedValue)

		// then
		XCTAssertEqual(settings.autoIgnoreEnabled, expectedValue)
	}

	// MARK: - setAutoIgnoreSeconds()

	func testGivenNewAutoIgnoreSeconds_setAutoIgnoreSeconds_correctlySetsValue() {
		// given
		let expectedValue = settings.autoIgnoreSeconds + 1

		// when
		settings.setAutoIgnoreSeconds(expectedValue)

		// then
		XCTAssertEqual(settings.autoIgnoreSeconds, expectedValue)
	}

	// MARK: - setConvertTimeZones()

	func testGivenNewConvertTimeZones_setConvertTimeZones_correctlySetsValue() {
		// given
		let expectedValue = !settings.convertTimeZones

		// when
		settings.setConvertTimeZones(expectedValue)

		// then
		XCTAssertEqual(settings.convertTimeZones, expectedValue)
	}

	// MARK: - setAutoTrimWhitespaceInActivityNotes()

	func testGivenNewAutoTrimWhitespaceInActivityNotes_setAutoTrimWhitespaceInActivityNotes_correctlySetsValue() {
		// given
		let expectedValue = !settings.autoTrimWhitespaceInActivityNotes

		// when
		settings.setAutoTrimWhitespaceInActivityNotes(expectedValue)

		// then
		XCTAssertEqual(settings.autoTrimWhitespaceInActivityNotes, expectedValue)
	}

	// MARK: - reset()

	func testGivenNewMinMood_reset_resetsMinMood() {
		// given
		let expectedValue = settings.minMood + 1
		settings.setMinMood(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.minMood, expectedValue)
	}

	func testGivenNewMaxMood_reset_resetsMaxMood() {
		// given
		let expectedValue = settings.maxMood + 1
		settings.setMaxMood(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.maxMood, expectedValue)
	}

	func testGivenNewDiscreteMoods_reset_resetsDiscreteMoods() {
		// given
		let expectedValue = !settings.discreteMoods
		settings.setDiscreteMoods(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.discreteMoods, expectedValue)
	}

	func testGivenNewScaleMoodsOnImport_reset_resetsScaleMoodsOnImport() {
		// given
		let expectedValue = !settings.scaleMoodsOnImport
		settings.setScaleMoodsOnImport(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.scaleMoodsOnImport, expectedValue)
	}

	func testGivenNewAutoIgnoreEnabled_reset_resetsAutoIgnoreEnabled() {
		// given
		let expectedValue = !settings.autoIgnoreEnabled
		settings.setAutoIgnoreEnabled(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.autoIgnoreEnabled, expectedValue)
	}

	func testGivenNewAutoIgnoreSeconds_reset_resetsAutoIgnoreSeconds() {
		// given
		let expectedValue = settings.autoIgnoreSeconds + 1
		settings.setAutoIgnoreSeconds(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.autoIgnoreSeconds, expectedValue)
	}

	func testGivenNewConvertTimeZones_reset_resetsConvertTimeZones() {
		// given
		let expectedValue = !settings.convertTimeZones
		settings.setConvertTimeZones(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.convertTimeZones, expectedValue)
	}

	func testGivenNewAutoTrimWhitespaceInActivityNotes_reset_resetsAutoTrimWhitespaceInActivityNotes() {
		// given
		let expectedValue = !settings.autoTrimWhitespaceInActivityNotes
		settings.setAutoTrimWhitespaceInActivityNotes(expectedValue)

		// when
		settings.reset()

		// then
		XCTAssertNotEqual(settings.autoTrimWhitespaceInActivityNotes, expectedValue)
	}

	// MARK: - save()

	func testGivenNewMinMood_save_savesMinMood() throws {
		// given
		let expectedValue = settings.minMood + 1
		settings.setMinMood(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.minMood, expectedValue)
	}

	func testGivenNewMaxMood_save_savesMaxMood() throws {
		// given
		let expectedValue = settings.maxMood + 1
		settings.setMaxMood(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.maxMood, expectedValue)
	}

	func testGivenNewDiscreteMoods_save_savesDiscreteMoods() throws {
		// given
		let expectedValue = !settings.discreteMoods
		settings.setDiscreteMoods(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.discreteMoods, expectedValue)
	}

	func testGivenNewScaleMoodsOnImport_save_savesScaleMoodsOnImport() throws {
		// given
		let expectedValue = !settings.scaleMoodsOnImport
		settings.setScaleMoodsOnImport(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.scaleMoodsOnImport, expectedValue)
	}

	func testGivenNewAutoIgnoreEnabled_save_savesAutoIgnoreEnabled() throws {
		// given
		let expectedValue = !settings.autoIgnoreEnabled
		settings.setAutoIgnoreEnabled(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.autoIgnoreEnabled, expectedValue)
	}

	func testGivenNewAutoIgnoreSeconds_save_savesAutoIgnoreSeconds() throws {
		// given
		let expectedValue = settings.autoIgnoreSeconds + 1
		settings.setAutoIgnoreSeconds(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.autoIgnoreSeconds, expectedValue)
	}

	func testGivenNewConvertTimeZones_save_savesConvertTimeZones() throws {
		// given
		let expectedValue = !settings.convertTimeZones
		settings.setConvertTimeZones(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.convertTimeZones, expectedValue)
	}

	func testGivenNewAutoTrimWhitespaceInActivityNotes_save_savesAutoTrimWhitespaceInActivityNotes() throws {
		// given
		let expectedValue = !settings.autoTrimWhitespaceInActivityNotes
		settings.setAutoTrimWhitespaceInActivityNotes(expectedValue)

		// when
		try settings.save()

		// then
		let transaction = injected(Database.self).transaction()
		let newSettingsObject = try injected(Database.self).query(SettingsImpl.fetchRequest())[0]
		try transaction.commit()
		XCTAssertEqual(newSettingsObject.autoTrimWhitespaceInActivityNotes, expectedValue)
	}
}
