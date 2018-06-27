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
		case NotImplemented
		case ForgottenDataType
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
				let tagger = NLTagger(tagSchemes: [labelsTagScheme, .lexicalClass])
				let entireQuestionRange = Range(NSMakeRange(0, questionText.count), in: questionText.lowercased())!

				tagger.setModels([labelsModel], forTagScheme: labelsTagScheme)
				tagger.string = questionText.lowercased()

				tagger.enumerateTags(in: entireQuestionRange, unit: .word, scheme: labelsTagScheme, options: []) { (tag, tokenRange) -> Bool in
					let token = String(questionText[Range(uncheckedBounds: (lower: tokenRange.lowerBound, upper: tokenRange.upperBound))])
					self.labels.addLabel(Labels.Label(tag: tag!, token: token, tokenRange: tokenRange))
					return true
				}

				tagger.enumerateTags(in: entireQuestionRange, unit: .word, scheme: .lexicalClass, options: []) { (tag, tokenRange) -> Bool in
					if tag == .verb {
						self.labels.markTokenIn(range: tokenRange, asTag: Tags.verb)
					}
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

	func answer(callback: @escaping (Answer?, Error?) -> ()) {
		do {
			var questionParts = labels.splitBefore(tag: Tags.questionWord)

			// the question part with the verb next to the question word is the one containing the final return type
			questionParts = sort(questionParts, byShortestDistanceBetween: Tags.questionWord, and: Tags.verb).reversed()

			for questionPart in questionParts {
				let dataTypeLabels = questionPart.labelsFor(tags: Tags.dataTypeTags())
				if dataTypeLabels.count != 1 {
					throw ErrorTypes.NotImplemented
				}
				let dataTypeLabel = dataTypeLabels[0]
				switch (dataTypeLabel.tag) {
					case Tags.activityData:
						try answerActivityQuestionPart(questionPart)
						break
					case Tags.heartRateData:
						try answerHeartRateQuestionPart(questionPart)
						break
					case Tags.locationData:
						try answerLocationQuestionPart(questionPart)
						break
					case Tags.moodData:
						try answerMoodQuestionPart(questionPart)
						break
					case Tags.sleepData:
						try answerSleepQuestionPart(questionPart)
						break
					case Tags.workoutData:
						try answerWorkoutQuestionPart(questionPart)
						break
					default:
						os_log("if this ever happens, it means I missed a data type in this case statement: $@", type: .error, dataTypeLabel.tag.rawValue)
						throw ErrorTypes.ForgottenDataType
				}
			}

			// TODO
			callback(Answer(), nil)
		} catch {
			callback(nil, error)
		}
	}


	fileprivate func answerActivityQuestionPart(_ questionPart: Labels) throws {

	}

	fileprivate func answerLocationQuestionPart(_ questionPart: Labels) throws {

	}

	fileprivate func answerMoodQuestionPart(_ questionPart: Labels) throws {

	}

	fileprivate func answerSleepQuestionPart(_ questionPart: Labels) throws {

	}

	fileprivate func answerWorkoutQuestionPart(_ questionPart: Labels) throws {

	}

	fileprivate func answerHeartRateQuestionPart(_ questionPart: Labels) throws {
		var query = HeartRateQuery()

		let restrictionLabels = questionPart.labelsFor(tags: Tags.restrictionTypeTags())

		let operationLabels = questionPart.labelsFor(tags: Tags.operationTags())
		if operationLabels.count == 1 {
			query.finalOperation = try Operations.from(tag: operationLabels[0].tag)
		} else if operationLabels.count > 1 {
			throw ErrorTypes.NotImplemented
		}

		let returnTypeLabels = questionPart.labelsFor(tags: Tags.returnTypeTags())
		if !returnTypeLabels.isEmpty {

		}
	}

	fileprivate func sort(_ questionParts: [Labels], byShortestDistanceBetween tag1: NLTag, and tag2: NLTag) -> [Labels] {
		return questionParts.sorted(by: { (part1, part2) -> Bool in
			part1.shortestDistance(between: tag1, and: tag2) < part2.shortestDistance(between: tag1, and: tag2)
		})
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
