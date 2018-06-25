//
//  Question.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

class Question: NSObject {

	enum ErrorTypes: Error {
		case CouldNotLoadModel
	}

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

	func answer() throws {
		if let modelUrl = Bundle.main.url(forResource: "questionLabels", withExtension: "mlmodel") {
			let labelsModel = try NLModel(contentsOf: modelUrl)
			let labelsTagScheme = NLTagScheme("QuestionLabelsTagScheme")
			let tagger = NLTagger(tagSchemes: [labelsTagScheme])
			tagger.setModels([labelsModel], forTagScheme: labelsTagScheme)
			tagger.string = questionText.lowercased()
			tagger.enumerateTags(in: Range(NSMakeRange(0, questionText.count), in: questionText.lowercased())!, unit: NLTokenUnit.word, scheme: labelsTagScheme, options: []) {
				(tag, tokenRange) -> Bool in
				return true
			}
		} else {
			throw ErrorTypes.CouldNotLoadModel
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

	fileprivate func expandContractions() {
		let contractionReplacements = [
			"ain't": "am not",
			"aren't": "are not",
			"can't": "cannot",
			"can't've": "cannot have",
			"'cause": "because",
			"could've": "could have",
			"couldn't": "could not",
			"couldn't've": "could not have",
			"didn't": "did not",
			"doesn't": "does not",
			"don't": "do not",
			"hadn't": "had not",
			"hadn't've": "had not have",
			"hasn't": "has not",
			"haven't": "have not",
			"he'd": "he would",
			"he'd've": "he would have",
			"he'll": "he will",
			"he'll've": "he will have",
			"he's": "he is",
			"how'd": "how did",
			"how'd'y": "how do you",
			"how'll": "how will",
			"how's": "how is",
			"I'd": "I would",
			"I'd've": "I would have",
			"I'll": "I will",
			"I'll've": "I will have",
			"I'm": "I am",
			"I've": "I have",
			"isn't": "is not",
			"it'd": "it had",
			"it'd've": "it would have",
			"it'll": "it will",
			"it'll've": "it will have",
			"it's": "it is",
			"let's": "let us",
			"ma'am": "madam",
			"mayn't": "may not",
			"might've": "might have",
			"mightn't": "might not",
			"mightn't've": "might not have",
			"must've": "must have",
			"mustn't": "must not",
			"mustn't've": "must not have",
			"needn't": "need not",
			"needn't've": "need not have",
			"o'clock": "of the clock",
			"oughtn't": "ought not",
			"oughtn't've": "ought not have",
			"shan't": "shall not",
			"sha'n't": "shall not",
			"shan't've": "shall not have",
			"she'd": "she would",
			"she'd've": "she would have",
			"she'll": "she will",
			"she'll've": "she will have",
			"she's": "she is",
			"should've": "should have",
			"shouldn't": "should not",
			"shouldn't've": "should not have",
			"so've": "so have",
			"so's": "so is",
			"that'd": "that would",
			"that'd've": "that would have",
			"that's": "that is",
			"there'd": "there had",
			"there'd've": "there would have",
			"there's": "there is",
			"they'd": "they would",
			"they'd've": "they would have",
			"they'll": "they will",
			"they'll've": "they will have",
			"they're": "they are",
			"they've": "they have",
			"to've": "to have",
			"wasn't": "was not",
			"we'd": "we had",
			"we'd've": "we would have",
			"we'll": "we will",
			"we'll've": "we will have",
			"we're": "we are",
			"we've": "we have",
			"weren't": "were not",
			"what'll": "what will",
			"what'll've": "what will have",
			"what're": "what are",
			"what's": "what is",
			"what've": "what have",
			"when's": "when is",
			"when've": "when have",
			"where'd": "where did",
			"where's": "where is",
			"where've": "where have",
			"who'll": "who will",
			"who'll've": "who will have",
			"who's": "who is",
			"who've": "who have",
			"why's": "why is",
			"why've": "why have",
			"will've": "will have",
			"won't": "will not",
			"won't've": "will not have",
			"would've": "would have",
			"wouldn't": "would not",
			"wouldn't've": "would not have",
			"y'all": "you all",
			"y'alls": "you alls",
			"y'all'd": "you all would",
			"y'all'd've": "you all would have",
			"y'all're": "you all are",
			"y'all've": "you all have",
			"you'd": "you had",
			"you'd've": "you would have",
			"you'll": "you you will",
			"you'll've": "you you will have",
			"you're": "you are",
			"you've": "you have"
		]

		// TODO
	}
}
