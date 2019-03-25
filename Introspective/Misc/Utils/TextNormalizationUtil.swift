//
//  ContractionsReplacementUtil.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol TextNormalizationUtil {
	func expandContractions(_ text: String) -> String
	func normalizeNumbers(_ text: String) -> String
	func removePunctuation(_ text: String) -> String
}

public final class TextNormalizationUtilImpl: TextNormalizationUtil {

	private typealias Me = TextNormalizationUtilImpl

	private static let contractions = [
		"ain't": "am not",
		"aren't": "are not",
		"can't've": "cannot have",
		"can't": "cannot",
		"'cause": "because",
		"could've": "could have",
		"couldn't've": "could not have",
		"couldn't": "could not",
		"didn't": "did not",
		"doesn't": "does not",
		"don't": "do not",
		"hadn't've": "had not have",
		"hadn't": "had not",
		"hasn't": "has not",
		"haven't": "have not",
		"he'd've": "he would have",
		"he'd": "he would",
		"he'll've": "he will have",
		"he'll": "he will",
		"he's": "he is",
		"how'd'y": "how do you",
		"how'd": "how did",
		"how'll": "how will",
		"how's": "how is",
		"I'd've": "I would have",
		"I'd": "I would",
		"I'll've": "I will have",
		"I'll": "I will",
		"I'm": "I am",
		"I've": "I have",
		"isn't": "is not",
		"it'd've": "it would have",
		"it'd": "it had",
		"it'll've": "it will have",
		"it'll": "it will",
		"it's": "it is",
		"let's": "let us",
		"ma'am": "madam",
		"mayn't": "may not",
		"might've": "might have",
		"mightn't've": "might not have",
		"mightn't": "might not",
		"must've": "must have",
		"mustn't've": "must not have",
		"mustn't": "must not",
		"needn't've": "need not have",
		"needn't": "need not",
		"oughtn't've": "ought not have",
		"oughtn't": "ought not",
		"shan't've": "shall not have",
		"shan't": "shall not",
		"sha'n't": "shall not",
		"she'd": "she would",
		"she'd've": "she would have",
		"she'll've": "she will have",
		"she'll": "she will",
		"she's": "she is",
		"should've": "should have",
		"shouldn't've": "should not have",
		"shouldn't": "should not",
		"so've": "so have",
		"so's": "so is",
		"that'd've": "that would have",
		"that'd": "that would",
		"that's": "that is",
		"there'd've": "there would have",
		"there'd": "there had",
		"there's": "there is",
		"they'd've": "they would have",
		"they'd": "they would",
		"they'll've": "they will have",
		"they'll": "they will",
		"they're": "they are",
		"they've": "they have",
		"to've": "to have",
		"wasn't": "was not",
		"we'd've": "we would have",
		"we'd": "we had",
		"we'll've": "we will have",
		"we'll": "we will",
		"we're": "we are",
		"we've": "we have",
		"weren't": "were not",
		"what'll've": "what will have",
		"what'll": "what will",
		"what're": "what are",
		"what's": "what is",
		"what've": "what have",
		"when's": "when is",
		"when've": "when have",
		"where'd": "where did",
		"where's": "where is",
		"where've": "where have",
		"who'll've": "who will have",
		"who'll": "who will",
		"who's": "who is",
		"who've": "who have",
		"why's": "why is",
		"why've": "why have",
		"will've": "will have",
		"won't've": "will not have",
		"won't": "will not",
		"would've": "would have",
		"wouldn't've": "would not have",
		"wouldn't": "would not",
		"y'all'd've": "you all would have",
		"y'all'd": "you all would",
		"y'all're": "you all are",
		"y'all've": "you all have",
		"y'all": "you all",
		"y'alls": "you alls",
		"you'd've": "you would have",
		"you'd": "you had",
		"you'll've": "you you will have",
		"you'll": "you you will",
		"you're": "you are",
		"you've": "you have"
	]

