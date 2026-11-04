import XCTest

import Attributes
import Samples

final class StepsEqualityTests: XCTestCase {
	private let start = Date(timeIntervalSince1970: 1_700_000_000.123456)
	private var end: Date { start.addingTimeInterval(60) }

	func testSampleDispatchRecognizesSeparateStepsWithEqualValues() {
		let first: Sample = Steps(25, start, end)
		let second: Sample = Steps(25, start, end)
		XCTAssertTrue(first.equalTo(second))
		XCTAssertTrue(second.equalTo(first))
	}

	func testSampleDispatchIsReflexive() {
		let sample: Sample = Steps(25, start, end)
		XCTAssertTrue(sample.equalTo(sample))
	}

	func testSampleDispatchRejectsHeartRateWithoutRecursing() {
		let steps: Sample = Steps(25, start, end)
		let heartRate: Sample = HeartRate(25, start)
		XCTAssertFalse(steps.equalTo(heartRate))
		XCTAssertFalse(heartRate.equalTo(steps))
	}

	func testSampleDispatchRejectsAnotherQuantityType() {
		let steps: Sample = Steps(25, start, end)
		let weight: Sample = Weight(25, start)
		XCTAssertFalse(steps.equalTo(weight))
	}

	func testDifferentStepCountsAreUnequalThroughEveryInterface() {
		assertComparison(Steps(25, start, end), Steps(26, start, end), equal: false)
	}

	func testDifferentStartInstantsAreUnequalThroughEveryInterface() {
		assertComparison(Steps(25, start, end), Steps(25, start.addingTimeInterval(0.001), end), equal: false)
	}

	func testDifferentEndInstantsAreUnequalThroughEveryInterface() {
		assertComparison(Steps(25, start, end), Steps(25, start, end.addingTimeInterval(0.001)), equal: false)
	}

	func testConcreteAttributedAndSampleDispatchAgreeForEqualValues() {
		assertComparison(Steps(0, start, end), Steps(0, start, end), equal: true)
	}

	private func assertComparison(_ first: Steps, _ second: Steps, equal expected: Bool,
		file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(first == second, expected, file: file, line: line)
		XCTAssertEqual(first.equalTo(second), expected, file: file, line: line)
		XCTAssertEqual((first as Attributed).equalTo(second as Attributed), expected, file: file, line: line)
		XCTAssertEqual((first as Sample).equalTo(second as Sample), expected, file: file, line: line)
		XCTAssertEqual((second as Sample).equalTo(first as Sample), expected, file: file, line: line)
	}
}
