//
//  MoodFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 1/14/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Samples

final class MoodFunctionalTests: FunctionalTest {

	private typealias Me = MoodFunctionalTests
	private static let rating = 2.5
	private static let minRating = 0.0
	private static let maxRating = 5.2
	private static let note = "this is a note"
	private static let timestamp = Date()
	private static let source = Sources.resolveMoodSource(Sources.MoodSourceNum.introspective.rawValue).description

	private final var mood: MoodImpl!

	public final override func setUp() {
		mood = MoodDataTestUtil.createMood(note: Me.note, rating: Me.rating, timestamp: Me.timestamp, min: Me.minRating, max: Me.maxRating)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeException() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try mood.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenRatingAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try mood.value(of: MoodImpl.rating) as? Double

		// then
		XCTAssertEqual(value, Me.rating)
	}

	func testGivenMinRatingAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try mood.value(of: MoodImpl.minRating) as? Double

		// then
		XCTAssertEqual(value, Me.minRating)
	}

	func testGivenMaxRatingAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try mood.value(of: MoodImpl.maxRating) as? Double

		// then
		XCTAssertEqual(value, Me.maxRating)
	}

	func testGivenNoteAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try mood.value(of: MoodImpl.note) as? String

		// then
		XCTAssertEqual(value, Me.note)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try mood.value(of: CommonSampleAttributes.timestamp) as? Date

		// then
		XCTAssertEqual(value, Me.timestamp)
	}

	func testGivenSourceAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try mood.value(of: MoodImpl.sourceAttribute) as? String

		// then
		XCTAssertEqual(value, Me.source)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try mood.set(attribute: unknownAttribute, to: 0.0 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueTypeForRatingAttribute_set_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try mood.set(attribute: MoodImpl.rating, to: "" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenCorrectValueTypeForRatingAttribute_set_correctlySetsValue() throws {
		// given
		let expectedValue = mood.rating + 1

		// when
		try mood.set(attribute: MoodImpl.rating, to: expectedValue)

		// then
		XCTAssertEqual(mood.rating, expectedValue)
	}

	func testGivenWrongValueTypeForMinRatingAttribute_set_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try mood.set(attribute: MoodImpl.minRating, to: "" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenCorrectValueTypeForMinRatingAttribute_set_correctlySetsValue() throws {
		// given
		let expectedValue = mood.minRating + 1

		// when
		try mood.set(attribute: MoodImpl.minRating, to: expectedValue)

		// then
		XCTAssertEqual(mood.minRating, expectedValue)
	}

	func testGivenWrongValueTypeForMaxRatingAttribute_set_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try mood.set(attribute: MoodImpl.maxRating, to: "" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenCorrectValueTypeForMaxRatingAttribute_set_correctlySetsValue() throws {
		// given
		let expectedValue = mood.maxRating + 1

		// when
		try mood.set(attribute: MoodImpl.maxRating, to: expectedValue)

		// then
		XCTAssertEqual(mood.maxRating, expectedValue)
	}

	func testGivenWrongValueTypeForNoteAttribute_set_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try mood.set(attribute: MoodImpl.note, to: Date() as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenCorrectValueTypeForNoteAttribute_set_correctlySetsValue() throws {
		// given
		let expectedValue = (mood.note ?? "") + "other stuff"

		// when
		try mood.set(attribute: MoodImpl.note, to: expectedValue)

		// then
		XCTAssertEqual(mood.note, expectedValue)
	}

	func testGivenWrongValueTypeForTimestampAttribute_set_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try mood.set(attribute: CommonSampleAttributes.timestamp, to: "" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenCorrectValueTypeForTimestampAttribute_set_correctlySetsValue() throws {
		// given
		let expectedValue = mood.date + 1.days

		// when
		try mood.set(attribute: CommonSampleAttributes.timestamp, to: expectedValue)

		// then
		XCTAssertEqual(mood.date, expectedValue)
	}

	func testGivenSourceAttribute_set_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try mood.set(attribute: MoodImpl.sourceAttribute, to: "" as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = mood == mood

		// then
		XCTAssert(areEqual)
	}

	// https://stackoverflow.com/questions/42283715/overload-for-custom-class-is-not-always-called
	// https://stackoverflow.com/questions/6883848/why-am-i-not-able-to-override-isequal-in-my-nsmanagedobject-subclass
	func testGivenTwoMoodsWithSameValuesButDifferentMemoryAddresses_equalToOperator_returnsFalse() {
		// given
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood == otherMood

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""))

		// when
		let areEqual = mood.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRatingMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherRating = mood.rating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: otherRating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMinRatingMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherMinRating = mood.minRating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: otherMinRating,
			max: mood.maxRating)

		// when
		let areEqual = mood == otherMood

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMaxRatingMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherMaxRating = mood.maxRating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: otherMaxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNoteMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherNote = (mood.note ?? "") + "other stuff"
		let otherMood = MoodDataTestUtil.createMood(
			note: otherNote,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherTimestamp = mood.date + 1.days
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: otherTimestamp,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = mood.equalTo(mood as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoMoodsWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = HeartRate(12.3, Date())

		// when
		let areEqual = mood.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRatingMismatch_equalToSample_returnsFalse() {
		// given
		let otherRating = mood.rating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: otherRating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMinRatingMismatch_equalToSample_returnsFalse() {
		// given
		let otherMinRating = mood.minRating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: otherMinRating,
			max: mood.maxRating)

		// when
		let areEqual = mood == otherMood

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMaxRatingMismatch_equalToSample_returnsFalse() {
		// given
		let otherMaxRating = mood.maxRating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: otherMaxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNoteMismatch_equalToSample_returnsFalse() {
		// given
		let otherNote = (mood.note ?? "") + "other stuff"
		let otherMood = MoodDataTestUtil.createMood(
			note: otherNote,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToSample_returnsFalse() {
		// given
		let otherTimestamp = mood.date + 1.days
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: otherTimestamp,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = mood.equalTo(mood as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoMoodsWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(mood:)

	func testGivenRatingMismatch_equalTo_returnsFalse() {
		// given
		let otherRating = mood.rating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: otherRating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMinRatingMismatch_equalTo_returnsFalse() {
		// given
		let otherMinRating = mood.minRating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: otherMinRating,
			max: mood.maxRating)

		// when
		let areEqual = mood == otherMood

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMaxRatingMismatch_equalTo_returnsFalse() {
		// given
		let otherMaxRating = mood.maxRating + 1
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: otherMaxRating)

		// when
		let areEqual = mood.equalTo(otherMood)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNoteMismatch_equalTo_returnsFalse() {
		// given
		let otherNote = (mood.note ?? "") + "other stuff"
		let otherMood = MoodDataTestUtil.createMood(
			note: otherNote,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalTo_returnsFalse() {
		// given
		let otherTimestamp = mood.date + 1.days
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: otherTimestamp,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = mood.equalTo(mood)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoMoodsWithSameValues_equalTo_returnsTrue() {
		// given
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.date,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood)

		// then
		XCTAssert(areEqual)
	}
}
