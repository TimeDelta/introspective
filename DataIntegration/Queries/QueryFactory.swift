//
//  QueryFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

//sourcery: AutoMockable
public protocol QueryFactory {
	func bloodPressureQuery() -> BloodPressureQuery
	func bmiQuery() -> BodyMassIndexQuery
	func heartRateQuery() -> HeartRateQuery
	func leanBodyMassQuery() -> LeanBodyMassQuery
	func moodQuery() -> MoodQuery
	func sexualActivityQuery() -> SexualActivityQuery
	func weightQuery() -> WeightQuery
}

public final class QueryFactoryImpl: QueryFactory {

	public enum Errors: Error {
		case UnknownSampleType
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

	public final func moodQuery() -> MoodQuery {
		return MoodQueryImpl()
	}

	public final func sexualActivityQuery() -> SexualActivityQuery {
		return SexualActivityQueryImpl()
	}

	public final func weightQuery() -> WeightQuery {
		return WeightQueryImpl()
	}
}
