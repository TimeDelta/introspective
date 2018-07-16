////
////  Question.swift
////  Data Integration
////
////  Created by Bryan Nova on 6/24/18.
////  Copyright © 2018 Bryan Nova. All rights reserved.
////
//
//import Foundation
//import NaturalLanguage
//import os
//
//public class TextQuestion: NSObject, Question {
//
//	public enum ErrorTypes: Error {
//		case CouldNotLoadModel
//		case NotImplemented
//		case ForgottenDataType // i forgot to add a data type
//		case MultipleDaysOfWeekNotSupported
//	}
//
//	fileprivate(set) var questionText: String
//	fileprivate var labels: Labels
//	fileprivate var questionParts: [Labels]
//	fileprivate var currentQuestionPartIndex: Int
//	fileprivate var finalAnswerCallback: ((Answer?, Error?) -> ())!
//
//	public init(text: String) {
//		questionText = text
//		labels = DependencyInjector.question.labels()
//		questionParts = [Labels]()
//		currentQuestionPartIndex = 0
//	}
//
//	public func parse(callback: (Error?) -> ()) {
//		questionText = DependencyInjector.util.textNormalizationUtil.normalizeNumbers(questionText)
//		questionText = DependencyInjector.util.textNormalizationUtil.expandContractions(questionText)
//		questionText = DependencyInjector.util.textNormalizationUtil.removePunctuation(questionText)
//
//		do {
////			if let modelUrl = Bundle.main.url(forResource: "questionLabels", withExtension: "mlmodel") {
////				let labelsModel = try NLModel(contentsOf: modelUrl)
////				let labelsTagScheme = NLTagScheme("QuestionLabelsTagScheme")
////				let tagger = NLTagger(tagSchemes: [labelsTagScheme, .lexicalClass])
////				let entireQuestionRange = Range(NSMakeRange(0, questionText.count), in: questionText.lowercased())!
////
////				tagger.setModels([labelsModel], forTagScheme: labelsTagScheme)
////				tagger.string = questionText.lowercased()
////
////				tagger.enumerateTags(in: entireQuestionRange, unit: .word, scheme: labelsTagScheme, options: []) { (tag, tokenRange) -> Bool in
////					let token = String(questionText[Range(uncheckedBounds: (lower: tokenRange.lowerBound, upper: tokenRange.upperBound))])
////					self.labels.addLabel(Labels.Label(tag: tag!, token: token, tokenRange: tokenRange))
////					return true
////				}
////
////				tagger.enumerateTags(in: entireQuestionRange, unit: .word, scheme: .lexicalClass, options: []) { (tag, tokenRange) -> Bool in
////					if tag == .verb {
////						self.labels.ifNotTaggedTagLabelAt(range: tokenRange, asTag: Tags.verb)
////					}
////					return true
////				}
////
////				callback(nil)
////			} else {
////				callback(ErrorTypes.CouldNotLoadModel)
////			}
//			let range = Range(NSMakeRange(0, questionText.count), in: questionText.lowercased())!
//
//			labels.addLabel(Labels.Label(tag: Tags.questionWord, token: "what", tokenRange: range))
//			labels.addLabel(Labels.Label(tag: Tags.verb, token: "is", tokenRange: range))
//			labels.addLabel(Labels.Label(tag: Tags.none, token: "my", tokenRange: range))
//			labels.addLabel(Labels.Label(tag: Tags.average, token: "average", tokenRange: range))
//			labels.addLabel(Labels.Label(tag: Tags.heartRateData, token: "heart", tokenRange: range))
//			labels.addLabel(Labels.Label(tag: Tags.heartRateData, token: "rate", tokenRange: range))
//			labels.addLabel(Labels.Label(tag: Tags.timeConstraint, token: "on", tokenRange: range))
//			labels.addLabel(Labels.Label(tag: Tags.dayOfWeek, token: "tuesdays", tokenRange: range))
//
//			callback(nil)
//		} catch {
//			callback(error)
//		}
//	}
//
//	public func answer(callback: @escaping (Answer?, Error?) -> ()) {
//		self.finalAnswerCallback = callback
//		questionParts = labels.splitBefore(tag: Tags.questionWord)
//
//		// the question part with the verb next to the question word is the one containing the final return type
//		questionParts = sort(questionParts, byShortestDistanceBetween: Tags.questionWord, and: Tags.verb).reversed()
//		answerNextQuestionPart(resultsFromPreviousPart: nil, error: nil)
//	}
//
//	fileprivate func answerNextQuestionPart(resultsFromPreviousPart: QueryResult<Sample>?, error: Error?) {
//		if currentQuestionPartIndex == questionParts.count {
//			// TODO - construct real Answer object
//			var answer = Answer()
//			finalAnswerCallback(answer, nil)
//		}
//
//		let questionPart = questionParts[currentQuestionPartIndex]
//		currentQuestionPartIndex += 1
//
//		let dataTypeLabels = questionPart.labelsInAnyOrderFor(tags: Tags.dataTypeTags())
//		if dataTypeLabels.count != 1 {
//			finalAnswerCallback(nil, ErrorTypes.NotImplemented)
//		}
//
//		do {
//			let dataTypeLabel = dataTypeLabels[0]
//			switch (dataTypeLabel.tag) {
//				case Tags.activityData:
//					answerActivityQuestionPart(questionPart)
//					break
//				case Tags.heartRateData:
//					answerHeartRateQuestionPart(questionPart)
//					break
//				case Tags.locationData:
//					answerLocationQuestionPart(questionPart)
//					break
//				case Tags.moodData:
//					answerMoodQuestionPart(questionPart)
//					break
//				case Tags.sleepData:
//					answerSleepQuestionPart(questionPart)
//					break
//				case Tags.workoutData:
//					answerWorkoutQuestionPart(questionPart)
//					break
//				default:
//					os_log("if this ever happens, it means I missed a data type in this case statement: $@", type: .error, dataTypeLabel.tag.rawValue)
//					throw ErrorTypes.ForgottenDataType
//			}
//		} catch {
//			finalAnswerCallback(nil, error)
//		}
//	}
//
//	fileprivate func answerActivityQuestionPart(_ questionPart: Labels) {
//
//	}
//
//	fileprivate func answerLocationQuestionPart(_ questionPart: Labels) {
//
//	}
//
//	fileprivate func answerMoodQuestionPart(_ questionPart: Labels) {
//
//	}
//
//	fileprivate func answerSleepQuestionPart(_ questionPart: Labels) {
//
//	}
//
//	fileprivate func answerWorkoutQuestionPart(_ questionPart: Labels) {
//
//	}
//
//	fileprivate func answerHeartRateQuestionPart(_ questionPart: Labels) {
//		DependencyInjector.querier.heartRateQuerier.getAuthorization() { (error: Error?) in
//			do {
//				if error != nil {
//					throw error!
//				}
//
//				let query = DependencyInjector.query.heartRateQuery()
//
////				let restrictionLabels = questionPart.labelsFor(tags: Tags.restrictionTypeTags())
//
//				// TODO - "on days that my heart rate goes abova 175" cases
//				let operationLabels = questionPart.labelsInAnyOrderFor(tags: Tags.operationTags())
//				if operationLabels.count == 1 {
//					query.finalOperation = try QueryOperation.from(tag: operationLabels[0].tag)
//				} else if operationLabels.count > 1 {
//					throw ErrorTypes.NotImplemented
//				}
//
//				let returnTypeLabels = questionPart.labelsInAnyOrderFor(tags: Tags.returnTypeTags())
//				if !returnTypeLabels.isEmpty {
//					// TODO
//				}
//
//				// TODO - "between last tuesday and today/now" cases
//				// TODO - "since last wednesday" cases
//				let dayOfWeekRestriction = try DependencyInjector.restrictionParser.dayOfWeekRestrictionParser.resolveDayOfWeekRestrictions(questionPart)
//				if dayOfWeekRestriction.date != nil {
//					query.startDate = dayOfWeekRestriction.date
//					query.endDate = dayOfWeekRestriction.date
//				} else if dayOfWeekRestriction.dayOfWeek != nil {
//					query.daysOfWeek.insert(dayOfWeekRestriction.dayOfWeek!)
//				}
//
//				query.runQuery(callback: self.answerNextQuestionPart)
//			} catch {
//				self.finalAnswerCallback(nil, error)
//			}
//		}
//	}
//
//	fileprivate func sort(_ questionParts: [Labels], byShortestDistanceBetween tag1: NLTag, and tag2: NLTag) -> [Labels] {
//		return questionParts.sorted(by: { (part1, part2) -> Bool in
//			part1.shortestDistance(between: tag1, and: tag2) < part2.shortestDistance(between: tag1, and: tag2)
//		})
//	}
//}
