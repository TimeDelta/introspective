//
//  DoesNotHaveTagAttributeRestrictionFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

final class DoesNotHaveTagAttributeRestrictionFunctionalTests: FunctionalTest {

	private typealias Me = DoesNotHaveTagAttributeRestrictionFunctionalTests
	private static let tagAttribute = DoesNotHaveTagAttributeRestriction.tagAttribute

	private final var restriction: DoesNotHaveTagAttributeRestriction!

	// MARK: - samplePasses()

	func testGivenSampleTagIsTargetTag_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: targetTag, for: restrictedAttribute)
		restriction.tag = targetTag

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleTagIsNotTargetTag_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let notTargetTag = TagDataTestUtil.createTag(name: "not the target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: notTargetTag, for: restrictedAttribute)
		restriction.tag = targetTag

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleOptionalTagIsNil_samplePasses_returnsFalse() throws {
		let restrictedAttribute = useTagAttribute(optional: true)
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as [Tag]?, for: restrictedAttribute)
		restriction.tag = targetTag

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
		restriction.tag = targetTag

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
		restriction.tag = targetTag

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleDoesNotHaveAnyTags_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagsAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: [], for: restrictedAttribute)
		restriction.tag = targetTag

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleHasTagsButDoesNotHaveTargetTag_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagsAttribute()
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let otherTag = TagDataTestUtil.createTag(name: "other tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: [otherTag], for: restrictedAttribute)
		restriction.tag = targetTag

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleOptionalTagsAttributeIsNil_samplePasses_returnsFalse() throws {
		// given
		let restrictedAttribute = useTagsAttribute(optional: true)
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as [Tag]?, for: restrictedAttribute)
		restriction.tag = targetTag

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

	// MARK: - value(of:)

	func testGivenTagAttribute_valueOf_returnsCorrectTag() throws {
		// given
		let _ = useTagAttribute()
		let expectedTag = TagDataTestUtil.createTag(name: "target tag")
		restriction.tag = expectedTag

		// when
		if let tag = try restriction.value(of: Me.tagAttribute) as? Tag {
			// then
			XCTAssert(tag.equalTo(expectedTag))
		} else {
			XCTFail("returned nil")
		}
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() throws {
		// given
		let _ = useTagAttribute()
		let tag = TagDataTestUtil.createTag()
		restriction.tag = tag
		let unknownAttribute = DoubleAttribute(name: "unknown attribute")

		// when
		XCTAssertThrowsError(try restriction.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	// MARK: - set(attribute:to:)

	func testGivenTagAttributeAndTag_set_correctlySetsTag() throws {
		// given
		let _ = useTagAttribute()
		let expectedTag = TagDataTestUtil.createTag()

		// when
		try restriction.set(attribute: Me.tagAttribute, to: expectedTag)

		// then
		XCTAssert(expectedTag.equalTo(restriction.tag))
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

	func testGivenTagAttributeAndNonTagValue_set_throwsTypeMismatchError() throws {
		// given
		let _ = useTagAttribute()

		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.tagAttribute, to: "" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	// MARK: - Helper Functions

	private final func useTagAttribute(optional: Bool = false) -> Attribute {
		let attribute = TagAttribute(optional: optional)
		restriction = DoesNotHaveTagAttributeRestriction(restrictedAttribute: attribute)
		return attribute
	}

	private final func useTagsAttribute(optional: Bool = false) -> Attribute {
		let attribute = TagsAttribute(optional: optional)
		restriction = DoesNotHaveTagAttributeRestriction(restrictedAttribute: attribute)
		return attribute
	}
}
