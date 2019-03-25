//
//  QueryFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

//sourcery: AutoMockable
public protocol QueryFactory {
	func activityQuery() -> ActivityQuery
	func bloodPressureQuery() -> BloodPressureQuery
	func bmiQuery() -> BodyMassIndexQuery
	func heartRateQuery() -> HeartRateQuery
	func leanBodyMassQuery() -> LeanBodyMassQuery
	func medicationDoseQuery() -> MedicationDoseQuery
	func moodQuery() -> MoodQuery
	func restingHeartRateQuery() -> RestingHeartRateQuery
	func sexualActivityQuery() -> SexualActivityQuery
	func sleepQuery() -> SleepQuery
	func weightQuery() -> WeightQuery
	func queryFor(_ sampleType: Sample.Type) throws -> Query
}

public final class QueryFactoryImpl: QueryFactory {

	private final let log = Log()

	public final func activityQuery() -> ActivityQuery {
		return ActivityQueryImpl()
	}

	public final func bloodPressureQuery() -> BloodPressureQuery {
		return BloodPressureQueryImpl()
	}

	public final func bmiQuery() -> BodyMassIndexQuery {
		return BodyMassIndexQueryImpl()
	}

	public final func heartRateQuery() -> HeartRateQuery {
		return HeartRateQueryImpl()
	}

	public final func leanBodyMassQuery() -> LeanBodyMassQuery {
		return LeanBodyMassQueryImpl()
	}

	public final func medicationDoseQuery() -> MedicationDoseQuery {
		return MedicationDoseQueryImpl()
	}

	public final func moodQuery() -> MoodQuery {
		return MoodQueryImpl()
	}

	public final func restingHeartRateQuery() -> RestingHeartRateQuery {
		return RestingHeartRateQueryImpl()
	}

	public final func sexualActivityQuery() -> SexualActivityQuery {
		return SexualActivityQueryImpl()
	}

	public final func sleepQuery() -> SleepQuery {
		return SleepQueryImpl()
	}

	public final func weightQuery() -> WeightQuery {
		return WeightQueryImpl()
	}

	public func queryFor(_ sampleType: Sample.Type) throws -> Query {
		switch (sampleType) {
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
