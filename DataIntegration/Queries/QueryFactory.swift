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
	func heartRateQuery() -> HeartRateQuery
	func moodQuery() -> MoodQuery
	func weightQuery() -> WeightQuery
	func bmiQuery() -> BodyMassIndexQuery
}

public final class QueryFactoryImpl: QueryFactory {

	public enum Errors: Error {
		case UnknownSampleType
	}

	public final func heartRateQuery() -> HeartRateQuery {
		return HeartRateQueryImpl()
	}

	public final func moodQuery() -> MoodQuery {
		return MoodQueryImpl()
	}

	public final func weightQuery() -> WeightQuery {
		return WeightQueryImpl()
	}

	public final func bmiQuery() -> BodyMassIndexQuery {
		return BodyMassIndexQueryImpl()
	}
}
