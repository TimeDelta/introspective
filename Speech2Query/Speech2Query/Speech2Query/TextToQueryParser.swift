//
//  TextToQueryParser.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/28/21.
//

import Foundation

import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
import Samples

// sourcery: AutoMockable
public protocol TextToQueryParser {

	func parseQuery(from text: String) -> Query?
}

/// Current version is simplistic.
///   - Currently, queries are only stack based instead of tree based, which would allow for a more expressive query language and require
///     a more complex implementation.
///   - It does not do coreference resolution in order to determine for which query in the stack an attribute restriction applies.
///   - It does not do re-ordering of the query stack.
///   - breaking example: "look at my meds and give me all moods within 5 mins of taking X"
public final class TextToQueryParserImpl: TextToQueryParser {

	private static let log = Log()

	private var query: Query?

	public final func parseQuery(from text: String) -> Query? {
		query = nil
		let tokens = tokenize(text)

		let sampleTypeClassifierModel = injected(SampleTypeClassifierFactory.self).getModel()
		let sampleTypePerToken = sampleTypeClassifierModel.classify(tokens)

		// split tokens based on same contiguous sample type so that
		// we can assume there is only one query in provided tokens
		var tokensSplitByQuery = [[Token]]()
		var currentTokenRun = [Token]()
		var currentRunSampleType: Sample.Type? = nil
		for i in 0..<sampleTypePerToken.count {
			if let currentTokenSampleType = sampleTypePerToken[i] {
				if currentTokenSampleType != currentRunSampleType && !currentTokenRun.isEmpty {
					if let currentRunSampleType = currentRunSampleType {
						do {
							try addToQuery(currentRunSampleType)
						} catch {
							log.error("Failed to add query for %@: %@", currentRunSampleType.name, errorInfo(error))
							return nil
						}
					}
					tokensSplitByQuery.append(currentTokenRun)
					currentTokenRun = [Token]()
				}
			}
			currentTokenRun.append(token)
		}

		guard var currentQuery = query else { // no sample types detected
			return nil
		}

		for tokensForCurrentQuery in tokensSplitByQuery {
			parseAttributeRestrictions(for: tokensForCurrentQuery, into: &currentQuery)
			if let subQuery = currentQuery.subQuery {
				currentQuery = subQuery
			}
		}
	}

	private func tokenize(_ text: String) -> [Token] {

	}

	private func addToQuery(_ sampleType: Sample.Type) throws {
		if let query = query {
			if let subQuery = query.subQuery {
				addToQuery(subQuery, sampleType)
			} else {
				query.subQuery = try injected(QueryFactory.self).queryFor(sampleType)
			}
		}
	}

	private func parseAttributeRestrictions(for tokens: [Token], into queryToPopulate: Query) {
		let attributeRestrictionModels = injected(AttributeRestrictionModelFactory.self).getAllAttributeRestrictionModels()
		for attributeRestrictionModel in attributeRestrictionModels {
			var tokenRunsForCurrentRestrictionType = [[Token]]()
			let predictions = attributeRestrictionModel.predict(for: tokens)
			var currentTokenRun = [Token]()
			for i in 0..<tokens.count {
				if predictions[i] {
					currentTokenRun.append(tokens[i])
				} else if currentTokenRun.count > 0 {
					tokenRunsForCurrentRestrictionType.append(currentTokenRun)
					currentTokenRun = [Token]();
				}
			}

			for tokenRun in tokenRunsForCurrentRestrictionType {
				let restrictionClass = type(of: attributeRestrictionModel).restrictionClass
				injected(AttributeRestrictionFactory.self).initialize(type: restrictionClass, forAttribute: ) -> AttributeRestriction
			}
		}
	}

	private func getQueryWithIndex(_ index: Int, from query: Query?) -> Query? {
		guard let query = query else { return nil }
		if index == 0 {
			return query
		}
		if let subQuery = query.subQuery {
			return getQueryWithIndex(index - 1, from: subQuery)
		}
		return nil
	}
}
