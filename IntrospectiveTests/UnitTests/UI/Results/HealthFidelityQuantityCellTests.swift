import XCTest
import UIKit
import HealthKit
import SwiftyMocky
@testable import Introspective
@testable import Samples

final class HealthFidelityQuantityCellTests: UnitTest {
	private let date = Date(timeIntervalSinceReferenceDate: 700_000_000.875)
	private var previousWeightUnit: HKUnit!

	override func setUp() {
		super.setUp()
		previousWeightUnit = Weight.unit
		Weight.unit = .gramUnit(with: .kilo)
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: "Recorded date"))
	}

	override func tearDown() {
		Weight.unit = previousWeightUnit
		previousWeightUnit = nil
		super.tearDown()
	}

	private func labels(in cell: HealthKitQuantitySampleTableViewCell) -> (UILabel, UILabel) {
		let value = UILabel(), timestamp = UILabel()
		cell.contentView.addSubview(value); cell.contentView.addSubview(timestamp)
		cell.valueLabel = value; cell.timestampLabel = timestamp
		return (value, timestamp)
	}

	private func makeCell() -> HealthKitQuantitySampleTableViewCell {
		let cell = HealthKitQuantitySampleTableViewCell(style: .default, reuseIdentifier: "fidelity")
		cell.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
		_ = labels(in: cell)
		cell.setNeedsLayout(); cell.layoutIfNeeded()
		return cell
	}

	private func constraints(in view: UIView) -> [NSLayoutConstraint] {
		view.constraints.filter { $0.identifier == "healthQuantityCell" }
			+ view.subviews.flatMap { constraints(in: $0) }
	}

	func testOneHundredAssignmentsAndLayoutsReuseTheSameNineOwnedConstraints() {
		let cell = makeCell()
		let original = constraints(in: cell)
		XCTAssertEqual(original.count, 9)
		let identities = Set(original.map(ObjectIdentifier.init))
		var previousText: String?
		for index in 0..<100 {
			cell.sample = Weight(Double(index), date.addingTimeInterval(Double(index)))
			cell.setNeedsLayout(); cell.layoutIfNeeded()
			let current = constraints(in: cell)
			XCTAssertEqual(current.count, 9)
			XCTAssertEqual(Set(current.map(ObjectIdentifier.init)), identities)
			XCTAssertTrue(current.allSatisfy { $0.isActive })
			XCTAssertTrue(cell.valueLabel.text?.hasSuffix(" kg") == true)
			XCTAssertNotEqual(cell.valueLabel.text, previousText)
			XCTAssertEqual(cell.timestampLabel.text, "Recorded date")
			previousText = cell.valueLabel.text
		}
	}

	func testReplacingOutletsDeactivatesAndReleasesTheirOldConstraintsAndViews() {
		let cell = HealthKitQuantitySampleTableViewCell(style: .default, reuseIdentifier: "fidelity")
		cell.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
		weak var releasedValue: UILabel?
		weak var releasedTimestamp: UILabel?
		weak var releasedConstraint: NSLayoutConstraint?
		autoreleasepool {
			let (oldValue, oldTimestamp) = labels(in: cell)
			cell.sample = Weight(70, date)
			cell.layoutIfNeeded()
			let oldConstraints = constraints(in: cell)
			XCTAssertEqual(oldConstraints.count, 9)
			releasedValue = oldValue; releasedTimestamp = oldTimestamp
			releasedConstraint = oldConstraints.first
			oldValue.removeFromSuperview(); oldTimestamp.removeFromSuperview()
			_ = labels(in: cell)
			cell.setNeedsLayout(); cell.layoutIfNeeded()
			XCTAssertTrue(oldConstraints.allSatisfy { !$0.isActive })
			XCTAssertEqual(constraints(in: cell).count, 9)
			XCTAssertTrue(cell.valueLabel.text?.hasSuffix(" kg") == true)
		}
		XCTAssertNil(releasedValue); XCTAssertNil(releasedTimestamp)
		XCTAssertNil(releasedConstraint, "The live cell must not retain obsolete outlet constraints")
	}

	func testPreparingForReuseClearsValuesAndReleasesItsSampleWithoutRebuildingConstraints() {
		let cell = makeCell()
		let identities = Set(constraints(in: cell).map(ObjectIdentifier.init))
		weak var releasedSample: Weight?
		autoreleasepool {
			let sample = Weight(70, date)
			releasedSample = sample
			cell.sample = sample
			XCTAssertNotNil(cell.valueLabel.text)
			cell.prepareForReuse()
			XCTAssertNil(cell.sample)
			XCTAssertNil(cell.valueLabel.text); XCTAssertNil(cell.timestampLabel.text)
		}
		XCTAssertNil(releasedSample)
		cell.layoutIfNeeded()
		XCTAssertEqual(Set(constraints(in: cell).map(ObjectIdentifier.init)), identities)
	}

	func testSampleAssignedBeforeOutletsRendersAfterAttachmentAndShowsIntervalEnd() {
		let end = date.addingTimeInterval(60)
		Given(mockCalendarUtil, .string(for: .value(date), dateStyle: .any, timeStyle: .any, willReturn: "Start"))
		Given(mockCalendarUtil, .string(for: .value(end), dateStyle: .any, timeStyle: .any, willReturn: "End"))
		let cell = HealthKitQuantitySampleTableViewCell(style: .default, reuseIdentifier: "fidelity")
		cell.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
		cell.sample = ActiveEnergy(12, date, end)
		_ = labels(in: cell)
		cell.setNeedsLayout(); cell.layoutIfNeeded()
		XCTAssertTrue(cell.valueLabel.text?.hasSuffix(" kcal") == true)
		XCTAssertEqual(cell.timestampLabel.text, "Start to End")
		XCTAssertEqual(constraints(in: cell).count, 9)
		cell.sample = nil
		XCTAssertNil(cell.valueLabel.text); XCTAssertNil(cell.timestampLabel.text)
	}
}
