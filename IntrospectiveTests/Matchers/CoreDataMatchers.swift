//
//  CoreDataMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/8/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Hamcrest
import Foundation

@testable import Common
@testable import DependencyInjection
@testable import Introspective
@testable import Persistence

func exists<SubType: NSManagedObject & CoreDataObject, InfoType: Info>(_ type: SubType.Type) -> Matcher<InfoType> {
	return Matcher("") { expectedInfo -> MatchResult in
		do {
			let namedPredicates = expectedInfo.getPredicates()
			let predicatesOnly = namedPredicates.map{ (k, v) -> NSPredicate in v}
			let request = NSFetchRequest<NSManagedObject>(entityName: SubType.entityName)
			let allOfSubType = try injected(Database.self).query(request)
			if allOfSubType.count == 0 {
				return .mismatch("No matching \(SubType.entityName) found")
			}

			let mainPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicatesOnly)
			let matchingObjects = (allOfSubType as NSArray).filtered(using: mainPredicate)
			if matchingObjects.count == 1 {
				return .match
			}
			if matchingObjects.count > 1 {
				return .mismatch("Found \(matchingObjects.count) matching \(SubType.entityName) entries")
			}

			let closest: (similarity: Int, differences: [IndividualObjectDifference<SubType>]) = getClosestActuals(
				allOfSubType: allOfSubType,
				namedPredicates: namedPredicates,
				expectedInfo: expectedInfo)

			return .mismatch(getClosestEntriesDescription(totalNumberOfFields: predicatesOnly.count, closest: closest))
		} catch {
			return .mismatch("Matcher FetchRequest failed: " + error.localizedDescription)
		}
	}
}

fileprivate func getClosestEntriesDescription<SubType: NSManagedObject & CoreDataObject>(
	totalNumberOfFields: Int,
	closest: (similarity: Int, differences: [IndividualObjectDifference<SubType>])
) -> String {
	let distance = totalNumberOfFields - closest.similarity
	let closestWrongFields = closest.differences.map{ difference -> String in
		let numberOfDifferentFields = difference.fieldNames.count
		var message = "\tWrong Fields (\(numberOfDifferentFields)/\(totalNumberOfFields)):\n"
		for i in 0 ..< numberOfDifferentFields {
			message += "\t\t\(difference.fieldNames[i]) WAS \(difference.actualValues[i])\n"
		}
		return message
	}
	let closestEntriesDescription = closestWrongFields.joined(separator: "\n")
	return "Closest \(SubType.entityName) entries (\(closest.differences.count) @ distance \(distance)): [\n" +
		closestEntriesDescription + "\n]"
}

fileprivate func getClosestActuals<SubType: NSManagedObject, InfoType: Info>(
	allOfSubType: [NSManagedObject],
	namedPredicates: [String: NSPredicate],
	expectedInfo: InfoType
) -> (Int, [IndividualObjectDifference<SubType>]) {
	var closestActuals = [IndividualObjectDifference<SubType>]()
	var closestSimilarity = 0
	for managedObject in allOfSubType {
		var similarity = 0
		var incorrectFields = [String]()
		for (field, predicate) in namedPredicates {
			if ([managedObject] as NSArray).filtered(using: predicate).count > 0 {
				similarity += 1
			} else {
				incorrectFields.append(field)
			}
		}
		let actualValues = mapToActualValues(fieldNames: incorrectFields, managedObject: managedObject)
		if similarity > closestSimilarity {
			closestActuals = [IndividualObjectDifference(
				expected: expectedInfo,
				actualObject: managedObject as! SubType,
				actualValues: actualValues,
				fieldNames: incorrectFields)]
			closestSimilarity = similarity
		} else if similarity == closestSimilarity {
			closestActuals.append(IndividualObjectDifference(
				expected: expectedInfo,
				actualObject: managedObject as! SubType,
				actualValues: actualValues,
				fieldNames: incorrectFields))
			closestSimilarity = similarity
		}
	}
	return (closestSimilarity, closestActuals)
}

fileprivate func mapToActualValues(fieldNames: [String], managedObject: NSManagedObject) -> [String] {
	return fieldNames.map{ fieldName -> String in
		let nameParts = fieldName.split(separator: ".")
		var object = managedObject
		if nameParts.count > 1 {
			for i in 0 ..< nameParts.count - 1 {
				guard let value = object.value(forKey: String(nameParts[i])) as? NSManagedObject else {
					fatalError("")
				}
				object = value
			}
		}
		return object.value(forKey: String(nameParts.last!)).debugDescription
	}
}

// MARK: - Classes

protocol Info {

	func getPredicates() -> [String: NSPredicate]
}


extension Info {

	public func datePredicateFor(fieldName: String, withinOneSecondOf date: Date?) -> NSPredicate {
		if let date = date {
			// within a second of the input start date
			// can't use == expected date because it always fails for some unknown reason
			return NSPredicate(
				format: "%K >= %@ AND %K <= %@",
				fieldName,
				date.addingTimeInterval(-1) as NSDate,
				fieldName,
				date.addingTimeInterval(1) as NSDate
			)
		}
		return NSPredicate(format: "%K == nil", fieldName)
	}

	public func timeZonePredicate(for timeZone: TimeZone?, field: String) -> NSPredicate {
		if let timeZone = timeZone {
			return NSPredicate(format: "%K ==[cd] %@", field, timeZone.identifier)
		}
		return NSPredicate(format: "%K == nil", field)
	}

	public func optionalStringPredicate(for note: String?, fieldName: String) -> NSPredicate {
		if let note = note {
			let unescapedNote = note.replacingOccurrences(of: "\"\"", with: "\"")
			return NSPredicate(format: "%K == %@", fieldName, unescapedNote)
		}
		return NSPredicate(format: "%K == nil || %K == %@", fieldName, fieldName, "")
	}

	public func dosagePredicate(for dosage: Dosage?, fieldName: String) -> NSPredicate {
		if let dosage = dosage {
			return NSPredicate(format: "%K == %@", fieldName, dosage)
		}
		return NSPredicate(format: "%K == nil", fieldName)
	}

	public func frequencyPredicate(for frequency: Frequency?, fieldName: String) -> NSPredicate {
		if let frequency = frequency {
			return NSPredicate(format: "%K == %@", fieldName, frequency)
		}
		return NSPredicate(format: "%K == nil", fieldName)
	}

	public func tagsPredicate(for tags: [String]?, fieldName: String) -> NSPredicate {
		if let tags = tags {
			var predicates = [NSPredicate]()
			for tag in tags {
				let unescapedTag = tag.replacingOccurrences(of: "\"\"", with: "\"")
				predicates.append(
					NSPredicate(
						format: "SUBQUERY(\(fieldName), $tag, $tag.name ==[cd] %@) .@count > 0",
						unescapedTag
					)
				)
			}
			return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		}
		return NSPredicate(format: "\(fieldName) .@count == 0")
	}
}

// MARK: - Structs

struct IndividualObjectDifference<Type> {

	/// included for easier debugging - not present in output
	var expected: Info
	/// included for easier debugging - not present in output
	var actualObject: Type
	var actualValues: [String]
	var fieldNames: [String]

	public init(
		expected: Info,
		actualObject: Type,
		actualValues: [String],
		fieldNames: [String]
	) {
		self.expected = expected
		self.actualObject = actualObject
		self.actualValues = actualValues
		self.fieldNames = fieldNames
	}
}
