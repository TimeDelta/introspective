//
//  SampleFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import Common
import HealthKit

import Persistence

// sourcery: AutoMockable
public protocol SampleFactory {
	func sampleTypeId(for sampleType: Sample.Type) -> Int16
	func sampleType(for id: Int16) throws -> Sample.Type

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
		Steps.self,
		Weight.self,
		ActiveEnergy.self,
		Workout.self,
		LostItemEvent.self,
		MetricContextEntry.self,
		StressCheckIn.self,
		StressorResponse.self,
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
		Steps.self,
		Weight.self,
		ActiveEnergy.self,
		Workout.self,
	]
	// Catalog availability is fixed for the life of this process.
	private static let availableTypes = allTypes + HealthCatalog.availableEntries.filter {
		$0.descriptor.id >= 21
	}.map { $0.sampleType }
	private static let availableHealthKitTypes = healthKitTypes + HealthCatalog.availableEntries.filter {
		$0.descriptor.id >= 21
	}.compactMap { $0.sampleType as? HealthKitSample.Type }

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
		case steps = 14
		case activeEnergy = 15
		case workout = 16
		case lostItem = 17
		case metricContext = 18
		case stressCheckIn = 19
		case stressorResponse = 20

		/// Ordered by enum value
		static fileprivate let sampleTypes: [Sample.Type] = [
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
			Steps.self,
			ActiveEnergy.self,
			Workout.self,
			LostItemEvent.self,
			MetricContextEntry.self,
			StressCheckIn.self,
			StressorResponse.self,
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
		if let descriptor = HealthCatalog.descriptor(for: sampleType) { return descriptor.id }
		return -1
	}

	public func sampleType(for id: Int16) throws -> Sample.Type {
		if SampleTypeId.sampleTypes.indices.contains(Int(id)) { return SampleTypeId.sampleTypes[Int(id)] }
		if HealthCatalog.descriptor(for: id) != nil { return try HealthCatalog.sampleType(for: id) }
		throw GenericError("Unsupported saved sample type.")
	}

	public final func allTypes() -> [Sample.Type] {
		Me.availableTypes
	}

	public final func healthKitTypes() -> [HealthKitSample.Type] {
		Me.availableHealthKitTypes
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
