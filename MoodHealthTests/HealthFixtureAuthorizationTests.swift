import XCTest
import HealthKit
@testable import Samples

final class HealthFixtureAuthorizationTests: XCTestCase {
	private func identifiers<T: HKObjectType>(_ types: Set<T>) -> Set<String> {
		Set(types.map { $0.identifier })
	}

	func testSelectedFixturesRequestOnlyTheirWriteTypesWithoutReadingHealthData() {
		let permissions = HealthKitDataTestUtil.fixturePermissions(for: [Weight.self, Sleep.self, MoodImpl.self])
		XCTAssertEqual(identifiers(permissions.write), [HKQuantityTypeIdentifier.bodyMass.rawValue,
			HKCategoryTypeIdentifier.sleepAnalysis.rawValue])
		XCTAssertTrue(permissions.read.isEmpty)
	}

	func testBloodPressureUsesItsTwoWritableComponentsAndNeverRequestsCorrelationAuthorization() {
		let permissions = HealthKitDataTestUtil.fixturePermissions(for: [BloodPressure.self], includingReadAccess: true)
		let expected: Set<String> = [HKQuantityTypeIdentifier.bloodPressureSystolic.rawValue,
			HKQuantityTypeIdentifier.bloodPressureDiastolic.rawValue]
		XCTAssertEqual(identifiers(permissions.write), expected)
		XCTAssertEqual(identifiers(permissions.read), expected)
		XCTAssertFalse(permissions.read.contains(BloodPressure.sampleType))
	}

	func testReadOnlyCatalogAndLocalTypesNeverAddFixturePermissionsEvenForLegacyReadback() {
		let catalog = HealthCatalog.availableEntries.filter { $0.descriptor.id >= 21 }.map { $0.sampleType }
		XCTAssertFalse(catalog.isEmpty)
		let types: [Sample.Type] = catalog + [MoodImpl.self, ActiveEnergy.self, Workout.self]
		let permissions = HealthKitDataTestUtil.fixturePermissions(for: types, includingReadAccess: true)
		XCTAssertTrue(permissions.write.isEmpty)
		XCTAssertTrue(permissions.read.isEmpty)
	}

	func testLegacyFixtureReadbackKeepsOnlyLegacyWriterPermissionsWhenFactoryContainsExpandedCatalog() {
		let types = SampleFactoryImpl().healthKitTypes().map { $0 as Sample.Type }
		let permissions = HealthKitDataTestUtil.fixturePermissions(for: types, includingReadAccess: true)
		let expected: Set<String> = [
			HKQuantityTypeIdentifier.bloodPressureSystolic.rawValue,
			HKQuantityTypeIdentifier.bloodPressureDiastolic.rawValue,
			HKQuantityTypeIdentifier.bodyMassIndex.rawValue,
			HKQuantityTypeIdentifier.dietarySugar.rawValue,
			HKQuantityTypeIdentifier.heartRate.rawValue,
			HKQuantityTypeIdentifier.leanBodyMass.rawValue,
			HKQuantityTypeIdentifier.restingHeartRate.rawValue,
			HKCategoryTypeIdentifier.sexualActivity.rawValue,
			HKCategoryTypeIdentifier.sleepAnalysis.rawValue,
			HKQuantityTypeIdentifier.stepCount.rawValue,
			HKQuantityTypeIdentifier.bodyMass.rawValue,
		]
		XCTAssertEqual(identifiers(permissions.write), expected)
		XCTAssertEqual(identifiers(permissions.read), expected)
	}

	func testGenerationAuthorizationUsesSelectedWriteSetAndCompletesAfterInjectedRequest() {
		var finish: ((Bool, Error?) -> Void)?
		var requests = 0, completions = 0
		HealthKitDataTestUtil.requestGenerationAuthorization(for: [Weight.self, Weight.self, MoodImpl.self],
			authorizationRequest: { write, read, completion in
				requests += 1
				XCTAssertEqual(self.identifiers(write), [HKQuantityTypeIdentifier.bodyMass.rawValue])
				XCTAssertTrue(read.isEmpty)
				finish = completion
			}, completion: { error in
				XCTAssertNil(error); completions += 1
			})
		XCTAssertEqual(requests, 1)
		XCTAssertEqual(completions, 0)
		finish?(true, nil)
		XCTAssertEqual(completions, 1)
	}

	func testLocalOnlyAndReadOnlySelectionsCompleteWithoutAnAuthorizationRequest() {
		let catalog = HealthCatalog.availableEntries.filter { $0.descriptor.id >= 21 }.map { $0.sampleType }
		for types in [[], [MoodImpl.self, Workout.self] as [Sample.Type], catalog] {
			var requests = 0, completions = 0
			HealthKitDataTestUtil.requestGenerationAuthorization(for: types, authorizationRequest: { _, _, _ in
				requests += 1
			}, completion: { error in
				XCTAssertNil(error); completions += 1
			})
			XCTAssertEqual(requests, 0)
			XCTAssertEqual(completions, 1)
		}
	}

	func testIncompleteGenerationAuthorizationReturnsAnErrorInsteadOfStartingWrites() {
		var result: Error?, completions = 0
		HealthKitDataTestUtil.requestGenerationAuthorization(for: [Weight.self], authorizationRequest: { _, _, completion in
			completion(false, nil)
		}, completion: { error in result = error; completions += 1 })
		XCTAssertEqual(result as? HealthReadAuthorizationError, .requestCanceled)
		XCTAssertEqual(completions, 1)
	}

	func testGenerationAuthorizationPreservesTheUnderlyingError() {
		let expected = NSError(domain: "FixtureAuthorization", code: 47,
			userInfo: [NSLocalizedDescriptionKey: "Fixture access could not complete"])
		var result: Error?
		HealthKitDataTestUtil.requestGenerationAuthorization(for: [Weight.self], authorizationRequest: { _, _, completion in
			completion(false, expected)
		}, completion: { result = $0 })
		XCTAssertEqual((result as NSError?)?.domain, expected.domain)
		XCTAssertEqual((result as NSError?)?.code, expected.code)
		XCTAssertEqual(result?.localizedDescription, expected.localizedDescription)
	}
}
