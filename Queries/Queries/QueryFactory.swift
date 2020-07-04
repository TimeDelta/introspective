//
//  QueryFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

import BooleanAlgebra
import Common
import Samples

// sourcery: AutoMockable
public protocol QueryFactory {
	func activityQuery() -> ActivityQuery
	func activityQuery(_ parts: [BooleanExpressionPart]) throws -> ActivityQuery
	func bloodPressureQuery() -> BloodPressureQuery
	func bloodPressureQuery(_ parts: [BooleanExpressionPart]) throws -> BloodPressureQuery
	func bmiQuery() -> BodyMassIndexQuery
	func bmiQuery(_ parts: [BooleanExpressionPart]) throws -> BodyMassIndexQuery
	func heartRateQuery() -> HeartRateQuery
	func heartRateQuery(_ parts: [BooleanExpressionPart]) throws -> HeartRateQuery
	func leanBodyMassQuery() -> LeanBodyMassQuery
	func leanBodyMassQuery(_ parts: [BooleanExpressionPart]) throws -> LeanBodyMassQuery
	func medicationDoseQuery() -> MedicationDoseQuery
	func medicationDoseQuery(_ parts: [BooleanExpressionPart]) throws -> MedicationDoseQuery
	func moodQuery() -> MoodQuery
	func moodQuery(_ parts: [BooleanExpressionPart]) throws -> MoodQuery
	func restingHeartRateQuery() -> RestingHeartRateQuery
	func restingHeartRateQuery(_ parts: [BooleanExpressionPart]) throws -> RestingHeartRateQuery
	func sexualActivityQuery() -> SexualActivityQuery
	func sexualActivityQuery(_ parts: [BooleanExpressionPart]) throws -> SexualActivityQuery
	func sleepQuery() -> SleepQuery
	func sleepQuery(_ parts: [BooleanExpressionPart]) throws -> SleepQuery
	func weightQuery() -> WeightQuery
	func weightQuery(_ parts: [BooleanExpressionPart]) throws -> WeightQuery
	func queryFor(_ sampleType: Sample.Type) throws -> Query
}

public final class QueryFactoryImpl: QueryFactory {
	private final let log = Log()

	public final func activityQuery() -> ActivityQuery {
		ActivityQueryImpl()
	}

	public final func activityQuery(_ parts: [BooleanExpressionPart]) throws -> ActivityQuery {
		try ActivityQueryImpl(parts: parts)
	}

	public final func bloodPressureQuery() -> BloodPressureQuery {
		BloodPressureQueryImpl()
	}

	public final func bloodPressureQuery(_ parts: [BooleanExpressionPart]) throws -> BloodPressureQuery {
		try BloodPressureQueryImpl(parts: parts)
	}

	public final func bmiQuery() -> BodyMassIndexQuery {
		BodyMassIndexQueryImpl()
	}

	public final func bmiQuery(_ parts: [BooleanExpressionPart]) throws -> BodyMassIndexQuery {
		try BodyMassIndexQueryImpl(parts: parts)
	}

	public final func heartRateQuery() -> HeartRateQuery {
		HeartRateQueryImpl()
	}

	public final func heartRateQuery(_ parts: [BooleanExpressionPart]) throws -> HeartRateQuery {
		try HeartRateQueryImpl(parts: parts)
	}

	public final func leanBodyMassQuery() -> LeanBodyMassQuery {
		LeanBodyMassQueryImpl()
	}

	public final func leanBodyMassQuery(_ parts: [BooleanExpressionPart]) throws -> LeanBodyMassQuery {
		try LeanBodyMassQueryImpl(parts: parts)
	}

	public final func medicationDoseQuery() -> MedicationDoseQuery {
		MedicationDoseQueryImpl()
	}

	public final func medicationDoseQuery(_ parts: [BooleanExpressionPart]) throws -> MedicationDoseQuery {
		try MedicationDoseQueryImpl(parts: parts)
	}

	public final func moodQuery() -> MoodQuery {
		MoodQueryImpl()
	}

	public final func moodQuery(_ parts: [BooleanExpressionPart]) throws -> MoodQuery {
		try MoodQueryImpl(parts: parts)
	}

	public final func restingHeartRateQuery() -> RestingHeartRateQuery {
		RestingHeartRateQueryImpl()
	}

	public final func restingHeartRateQuery(_ parts: [BooleanExpressionPart]) throws -> RestingHeartRateQuery {
		try RestingHeartRateQueryImpl(parts: parts)
	}

	public final func sexualActivityQuery() -> SexualActivityQuery {
		SexualActivityQueryImpl()
	}

	public final func sexualActivityQuery(_ parts: [BooleanExpressionPart]) throws -> SexualActivityQuery {
		try SexualActivityQueryImpl(parts: parts)
	}

	public final func sleepQuery() -> SleepQuery {
		SleepQueryImpl()
	}

	public final func sleepQuery(_ parts: [BooleanExpressionPart]) throws -> SleepQuery {
		try SleepQueryImpl(parts: parts)
	}

	public final func weightQuery() -> WeightQuery {
		WeightQueryImpl()
	}

	public final func weightQuery(_ parts: [BooleanExpressionPart]) throws -> WeightQuery {
		try WeightQueryImpl(parts: parts)
	}

	public func queryFor(_ sampleType: Sample.Type) throws -> Query {
		switch sampleType {
		case is Activity.Type: return activityQuery()
		case is BloodPressure.Type: return bloodPressureQuery()
		case is BodyMassIndex.Type: return bmiQuery()
		case is HeartRate.Type: return heartRateQuery()
		case is LeanBodyMass.Type: return leanBodyMassQuery()
		case is MedicationDose.Type: return medicationDoseQuery()
		case is Mood.Type: return moodQuery()
		case is RestingHeartRate.Type: return restingHeartRateQuery()
		case is SexualActivity.Type: return sexualActivityQuery()
		case is Sleep.Type: return sleepQuery()
		case is Weight.Type: return weightQuery()
		default:
			throw UnknownSampleTypeError(sampleType)
		}
	}
}
