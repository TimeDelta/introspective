//
//  Matchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest
import CoreData
import CSV
@testable import Introspective

typealias UserInfo = [AnyHashable: Any]

// MARK: - Misc. Matchers

func groupExists(withDate date: Date, andSamples samples: [Sample]) -> Matcher<[(Any, [Sample])]> {
	return Matcher("Group with date \(date.debugDescription)") { groups -> MatchResult in
		guard let group = groups.first(where: { group in return group.0 as? Date == date }) else {
			return .mismatch("Missing group with date: \(date)")
		}
		let unexpectedSamples = group.1.filter({ sample in !samples.contains(where: { $0.equalTo(sample) }) })
		var mismatchMessage = ""
		if unexpectedSamples.count != 0 {
			mismatchMessage += "\(unexpectedSamples.count) unexpected Samples: \(unexpectedSamples.debugDescription)\n"
		}
		let missingSamples = samples[0...1].filter({ expectedSample in return !group.1.contains(where: { $0.equalTo(expectedSample) }) })
		if missingSamples.count != 0 {
			mismatchMessage += "\(missingSamples.count) missing Samples for \(date.description): \(missingSamples.debugDescription)"
		}
		if !mismatchMessage.isEmpty {
			return .mismatch(mismatchMessage)
		}
		return .match
	}
}

func noneStoredInDatabase<Type: NSManagedObject & CoreDataObject>() -> Matcher<Type.Type> {
	return Matcher("No \(Type.entityName) exists") { _ -> MatchResult in
		let count = try! DependencyInjector.db.query(Type.fetchRequest() as! NSFetchRequest<Type>).count
		if count == 0 { return .match }
		return .mismatch("Found \(count) \(Type.entityName)")
	}
}

// MARK: - Activity Matchers

func equivalentDoesNotExistInDatabase() -> Matcher<Activity> {
	return Matcher("does not exist") { activity -> MatchResult in
		let activities = try! DependencyInjector.db.query(Activity.fetchRequest())
		if activities.contains(where: { $0.equalTo(activity) }) {
			return .mismatch("\(activity.debugDescription) exists in database")
		}
		return .match
	}
}

// MARK: - UserInfo Matchers

func userInfoHasKey(_ key: AnyHashable) -> Matcher<UserInfo?> {
	return Matcher("User Info has \"\(key.description)\" key") { (userInfo: UserInfo?) -> MatchResult in
		guard let userInfo = userInfo else {
			return .mismatch("User Info was nil")
		}
		if !userInfo.keys.contains(key) {
			return .mismatch("User Info does not contain \"\(key.description)\" key")
		}
		return .match
	}
}

func userInfoHasKey<ValueType: Equatable>(_ key: AnyHashable, withValue expectedValiue: ValueType) -> Matcher<UserInfo?> {
	return userInfoHasKey(key, withValue: expectedValiue, { $0 == $1 })
}

func userInfoHasKey<ValueType>(
	_ key: AnyHashable,
	withValue expectedValue: ValueType,
	_ equalTo: @escaping (ValueType, ValueType) -> Bool)
-> Matcher<UserInfo?> {
	let matcherDescription = "User Info has \"\(key.description)\" key with value \"\(String(describing: expectedValue))\""
	return Matcher(matcherDescription) { (userInfo: UserInfo?) -> MatchResult in
		guard let userInfo = userInfo else {
			return .mismatch("User Info was nil")
		}
		if !userInfo.keys.contains(key) {
			return .mismatch("User Info does not contain \"\(key.description)\" key")
		}
		guard let actualValue = userInfo[key] as? ValueType else {
			return .mismatch("Value for \"\(key.description)\" is not a \(String(describing: ValueType.self))")
		}
		if equalTo(actualValue, expectedValue) {
			return .match
		}
		return .mismatch("Value for \"\(key.description)\" is \"\(String(describing: actualValue))\"")
	}
}

// MARK: - String Matchers

/// - Note: Will fail match if actual is nil
func containsLine(_ matcher: Matcher<String>) -> Matcher<String?> {
	return Matcher("Contains line \(matcher.description)") { (text: String?) -> MatchResult in
		guard let text = text else {
			return .mismatch("String is nil")
		}
		let lines = text.split(separator: "\n")
		if lines.count == 0 {
			return .mismatch("String is empty")
		}
		for line in lines {
			if matcher.matches(String(line)).boolValue {
				return .match
			}
		}
		return .mismatch("No line found \(matcher.description)")
	}
}

/// - Note: Will fail match if actual is nil
/// - Parameter lineNumber: Indexes start at 1
func line(_ lineNumber: Int, _ matcher: Matcher<String>) -> Matcher<String?> {
	return Matcher("Line \(lineNumber) \(matcher.description)") { (text: String?) -> MatchResult in
		guard let text = text else {
			return .mismatch("String is nil")
		}
		let lines = text.split(separator: "\n")
		if lines.count == 0 {
			return .mismatch("String is empty")
		}
		if lines.count < lineNumber {
			return .mismatch("Only \(lines.count) lines found")
		}
		return matcher.matches(String(lines[lineNumber - 1]))
	}
}

// MARK: - CSV Matchers

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

// MARK: - Helpers

func delegateMatching<T>(_ value: T, _ matcher: Matcher<T>, _ mismatchDescriber: (String?) -> String?) -> MatchResult {
	switch matcher.matches(value) {
		case .match:
			return .match
		case let .mismatch(mismatchDescription):
			return .mismatch(mismatchDescriber(mismatchDescription))
	}
}

func getMismatchDescription<T>(_ matcher: Matcher<T>, value: T) -> (MatchResult, String?) {
	let matchResult = matcher.matches(value)
	switch matchResult {
		case let .mismatch(mismatchDescription): return (matchResult, mismatchDescription)
		default: return (matchResult, nil)
	}
}
