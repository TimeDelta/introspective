//
//  TextToQueryParser.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/28/21.
//

import Foundation

import AttributeRestrictions
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
public final class TextToQueryParserImpl: TextToQueryParser {

	public final func parseQuery(from text: String) -> Query? {
		let tokens = tokenize(text)

		let sampleTypeClassifierModel = injected(SampleTypeClassifierFactory.self).getModel()
		let sampleTypePerToken = sampleTypeClassifierModel.classify(tokens)
		var query: Query

		// split tokens based on same contiguous sample type so that
		// we can assume there is only one query in provided tokens
		var tokensSplitByQuery = [[Token]]()
		var currentTokenRun = [Token]()
		var currentRunSampleType: Sample.Type? = nil
		for i in 0..<sampleTypePerToken.count {
			if let currentTokenSampleType = sampleTypePerToken[i] {
				if currentTokenSampleType != currentRunSampleType && !currentTokenRun.isEmpty {
					tokensSplitByQuery.append(currentTokenRun)
					currentTokenRun = [Token]()
				}
			}
			currentTokenRun.append(token)
		}

		guard let query = query else { // no sample types detected
			return nil
		}

		for i in 0..<tokensSplitByQuery.count {
			parseAttributeRestrictions(for: tokensSplitByQuery[i])
		}
	}

	private func tokenize(_ text: String) -> [Token] {

	}

	private func parseAttributeRestrictions(for tokens: [Token]) {
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
					currentTokenRun = [String]();
				}
			}

			for tokenRun in tokenRunsForCurrentRestrictionType {
				let restrictionClass = type(of: attributeRestrictionModel).RestrictionClass
			}
		}
	}
}
