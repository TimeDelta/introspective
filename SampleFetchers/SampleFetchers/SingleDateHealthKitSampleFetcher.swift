//
//  HealthKitSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import AttributeRestrictions
import Attributes
import BooleanAlgebra
import Common
import Queries
import Samples

public class SingleDateHealthKitSampleFetcher: SampleFetcher {
	private typealias Me = SingleDateHealthKitSampleFetcher

	private static let log = Log()

	public var sampleTypePluralName: String {
		Me.log.error("Forgot to override sampleTypePluralName for %@", String(describing: self))
		return ""
	}

	private final var queryCreator: () -> Query
	private final var dateAttribute: DateAttribute

	internal init(_ queryCreator: @escaping () -> Query, dateAttribute: DateAttribute) {
		self.queryCreator = queryCreator
		self.dateAttribute = dateAttribute
	}

	public final func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
		let query = queryCreator()
		if let min = minDate, let max = maxDate {
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: dateAttribute, date: min),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: dateAttribute, date: max)
			)
		} else if let min = minDate {
			query.expression = AfterDateAndTimeAttributeRestriction(restrictedAttribute: dateAttribute, date: min)
		} else if let max = maxDate {
			query.expression = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: dateAttribute, date: max)
		}

		var samples = [Sample]()
		var queryError: Error?
		let sync = DispatchGroup()
		sync.enter()
		query.runQuery { result, error in
			queryError = error
			if let resultingSamples = result?.samples {
				samples = resultingSamples
			}
			sync.leave()
		}
		sync.wait()
		if let queryError = queryError {
			throw queryError
		}
		return samples
	}
}
