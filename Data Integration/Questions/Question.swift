//
//  Question.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage
import os

class Question: NSObject {

	enum ErrorTypes: Error {
		case CouldNotLoadModel
	}

	fileprivate(set) var questionText: String
	fileprivate var labels: Labels

	init(text: String) {
		questionText = text
		labels = Labels()
	}

	func parse(callback: (Error?) -> ()) {
		normalizeNumbers()
		questionText = ContractionsReplacementUtil.expand(questionText)
		removePunctuation()

		do {
			if let modelUrl = Bundle.main.url(forResource: "questionLabels", withExtension: "mlmodel") {
				let labelsModel = try NLModel(contentsOf: modelUrl)
				let labelsTagScheme = NLTagScheme("QuestionLabelsTagScheme")
				let tagger = NLTagger(tagSchemes: [labelsTagScheme])

				tagger.setModels([labelsModel], forTagScheme: labelsTagScheme)
				tagger.string = questionText.lowercased()
				tagger.enumerateTags(in: Range(NSMakeRange(0, questionText.count), in: questionText.lowercased())!, unit: NLTokenUnit.word, scheme: labelsTagScheme, options: []) {
					(tag, tokenRange) -> Bool in

					let token = String(questionText[Range(uncheckedBounds: (lower: tokenRange.lowerBound, upper: tokenRange.upperBound))])
					self.labels.addLabel(Labels.Label(tag: tag!, token: token))

					return true
				}
				callback(nil)
			} else {
				callback(ErrorTypes.CouldNotLoadModel)
			}
		} catch {
			callback(error)
		}
	}

	func answer(callback: (Answer?, Error?) -> ()) {
		do {

		} catch {
			callback(nil, error)
		}
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

	fileprivate func removePunctuation() {
		let punctuationRegex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]+")
		let questionTextLength = questionText.count
		questionText = punctuationRegex.stringByReplacingMatches(in: questionText, options: [], range: NSMakeRange(0, questionTextLength), withTemplate: "")
	}
}
