//
//  Question.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class Question: NSObject {

	fileprivate(set) var questionText: String
	fileprivate var questionParts: [String]

	init(text: String) {
		questionText = text
		questionParts = [String]()
	}

	func parse() {
		normalizeNumbers()
		expandContractions()
		removePunctuation()
	}

	func answer() {

	}

	fileprivate func normalizeNumbers() {
		let numberFormatter:NumberFormatter = NumberFormatter()
		numberFormatter.numberStyle = NumberFormatter.Style.spellOut
		let numberWords = Set(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "sixteen", "seventeen", "eighteen", "nineteen", "twenty", "thirty", "fourty", "fifty", "sixty", "seventy", "eighty", "ninety", "hundred", "thousand", "million", "billion", "trillion", "quadrillion", "quintillion"])
		var englishNumber = String()
		for word in questionText.split(separator: " ") {
			if numberWords.contains(word.lowercased()) {
				englishNumber.append(contentsOf: word.lowercased())
			} else if !englishNumber.isEmpty {
				let number = String(numberFormatter.number(from: englishNumber)!.doubleValue)
				questionText = questionText.replacingOccurrences(of: englishNumber, with: number)
				englishNumber = String()
			}
		}
	}

	fileprivate func expandContractions() {
	}

	fileprivate func removePunctuation() {
		let punctuationRegex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]+")
		let questionTextLength = questionText.count
		questionText = punctuationRegex.stringByReplacingMatches(in: questionText, options: [], range: NSMakeRange(0, questionTextLength), withTemplate: "")
	}
}