	private static let punctuationRegex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]+")
	private static let decimalEndingReplacementRegex = try! NSRegularExpression(pattern: "\\.?0+$")
	private static let numberOrderTokenEndingRegex = try! NSRegularExpression(pattern: "(st|nd|rd|th)$")

	private static let numberWordsArray = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety", "hundred", "thousand", "million", "billion", "trillion", "quadrillion", "quintillion"]
	private static let numberWords = Set<String>(numberWordsArray)
	private static let numberOrderTokensArray = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth", "thirteenth", "fourteenth", "fifteenth", "sixteenth", "seventeenth", "eighteenth", "nineteenth", "twentieth", "thirtieth", "fortieth", "fiftieth", "sixtieth", "seventieth", "eightieth", "ninetieth", "hundredth", "thousandth", "millionth", "billionth", "trillionth", "quadrillionth", "quintillionth"]
	private static let numberOrderTokens = Set<String>(numberOrderTokensArray)
	private static let hyphenatedNumberWords = Set<String>(["twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" ])

	public final func expandContractions(_ text: String) -> String {
		var expandedText = text
		for contractionReplacement in Me.contractions {
			expandedText = expandedText.replacingOccurrences(of: contractionReplacement.key, with: contractionReplacement.value)
		}
		return expandedText
	}

	public final func normalizeNumbers(_ text: String) -> String {
		var previousNumberWordShouldBeHyphenated = false
		var englishNumber = String()
		var finalText = text
		var additionalEnding: String? = nil
		let words = finalText.split(whereSeparator: { (char: Character) in
			return char == " " || char == "-"
		})
		for word in words {
			let token = String(word)
			if Me.numberWords.contains(token.lowercased()) {
				appendAppropriateSeparatorToEnglishNumber(&englishNumber, &previousNumberWordShouldBeHyphenated)
				englishNumber.append(token.lowercased())
				if Me.hyphenatedNumberWords.contains(token) {
					previousNumberWordShouldBeHyphenated = true
				}
			} else if Me.numberOrderTokens.contains(token) {
				let replacement = convertNumberOrderTokenToEnglishNumberWord(token.lowercased())
				finalText = finalText.replacingOccurrences(of: token, with: replacement)

				appendAppropriateSeparatorToEnglishNumber(&englishNumber, &previousNumberWordShouldBeHyphenated)
				englishNumber.append(replacement.lowercased())

				let endingMatch = Me.numberOrderTokenEndingRegex.firstMatch(in: token, options: [], range: NSMakeRange(0, token.count))
				additionalEnding = String(token[Range(endingMatch!.range, in: token)!])
			} else if !englishNumber.isEmpty {
				finalText = replaceEnglishNumber(text: finalText, englishNum: englishNumber, additionalEnding)
				englishNumber = String()
				additionalEnding = nil
				previousNumberWordShouldBeHyphenated = false
			}
		}
		if !englishNumber.isEmpty {
			finalText = replaceEnglishNumber(text: finalText, englishNum: englishNumber, additionalEnding)
		}
		return finalText
	}

	public final func removePunctuation(_ text: String) -> String {
		return Me.punctuationRegex.stringByReplacingMatches(in: text, options: [], range: NSMakeRange(0, text.count), withTemplate: "")
	}

	private func appendAppropriateSeparatorToEnglishNumber(_ englishNumber: inout String, _ previousNumberWordShouldBeHyphenated: inout Bool) {
		if previousNumberWordShouldBeHyphenated {
			englishNumber.append("-")
			previousNumberWordShouldBeHyphenated = false
		} else {
			englishNumber.append(" ")
		}
	}

	private func replaceEnglishNumber(text: String, englishNum: String, _ additionalEnding: String? = nil) -> String {
		let numberFormatter:NumberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .spellOut

		var englishNumber = englishNum.trimmingCharacters(in: CharacterSet([" "]))
		var number = String(numberFormatter.number(from: englishNumber)!.doubleValue)
		number = Me.decimalEndingReplacementRegex.stringByReplacingMatches(in: number, options: [], range: NSMakeRange(0, number.count), withTemplate: "")

		if additionalEnding != nil {
			number.append(additionalEnding!)
		}

		let separatorRegex = try! NSRegularExpression(pattern: "[ \\-]")
		englishNumber = separatorRegex.stringByReplacingMatches(in: englishNumber, options: [], range: NSMakeRange(0, englishNumber.count), withTemplate: "[ \\-]")
		let englishNumberRegex = try! NSRegularExpression(pattern: englishNumber)
		return englishNumberRegex.stringByReplacingMatches(in: text, options: [], range: NSMakeRange(0, text.count), withTemplate: number)
	}

	private func convertNumberOrderTokenToEnglishNumberWord(_ token: String) -> String {
		for i in 0 ..< Me.numberOrderTokensArray.count {
			if Me.numberOrderTokensArray[i] == token {
				return Me.numberWordsArray[i]
			}
		}
		return token
	}
}
