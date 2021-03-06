//
//  DoesNotHaveOneOfTagAttributeRestrictionFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import CoreData
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Samples

final class DoesNotHaveOneOfTagAttributeRestrictionFunctionalTests: FunctionalTest {

	private typealias Me = DoesNotHaveOneOfTagAttributeRestrictionFunctionalTests
	private static let tagsAttribute = DoesNotHaveOneOfTagAttributeRestriction.tagsAttribute

	private final var restriction: DoesNotHaveOneOfTagAttributeRestriction!

	final override func setUp() {
		super.setUp()
		let _ = useTagAttribute()
	}

	// MARK: - samplePasses()

	func testGivenOneTargetTagSampleTagIsTargetTag_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: targetTag, for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenOneTargetTagAndSampleTagIsNotTargetTag_samplePasses_returnsTrue() throws {
		// given
		let restrictedAttribute = useTagAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let notTargetTag = TagDataTestUtil.createTag(name: "not the target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: notTargetTag, for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenMultipleTargetTagsAndSampleHasLastOne_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagAttribute()
		let targetTag1 = TagDataTestUtil.createTag(name: "target tag 1")
		let targetTag2 = TagDataTestUtil.createTag(name: "target tag 2")
		let sample = SampleCreatorTestUtil.createSample(withValue: targetTag2, for: restrictedAttribute)
		restriction.tags = [targetTag1, targetTag2]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleOptionalTagIsNil_samplePasses_returnsTrue() throws {
		let restrictedAttribute = useTagAttribute(optional: true)
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as [Tag]?, for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleNonOptionalTagIsNil_samplePasses_throwsTypeMismatchError() throws {
		// given
		let restrictedAttribute = useTagAttribute(optional: false)
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Tag?, for: restrictedAttribute)

		// when
		XCTAssertThrowsError(try restriction.samplePasses(sample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleHasOnlyTargetTag_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagsAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: [targetTag], for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleHasTargetTagAndOtherTags_samplePasses_returnsFalse() throws {
		let restrictedAttribute = useTagsAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let otherTag = TagDataTestUtil.createTag(name: "other tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: [targetTag, otherTag], for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleDoesNotHaveAnyTags_samplePasses_returnsTrue() throws {
		// given
		let restrictedAttribute = useTagsAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: [], for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleHasTagsButDoesNotHaveTargetTag_samplePasses_returnsTrue() throws {
		// given
		let restrictedAttribute = useTagsAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let otherTag = TagDataTestUtil.createTag(name: "other tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: [otherTag], for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleOptionalTagsAttributeIsNil_samplePasses_returnsTrue() throws {
		// given
		let restrictedAttribute = useTagsAttribute(optional: true)
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as [Tag]?, for: restrictedAttribute)
		restriction.tags = [targetTag]

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleHasNilForNonOptionalTagsAttribute_samplePasses_throwsTypeMismatchError() throws {
		// given
		let restrictedAttribute = useTagsAttribute(optional: false)
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as [Tag]?, for: restrictedAttribute)

		// when
		XCTAssertThrowsError(try restriction.samplePasses(sample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	// MARK: - predicate()

	func testGivenActivityWithOneOfSpecifiedTags_predicate_properlyFilters() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "tag1")
		let tag2 = TagDataTestUtil.createTag(name: "tag2")
		ActivityDataTestUtil.createActivity(tags: [tag2])
		restriction.restrictedAttribute = Activity.tagsAttribute
		restriction.tags = [tag1, tag2]
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = restriction.predicate()

		// when
		let activities = try database.query(fetchRequest)

		// then
		assertThat(activities, hasCount(0))
	}

	func testGivenActivityWithoutOneOfSpecifiedTags_predicate_properlyFilters() throws {
		// given
		let tag = TagDataTestUtil.createTag(name: "tag1")
		let activity = ActivityDataTestUtil.createActivity()
		restriction.restrictedAttribute = Activity.tagsAttribute
		restriction.tags = [tag]
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = restriction.predicate()

		// when
		let activities = try database.query(fetchRequest)

		// then
		assertThat(activities, arrayHasExactly([activity], areEqual: { $0.equalTo($1) }))
	}

	// MARK: - copy()

	func test_copy_returnsCopy() {
		// given
		restriction.tags = [TagDataTestUtil.createTag(name: "target tag")]

		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? DoesNotHaveOneOfTagAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - value(of:)

	func testGivenTagAttribute_valueOf_returnsCorrectTag() throws {
		// given
		let _ = useTagAttribute()
		let expectedTag = TagDataTestUtil.createTag(name: "target tag")
		restriction.tags = [expectedTag]

		// when
		if let tags = try restriction.value(of: Me.tagsAttribute) as? [Tag] {
			// then
			XCTAssert(tags.elementsEqual([expectedTag], by: { $0.equalTo($1) }))
		} else {
			XCTFail("returned nil or or wrong type")
		}
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() throws {
		// given
		let _ = useTagAttribute()
		let tag = TagDataTestUtil.createTag()
		restriction.tags = [tag]
		let unknownAttribute = DoubleAttribute(name: "unknown attribute")

		// when
		XCTAssertThrowsError(try restriction.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	// MARK: - set(attribute:to:)

	func testGivenTagsAttributeAndTagArray_set_correctlySetsTags() throws {
		// given
		let _ = useTagAttribute()
		let expectedTag = TagDataTestUtil.createTag()

		// when
		try restriction.set(attribute: Me.tagsAttribute, to: [expectedTag] as Any)

		// then
		XCTAssert([expectedTag].elementsEqual(restriction.tags, by: { $0.equalTo($1) }))
	}

	func testGivenTagsAttributeAndTagSet_set_correctlySetsTags() throws {
		// given
		let _ = useTagAttribute()
		let expectedTag = TagDataTestUtil.createTag()

		// when
		try restriction.set(attribute: Me.tagsAttribute, to: Set([expectedTag]) as Any)

		// then
		XCTAssert([expectedTag].elementsEqual(restriction.tags, by: { $0.equalTo($1) }))
	}

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() throws {
		// given
		let _ = useTagAttribute()
		let tag = TagDataTestUtil.createTag()
		let unknownAttribute = DoubleAttribute(name: "unknown attribute")

		// when
		XCTAssertThrowsError(try restriction.set(attribute: unknownAttribute, to: tag)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenTagsAttributeAndWrongValueType_set_throwsTypeMismatchError() throws {
		// given
		let _ = useTagAttribute()

		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.tagsAttribute, to: "" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = restriction == restriction

		// then
		XCTAssert(areEqual)
	}

	func testGivenRestrictedAttributeMismatch_equalToOperator_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: TagAttribute(name: "note the same"))

		// when
		let areEqual = restriction == other

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalToOperator_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = [TagDataTestUtil.createTag(name: "not in main restriction")]

		// when
		let areEqual = restriction == other

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameValues_equalToOperator_returnsTrue() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = restriction.tags

		// when
		let areEqual = restriction == other

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = HeartRate(1, Date())

		// when
		let areEqual = restriction.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = restriction.equalTo(restriction as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenRestrictedAttributeMismatch_equalToAttributed_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: TagAttribute(name: "note the same"))

		// when
		let areEqual = restriction.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalToAttributed_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = [TagDataTestUtil.createTag(name: "not in main restriction")]

		// when
		let areEqual = restriction.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameValues_equalToAttributed_returnsTrue() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = restriction.tags

		// when
		let areEqual = restriction.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(restriction:)

	func testGivenWrongClass_equalToRestriction_returnsFalse() {
		// given
		let other = EqualToDoubleAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let areEqual = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToRestriction_returnsTrue() {
		// when
		let areEqual = restriction.equalTo(restriction as AttributeRestriction)

		// then
		XCTAssert(areEqual)
	}

	func testGivenRestrictedAttributeMismatch_equalToRestriction_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: TagAttribute(name: "note the same"))

		// when
		let areEqual = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalToRestriction_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = [TagDataTestUtil.createTag(name: "not in main restriction")]

		// when
		let areEqual = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameValues_equalToRestriction_returnsTrue() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = restriction.tags

		// when
		let areEqual = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = restriction.equalTo(restriction)

		// then
		XCTAssert(areEqual)
	}

	func testGivenRestrictedAttributeMismatch_equalTo_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: TagAttribute(name: "note the same"))

		// when
		let areEqual = restriction.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalTo_returnsFalse() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = [TagDataTestUtil.createTag(name: "not in main restriction")]

		// when
		let areEqual = restriction.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameValues_equalTo_returnsTrue() {
		// given
		let other = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)
		other.tags = restriction.tags

		// when
		let areEqual = restriction.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - Helper Functions

	private final func useTagAttribute(optional: Bool = false) -> Attribute {
		let attribute = TagAttribute(optional: optional)
		restriction = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: attribute)
		return attribute
	}

	private final func useTagsAttribute(optional: Bool = false) -> Attribute {
		let attribute = TagsAttribute(optional: optional)
		restriction = DoesNotHaveOneOfTagAttributeRestriction(restrictedAttribute: attribute)
		return attribute
	}
}
