//
//  Token.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/30/21.
//

import Foundation

internal struct Token {

	var text: String
	/// index of this token within the original tokenized text. (Might be useful as a feature if normalized)
	var index: Int

	init(text: String, index: Int) {
		self.text = text
		self.index = index
	}
}
