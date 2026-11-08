import XCTest
import HealthKit
import Samples

final class HealthSpecializedDetailsTests: XCTestCase {
	private let date = Date(timeIntervalSinceReferenceDate: 700_000_000.1234567)
	private var device: HKDevice {
		HKDevice(name: "Fixture device", manufacturer: "Fixture manufacturer", model: "Fixture model",
			hardwareVersion: "1", firmwareVersion: "2", softwareVersion: "3", localIdentifier: "fixture-local", udiDeviceIdentifier: "fixture-udi")
	}
	private func field(_ name: String, in sections: [HealthRecordSection]) -> String? {
		sections.lazy.flatMap(\.fields).first { $0.name == name }?.value
	}

	func testQuantityDetailsKeepIdentityRawDatesDeviceAndTypedMetadata() throws {
		let type = try XCTUnwrap(HKObjectType.quantityType(forIdentifier: .dietaryProtein))
		let end = date.addingTimeInterval(0.7654321)
		let sample = HKQuantitySample(type: type, quantity: HKQuantity(unit: .gram(), doubleValue: 12.25),
			start: date, end: end, device: device,
			metadata: ["Fixture note": "café 🫀", "Fixture date": date, "Fixture bool": true])
		let sections = HealthRecordDetails.sections(for: sample)
		XCTAssertEqual(field("Health UUID", in: sections), sample.uuid.uuidString)
		XCTAssertEqual(field("Health type", in: sections), type.identifier)
		XCTAssertEqual(Double(try XCTUnwrap(field("Start reference seconds", in: sections)))?.bitPattern,
			date.timeIntervalSinceReferenceDate.bitPattern)
		XCTAssertEqual(Double(try XCTUnwrap(field("End reference seconds", in: sections)))?.bitPattern,
			end.timeIntervalSinceReferenceDate.bitPattern)
		XCTAssertEqual(field("Local device identifier", in: sections), "fixture-local")
		XCTAssertEqual(field("UDI device identifier", in: sections), "fixture-udi")
		XCTAssertEqual(field("Fixture date", in: sections), "Date(referenceSeconds: \(date.timeIntervalSinceReferenceDate))")
		XCTAssertEqual(field("Fixture bool", in: sections), "true")
		XCTAssertEqual(field("Fixture note", in: sections), String(reflecting: "café 🫀"))
		XCTAssertEqual(field("Quantity measurement count", in: sections), String(sample.count))
	}

	func testFoodComponentsKeepTheirOwnDeviceMetadataAndTimestamp() throws {
		let type = try XCTUnwrap(HKObjectType.quantityType(forIdentifier: .dietaryProtein))
		let component = HKQuantitySample(type: type, quantity: HKQuantity(unit: .gram(), doubleValue: 12),
			start: date, end: date.addingTimeInterval(7), device: device, metadata: ["Ingredient": "Beans"])
		let foodType = try XCTUnwrap(HKObjectType.correlationType(forIdentifier: .food))
		let food = HKCorrelation(type: foodType, start: date.addingTimeInterval(-1), end: date.addingTimeInterval(9),
			objects: [component], metadata: ["Meal": "Lunch"])
		let values = try XCTUnwrap(HealthRecordDetails.sections(for: food).first { $0.title == "Correlated measurement 1" })
		XCTAssertTrue(values.fields.contains(.init(name: "Original Health record · Health UUID", value: component.uuid.uuidString)))
		XCTAssertTrue(values.fields.contains(.init(name: "Original Health record · Local device identifier", value: "fixture-local")))
		XCTAssertTrue(values.fields.contains(.init(name: "Original Health record · Start reference seconds", value: String(date.timeIntervalSinceReferenceDate))))
		XCTAssertTrue(values.fields.contains(.init(name: "Metadata · Ingredient", value: String(reflecting: "Beans"))))
		XCTAssertTrue(values.fields.contains { $0.name == "Original Health record · Source bundle" })
	}

	func testStateOfMindShowsAllLabelsAssociationsAndRecordedCodes() {
		let sample = HKStateOfMind(date: date, kind: .momentaryEmotion, valence: -0.375,
			labels: [.amazed, .overwhelmed], associations: [.health, .weather])
		let sections = HealthRecordDetails.sections(for: sample)
		XCTAssertEqual(field("Kind", in: sections), "Momentary emotion")
		XCTAssertEqual(field("Valence", in: sections), "-0.375")
		XCTAssertEqual(field("Labels", in: sections), "Amazed, Overwhelmed")
		XCTAssertEqual(field("Label codes", in: sections), sample.labels.map { String($0.rawValue) }.joined(separator: ", "))
		XCTAssertEqual(field("Associations", in: sections), "Health, Weather")
		XCTAssertEqual(field("Association codes", in: sections), sample.associations.map { String($0.rawValue) }.joined(separator: ", "))
	}

	func testAssessmentAnswersRetainQuestionOrderAndPreferNotToAnswer() {
		let gad = HKGAD7Assessment(date: date,
			answers: [.notAtAll, .severalDays, .moreThanHalfTheDays, .nearlyEveryDay, .notAtAll, .severalDays, .moreThanHalfTheDays])
		let gadSections = HealthRecordDetails.sections(for: gad)
		XCTAssertEqual(field("Answer codes", in: gadSections), "0, 1, 2, 3, 0, 1, 2")
		XCTAssertEqual(field("Question 2", in: gadSections), "Several days (1)")
		XCTAssertEqual(field("Question 7", in: gadSections), "More than half the days (2)")
		XCTAssertEqual(field("Recorded score", in: gadSections), String(gad.score))
		XCTAssertEqual(field("Recorded risk code", in: gadSections), String(gad.risk.rawValue))
		let phq = HKPHQ9Assessment(date: date, answers: Array(repeating: .notAtAll, count: 8) + [.preferNotToAnswer])
		let phqSections = HealthRecordDetails.sections(for: phq)
		XCTAssertEqual(field("Question 9", in: phqSections), "Prefer not to answer (4)")
		XCTAssertEqual(field("Answer codes", in: phqSections), "0, 0, 0, 0, 0, 0, 0, 0, 4")
		XCTAssertEqual(field("Recorded risk code", in: phqSections), String(phq.risk.rawValue))
	}

	func testFutureStateOfMindCodesRemainExplicitlyUnknown() {
		for code in [Int.min, -1, 0, 999, Int.max] {
			XCTAssertTrue(HealthRecordDetails.stateOfMindKind(code).contains("Unknown"))
			XCTAssertTrue(HealthRecordDetails.stateOfMindLabel(code).contains(String(code)))
			XCTAssertTrue(HealthRecordDetails.stateOfMindAssociation(code).contains(String(code)))
		}
	}

	func testMetadataFormattingIsDeterministicAndDoesNotCollapseArrayBoundariesOrTypes() {
		let first = HealthRecordDetails.metadataText(["z": ["a,b", "c"], "a": ["flag": true, "bytes": Data([0, 255])]])
		let second = HealthRecordDetails.metadataText(["a": ["bytes": Data([0, 255]), "flag": true], "z": ["a,b", "c"]])
		XCTAssertEqual(first, second)
		XCTAssertNotEqual(HealthRecordDetails.valueText(["a,b", "c"]), HealthRecordDetails.valueText(["a", "b,c"]))
		XCTAssertNotEqual(HealthRecordDetails.valueText("1"), HealthRecordDetails.valueText(1))
		XCTAssertNotEqual(HealthRecordDetails.valueText(true), HealthRecordDetails.valueText(1))
		XCTAssertTrue(first.contains("base64:AP8="))
	}
}
