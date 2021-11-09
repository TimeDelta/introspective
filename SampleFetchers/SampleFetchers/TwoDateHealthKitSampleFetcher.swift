//
//  TwoDateHealthKitSampleFetcher.swift
//  SampleFetchers
//
//  Created by Bryan Nova on 11/9/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import AttributeRestrictions
import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
import Samples

public class TwoDateHealthKitSampleFetcher: SampleFetcher {
	private typealias Me = TwoDateHealthKitSampleFetcher

	private static let log = Log()

	private final var queryCreator: () -> Query

	internal init(_ queryCreator: @escaping () -> Query) {
		self.queryCreator = queryCreator
	}

	public var sampleTypePluralName: String {
		Me.log.error("Forgot to override sampleTypePluralName for %@", String(describing: self))
		return ""
	}

	public func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
		let query = queryCreator()
		query.expression = getExpression(from: minDate, to: maxDate)

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

	private func getExpression(from minDate: Date?, to maxDate: Date?) -> BooleanExpression? {
		if let min = minDate, let max = maxDate {
			return OrExpression(
				AndExpression(
					after(CommonSampleAttributes.healthKitStartDate, min),
					before(CommonSampleAttributes.healthKitStartDate, max)
				),
				AndExpression(
					after(CommonSampleAttributes.healthKitEndDate, min),
					before(CommonSampleAttributes.healthKitEndDate, max)
				)
			)
		} else if let min = minDate {
			return OrExpression(
				after(CommonSampleAttributes.healthKitStartDate, min),
				after(CommonSampleAttributes.healthKitEndDate, min)
			)
		} else if let max = maxDate {
			return OrExpression(
				before(CommonSampleAttributes.healthKitStartDate, max),
				before(CommonSampleAttributes.healthKitStartDate, max)
			)
		}
		return nil
	}

	private func after(_ dateAttribute: DateAttribute, _ date: Date) -> BooleanExpression {
		AfterDateAndTimeAttributeRestriction(
			restrictedAttribute: dateAttribute,
			date: date
		)
	}

	private func before(_ dateAttribute: DateAttribute, _ date: Date) -> BooleanExpression {
		BeforeDateAndTimeAttributeRestriction(
			restrictedAttribute: dateAttribute,
			date: date
		)
	}
}
