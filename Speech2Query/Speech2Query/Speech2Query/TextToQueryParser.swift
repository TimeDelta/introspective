//
//  TextToQueryParser.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/28/21.
//

import Foundation

import DependencyInjection

// sourcery: AutoMockable
public protocol TextToQueryParser {

	func parseQuery(from text: String) -> Query?
}

public final class TextToQueryParserImpl: TextToQueryParser {

	public final func parseQuery(from text: String) -> Query? {
		let attributeRestrictionModels = injected(AttributeRestrictionModelFactory.self).getAllAttributeRestrictionModels()
		let tokens = tokenize(text)
		for attributeRestrictionModel in attributeRestrictionModels {
			attributeRestrictionModel.predict(for: tokens)
		}
	}

	private func tokenize(_ text: String) -> [String] {
		
	}
}
