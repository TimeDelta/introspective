//
//  SampleFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol SampleFactory {

	func allTypes() -> [Sample.Type]
	func healthKitTypes() -> [HealthKitSample.Type]

	func activity(using transaction: Transaction) throws -> Activity
	func heartRate(_ value: Double, _ date: Date) -> HeartRate
	func heartRate(value: Double) -> HeartRate
	func heartRate(_ sample: HKQuantitySample) -> HeartRate
	func medicationDose(using transaction: Transaction) throws -> MedicationDose
	func mood(using transaction: Transaction) throws -> Mood
}

public final class SampleFactoryImpl: SampleFactory {

	private typealias Me = SampleFactoryImpl
	private static let allTypes: [Sample.Type] = [
		Activity.self,
		BloodPressure.self,
		BodyMassIndex.self,
		HeartRate.self,
		LeanBodyMass.self,
		MedicationDose.self,
		MoodImpl.self,
		RestingHeartRate.self,
		SexualActivity.self,
		Sleep.self,
		Weight.self,
	]
	private static let healthKitTypes: [HealthKitSample.Type] = [
		BloodPressure.self,
		BodyMassIndex.self,
		HeartRate.self,
		LeanBodyMass.self,
		RestingHeartRate.self,
		SexualActivity.self,
		Sleep.self,
		Weight.self,
	]

	public final func allTypes() -> [Sample.Type] {
		return Me.allTypes
	}

	public final func healthKitTypes() -> [HealthKitSample.Type] {
		return Me.healthKitTypes
	}

	public final func activity(using transaction: Transaction) throws -> Activity {
		return try transaction.new(Activity.self)
	}

	public final func heartRate(_ value: Double, _ date: Date) -> HeartRate {
		return HeartRate(value, date)
	}

	public final func heartRate(value: Double) -> HeartRate {
		return HeartRate(value)
	}

	public final func heartRate(_ sample: HKQuantitySample) -> HeartRate {
		return HeartRate(sample)
	}

	public final func medicationDose(using transaction: Transaction) throws -> MedicationDose {
		return try transaction.new(MedicationDose.self)
	}

	public final func mood(using transaction: Transaction) throws -> Mood {
		return try transaction.new(MoodImpl.self)
	}
}
