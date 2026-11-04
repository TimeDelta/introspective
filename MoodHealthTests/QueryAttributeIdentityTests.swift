import XCTest
import Attributes

final class QueryAttributeIdentityTests: XCTestCase {
	func testCanonicalSelectionMetadataDoesNotFetchItsDynamicValuesForEquality() {
		var reads = 0
		let attribute = TypedSelectOneAttribute<Int>(id: 7, name: "Selection", typeName: "Number",
			possibleValues: { reads += 1; return [1, 2] }, possibleValueToString: String.init, areEqual: ==)
		XCTAssertTrue(attribute.equalTo(attribute))
		XCTAssertEqual(reads, 0, "A canonical metadata comparison must not access another context's selection list")
	}

	func testDistinctSelectionMetadataStillComparesAvailableValues() {
		var firstReads = 0, secondReads = 0
		let first = TypedSelectOneAttribute<Int>(id: 7, name: "Selection", typeName: "Number",
			possibleValues: { firstReads += 1; return [1, 2] }, possibleValueToString: String.init, areEqual: ==)
		let second = TypedSelectOneAttribute<Int>(id: 7, name: "Selection", typeName: "Number",
			possibleValues: { secondReads += 1; return [1, 2] }, possibleValueToString: String.init, areEqual: ==)
		XCTAssertTrue(first.equalTo(second))
		XCTAssertEqual(firstReads, 1); XCTAssertEqual(secondReads, 1)
	}

	func testDistinctSelectionMetadataWithDifferentValuesRemainsUnequal() {
		let first = TypedEquatableSelectOneAttribute<Int>(id: 7, name: "Selection", typeName: "Number",
			possibleValues: [1], possibleValueToString: String.init)
		let second = TypedEquatableSelectOneAttribute<Int>(id: 7, name: "Selection", typeName: "Number",
			possibleValues: [2], possibleValueToString: String.init)
		XCTAssertFalse(first.equalTo(second))
	}
}
