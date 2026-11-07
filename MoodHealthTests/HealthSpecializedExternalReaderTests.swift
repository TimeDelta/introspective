import XCTest
import HealthKit
@testable import Samples

final class HealthSpecializedExternalReaderTests: XCTestCase {
	private func descriptor(_ identifier: String) throws -> HealthTypeDescriptor {
		try XCTUnwrap(HealthCatalog.descriptors.first { $0.identifier == identifier })
	}
	private func fields(_ record: HealthExternalRecord) -> [String: String] {
		Dictionary(uniqueKeysWithValues: record.sections.flatMap { $0.fields }.map { ($0.name, $0.value) })
	}

	func testProfilePreservesUnknownCodeWithoutInventingAnEventDate() throws {
		let type = try descriptor("HKCharacteristicTypeIdentifierBiologicalSex")
		let record = HealthExternalRecordReader.profileRecord(descriptor: type, code: 99)
		XCTAssertEqual(record.identifier, type.identifier)
		XCTAssertEqual(fields(record)["Recorded code"], "99")
		XCTAssertEqual(fields(record)[type.name], "Unknown (99)")
		XCTAssertTrue(record.dates.isEmpty)
	}

	func testBirthDateKeepsOriginalComponentsCalendarAndTimeZoneWithoutCreatingASampleTimestamp() throws {
		let type = try descriptor("HKCharacteristicTypeIdentifierDateOfBirth")
		var components = DateComponents()
		components.calendar = Calendar(identifier: .hebrew)
		components.timeZone = TimeZone(secondsFromGMT: 7200)
		components.era = 1; components.year = 5785; components.month = 6; components.day = 18
		components.isLeapMonth = true
		let record = HealthExternalRecordReader.profileRecord(descriptor: type, birthComponents: components)
		let values = fields(record)
		XCTAssertEqual(values["Year"], "5785"); XCTAssertEqual(values["Month"], "6")
		XCTAssertEqual(values["Day"], "18"); XCTAssertEqual(values["Leap month"], "true")
		XCTAssertEqual(values["Calendar"], "hebrew")
		XCTAssertEqual(values["Time zone"], components.timeZone?.identifier)
		XCTAssertTrue(record.dates.isEmpty)
	}

	func testPartialBirthDateDoesNotFillInMissingComponents() throws {
		let type = try descriptor("HKCharacteristicTypeIdentifierDateOfBirth")
		var components = DateComponents(); components.year = 1980
		let record = HealthExternalRecordReader.profileRecord(descriptor: type, birthComponents: components)
		XCTAssertEqual(fields(record), ["Year": "1980"])
		XCTAssertTrue(record.dates.isEmpty)
	}

	func testProfileReaderRequestsOnlySelectedCharacteristicAndUsesInjectedRead() throws {
		let type = try descriptor("HKCharacteristicTypeIdentifierBloodType")
		let expected = HealthExternalRecordReader.profileRecord(descriptor: type, code: 7)
		let completed = expectation(description: "Profile read")
		var requestedTypes = Set<String>()
		let reader = HealthExternalRecordReader(authorization: { types, completion in
			requestedTypes = Set(types.map { $0.identifier }); completion(nil)
		}, profileRead: { selected in
			XCTAssertEqual(selected, type); return expected
		})
		reader.read(descriptor: type) { result in
			do {
				let records = try result.get()
				XCTAssertEqual(records.count, 1)
				XCTAssertEqual(records.first?.identifier, type.identifier)
				XCTAssertEqual(records.first?.sections, expected.sections)
				XCTAssertTrue(records.first?.dates.isEmpty == true)
			} catch { XCTFail("Unexpected read error: \(error)") }
			completed.fulfill()
		}
		wait(for: [completed], timeout: 2)
		XCTAssertEqual(requestedTypes, [type.identifier])
	}

	func testCancellingBeforeAuthorizationCompletesDoesNotReadOrComplete() throws {
		let type = try descriptor("HKCharacteristicTypeIdentifierBiologicalSex")
		var authorizationCompletion: ((Error?) -> Void)?, reads = 0, completions = 0
		let reader = HealthExternalRecordReader(authorization: { _, completion in authorizationCompletion = completion },
			profileRead: { selected in
				reads += 1; return HealthExternalRecordReader.profileRecord(descriptor: selected, code: 0)
			})
		let cancel = reader.read(descriptor: type) { _ in completions += 1 }
		cancel(); authorizationCompletion?(nil)
		XCTAssertEqual(reads, 0); XCTAssertEqual(completions, 0)
	}

	func testFailedAuthorizationDoesNotReadProfileAndPreservesError() throws {
		let type = try descriptor("HKCharacteristicTypeIdentifierBiologicalSex")
		var reads = 0, result: Result<[HealthExternalRecord], Error>?
		let reader = HealthExternalRecordReader(authorization: { _, completion in
			completion(NSError(domain: "AuthorizationTest", code: 47))
		}, profileRead: { selected in
			reads += 1; return HealthExternalRecordReader.profileRecord(descriptor: selected, code: 0)
		})
		reader.read(descriptor: type) { result = $0 }
		XCTAssertEqual(reads, 0)
		XCTAssertThrowsError(try XCTUnwrap(result).get()) { XCTAssertEqual(($0 as NSError).code, 47) }
	}

	func testAttachmentCatalogEntryRequiresAParentInsteadOfRequestingBlanketAccess() throws {
		let type = try XCTUnwrap(HealthCatalog.descriptors.first { $0.family == .attachment })
		var authorizations = 0, result: Result<[HealthExternalRecord], Error>?
		let reader = HealthExternalRecordReader(authorization: { _, _ in authorizations += 1 })
		reader.read(descriptor: type) { result = $0 }
		XCTAssertEqual(authorizations, 0)
		XCTAssertThrowsError(try XCTUnwrap(result).get()) {
			XCTAssertEqual($0 as? HealthExternalReadError, .parentRecordRequired)
		}
	}

	func testSampleFamilyUsesSampleReaderWithoutRequestingExternalAuthorization() throws {
		let type = try descriptor("HKQuantityTypeIdentifierStepCount")
		var authorizations = 0, result: Result<[HealthExternalRecord], Error>?
		let reader = HealthExternalRecordReader(authorization: { _, _ in authorizations += 1 })
		reader.read(descriptor: type) { result = $0 }
		XCTAssertEqual(authorizations, 0)
		XCTAssertThrowsError(try XCTUnwrap(result).get()) {
			XCTAssertEqual($0 as? HealthExternalReadError, .unsupportedFamily(type.name))
		}
	}
}
