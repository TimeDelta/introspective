//
//  CSVMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 5/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
import CSV
@testable import Introspective

func csvContainsRow(withFields fields: [String]) -> Matcher<String?> {
	return csvContainsRow(withFields: fields.map{ equalTo($0) })
}

func csvContainsRow(withFields fields: [Matcher<String>]) -> Matcher<String?> {
	let fieldMatchersDescription = fields.map{ $0.description }.joined(separator: "\n\t")
	let matcherDescription = "CSV has row with fields:\n\t\(fieldMatchersDescription)"
	return Matcher(matcherDescription) { (fileContents: String?) -> MatchResult in
		guard let fileContents = fileContents else {
			return .mismatch("String is nil")
		}
		let csv = try! CSVReader(string: fileContents)
		while let currentRow = csv.next() {
			let rowMatcher = csvFields(matching: fields, baseIndentation: 2)
			if rowMatcher.matches(currentRow).boolValue {
				return .match
			}
		}
		return .mismatch("Did not find row with fields:\n\t\(fieldMatchersDescription)")
	}
}

/// Treat the tested `String` as the contents of a CSV file and match each
/// row with the corresponding field matchers in order.
/// - Note: Will fail match if actual is nil
/// - Parameter rows: Match each row of the CSV to the corresponding array of `String`s,
///                   treating each index of a given row as a separate field in that row.
func csvWithRows(_ rows: [[String]]) -> Matcher<String?> {
	return csvWithRows(rows.map{ row in
		row.map{ field in
			equalTo(field)
		}
	})
}

/// Treat the tested `String` as the contents of a CSV file and match each
/// row with the corresponding field matchers in order.
/// - Note: Will fail match if actual is nil
/// - Parameter rows: Match each row of the CSV to the corresponding array of `Matcher`s,
///                   treating each index of a given row as a separate field in that row.
func csvWithRows(_ expectedRows: [[Matcher<String>]]) -> Matcher<String?> {
	let matcherDescription = "CSV with \(expectedRows.count) rows"
	return Matcher(matcherDescription) { (fileContents: String?) -> MatchResult in
		guard let fileContents = fileContents else {
			return .mismatch("String is nil")
		}
		let csv = try! CSVReader(string: fileContents)

		var rows = [[String]]()
		while let row = csv.next() {
			rows.append(row)
		}
		if rows.count != expectedRows.count {
			return .mismatch("Expected \(expectedRows.count) rows; Found \(rows.count)")
		}

		var mismatches = [(index: Int, description: String?)]()
		for i in 0 ..< expectedRows.count {
			let rowMatcher = csvFields(matching: expectedRows[i], baseIndentation: 2)
			switch rowMatcher.matches(rows[i]) {
				case let .mismatch(mismatchDescription):
					mismatches.append((index: i, description: mismatchDescription))
				default: break
			}
		}

		if mismatches.count == 0 { return .match }
		let mismatchDescription = mismatches.map{
			"Row \($0.index + 1) does not match:\n\t\t\($0.description ?? "")"
		}.joined(separator: "\n\t")
		return .mismatch("\n\t" + mismatchDescription)
	}
}

/// Treat the tested `String` as the contents of a CSV file and match the
/// specified row with the given field values in order.
/// - Note: Will fail match if actual is nil
/// - Parameter rowNumber: Indexes start at 1
func csvWithRow(_ rowNumber: Int, matching fields: [String]) -> Matcher<String?> {
	return csvWithRow(rowNumber, matching: fields.map{ equalTo($0) })
}

/// Treat the tested `String` as the contents of a CSV file and match the
/// specified row with the given field matchers in order.
/// - Note: Will fail match if actual is nil
/// - Parameter rowNumber: Indexes start at 1
func csvWithRow(_ rowNumber: Int, matching fields: [Matcher<String>]) -> Matcher<String?> {
	let fieldMatchersDescription = fields.map{ $0.description }.joined(separator: "\n\t")
	let matcherDescription = "CSV with row \(rowNumber) fields:\n\t\(fieldMatchersDescription)"
	return Matcher(matcherDescription) { (fileContents: String?) -> MatchResult in
		guard let fileContents = fileContents else {
			return .mismatch("String is nil")
		}
		let csv = try! CSVReader(string: fileContents)
		var row = [String]()
		var currentRowNumber = 0
		while let currentRow = csv.next(), currentRowNumber < rowNumber {
			row = currentRow
			currentRowNumber += 1
		}
		if currentRowNumber == rowNumber {
			let rowMatcher = csvFields(matching: fields, baseIndentation: 2)
			return rowMatcher.matches(row)
		}
		return .mismatch("Only Found \(currentRowNumber) rows")
	}
}

func csvRowWith(fields: [String]) -> Matcher<String> {
	return csvRowWith(fields: fields.map{ equalTo($0) })
}

/// - Parameter expectedFields: Must match in order
func csvRowWith(fields expectedFields: [Matcher<String>], baseIndentation: Int = 0) -> Matcher<String> {
	let matcherDescription = "Row with fields:\n\t\(expectedFields.map{ $0.description }.joined(separator: "\n\t"))"
	return Matcher(matcherDescription) { (row: String) -> MatchResult in
		guard let fields = try! CSVReader(string: row).next() else {
			return .mismatch("Unable to parse CSV row")
		}
		return csvFields(matching: expectedFields, baseIndentation: baseIndentation).matches(fields)
	}
}

func csvFields(matching expectedFields: [String], baseIndentation: Int = 0) -> Matcher<[String]> {
	return csvFields(matching: expectedFields.map{ equalTo($0) }, baseIndentation: baseIndentation)
}

func csvFields(matching expectedFields: [Matcher<String>], baseIndentation: Int = 0) -> Matcher<[String]> {
	let matcherDescription = "Row with fields:\n\t\(expectedFields.map{ $0.description }.joined(separator: "\n\t"))"
	var indentation = ""
	for _ in 0 ..< baseIndentation {
		indentation += "\t"
	}
	return Matcher(matcherDescription) { (fields: [String]) -> MatchResult in
		if fields.count != expectedFields.count {
			return .mismatch("Expected \(expectedFields.count) fields but found \(fields.count) fields")
		}
		var mismatches = [(index: Int, description: String)]()
		for i in 0 ..< fields.count {
			let matcher = expectedFields[i]
			let value = fields[i]
			switch matcher.matches(value) {
				case let .mismatch(mismatchDescription):
					let defaultDescription = "\n\(indentation)\tEXPECTED: \(matcher.description)\n\(indentation)\tGOT: \(value)"
					let description = mismatchDescription
					mismatches.append((index: i, description: description ?? defaultDescription))
				default: break
			}
		}
		if mismatches.count == 0 { return .match }
		let mismatchDescription = mismatches.map{
			return "Field \($0.index + 1) does not match: \($0.description)"
		}.joined(separator: "\n\(indentation)")
		return .mismatch(mismatchDescription)
	}
}
