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

public final class TextToQueryParserImpl: TextToQueryParser {

	public final func parseQuery(from text: String) -> Query? {
		let tokens = tokenize(text)

		let sampleTypeClassifierModel = injected(SampleTypeClassifierFactory.self).getModel()
		let sampleTypes = sampleTypeClassifierModel.classify(tokens)
		var query: Query
		// assume left to right ordering for query stack
		for sampleType in sampleTypes {
			if let sampleType = sampleType {
				if query == nil {
					query = injected(QueryFactory.self).queryFor(sampleType)
				}
			}
		}

		guard let query = query else { // no sample types detected
			return nil
		}

		let attributeRestrictionModels = injected(AttributeRestrictionModelFactory.self).getAllAttributeRestrictionModels()
		for attributeRestrictionModel in attributeRestrictionModels {
			var tokenRunsForCurrentRestrictionType = [[String]]()
			let predictions = attributeRestrictionModel.predict(for: tokens)
			var currentTokenStretch = [String]()
			for i in 0..<tokens.count {
				if predictions[i] {
					currentTokenStretch.append(tokens[i])
				} else if currentTokenStretch.count > 0 {
					tokenRunsForCurrentRestrictionType.append(currentTokenStretch)
					currentTokenStretch = [String]();
				}
			}

			for tokenRun in tokenRunsForCurrentRestrictionType {
				let restrictionClass = type(of: attributeRestrictionModel).RestrictionClass
			}
		}
	}

	private func tokenize(_ text: String) -> [String] {

	}
}
