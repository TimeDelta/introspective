//
//  SampleFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Persistence

// sourcery: AutoMockable
public protocol SampleFactory {
	func sampleTypeId(for sampleType: Sample.Type) -> Int16
	func sampleType(for id: Int16) -> Sample.Type

	func allTypes() -> [Sample.Type]
	func healthKitTypes() -> [HealthKitSample.Type]

	func activity(using transaction: Transaction) throws -> Activity
	func fatigue(using transaction: Transaction) throws -> Fatigue
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
		DietarySugar.self,
		FatigueImpl.self,
		HeartRate.self,
		LeanBodyMass.self,
		MedicationDose.self,
		MoodImpl.self,
		PainImpl.self,
		RestingHeartRate.self,
		SexualActivity.self,
		Sleep.self,
		Weight.self,
	]
	private static let healthKitTypes: [HealthKitSample.Type] = [
		BloodPressure.self,
		BodyMassIndex.self,
		DietarySugar.self,
		HeartRate.self,
		LeanBodyMass.self,
		RestingHeartRate.self,
		SexualActivity.self,
		Sleep.self,
		Weight.self,
	]

	/// IMPORTANT: Only add unique values to the end of this list otherwise saved queries will be messed up.
	private enum SampleTypeId: Int16 {
		case activity = 0
		case bloodPressure = 1
		case bmi = 2
		case dietarySugar = 3
		case fatigue = 4
		case heartRate = 5
		case leanBodyMass = 6
		case medicationDose = 7
		case mood = 8
		case pain = 9
		case restingHeartRate = 10
		case sexualActivity = 11
		case sleep = 12
		case weight = 13

		/// Ordered by enum value
		static fileprivate var sampleTypes: [Sample.Type] = [
			Activity.self,
			BloodPressure.self,
			BodyMassIndex.self,
			DietarySugar.self,
			FatigueImpl.self,
			HeartRate.self,
			LeanBodyMass.self,
			MedicationDose.self,
			MoodImpl.self,
			PainImpl.self,
			RestingHeartRate.self,
			SexualActivity.self,
			Sleep.self,
			Weight.self,
		]
	}

	public func sampleTypeId(for sampleType: Sample.Type) -> Int16 {
		var index: Int16 = 0
		for type in SampleTypeId.sampleTypes {
			if type == sampleType {
				return index
			}
			index += 1
		}
		return -1
	}

	public func sampleType(for id: Int16) -> Sample.Type {
		// if id is -1 here, means you forgot to add to the list of sample types above
		SampleTypeId.sampleTypes[Int(id)]
	}

	public final func allTypes() -> [Sample.Type] {
		Me.allTypes
	}

	public final func healthKitTypes() -> [HealthKitSample.Type] {
		Me.healthKitTypes
	}

	public final func activity(using transaction: Transaction) throws -> Activity {
		try transaction.new(Activity.self)
	}

	public final func fatigue(using transaction: Transaction) throws -> Fatigue {
		try transaction.new(FatigueImpl.self)
	}

	public final func heartRate(_ value: Double, _ date: Date) -> HeartRate {
		HeartRate(value, date)
	}

	public final func heartRate(value: Double) -> HeartRate {
		HeartRate(value)
	}

	public final func heartRate(_ sample: HKQuantitySample) -> HeartRate {
		HeartRate(sample)
	}

	public final func medicationDose(using transaction: Transaction) throws -> MedicationDose {
		try transaction.new(MedicationDose.self)
	}

	public final func mood(using transaction: Transaction) throws -> Mood {
		try transaction.new(MoodImpl.self)
	}
}
