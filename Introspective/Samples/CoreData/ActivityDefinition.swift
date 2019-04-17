//
//  ActivityDefinition.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData
import CSV

public class ActivityDefinition: NSManagedObject, CoreDataObject, Exportable {

	private typealias Me = ActivityDefinition

	// MARK: - CoreData Stuff

	public static let entityName = "ActivityDefinition"

	// MARK: - Export

	public static let exportFileDescription: String = "Activity Definitions"

	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try csv.write(
			row: [
				"Name",
				"Description",
				"Definition Tags",
				"Definition Source",
				"Auto Note",
			],
			quotedAtIndex: { _ in true })
	}

	public func export(to csv: CSVWriter) throws {
		try csv.write(field: name, quoted: true)

		try csv.write(field: activityDescription ?? "", quoted: true)

		let tagsText = tagsArray().map{ $0.name }.joined(separator: "|")
		try csv.write(field: tagsText, quoted: true)

		let sourceText = Sources.resolveActivitySource(source).description
		try csv.write(field: sourceText, quoted: true)

		try csv.write(field: autoNote ? "true" : "false", quoted: true)
	}

	// MARK: - Other

	public final func getSource() -> Sources.ActivitySourceNum {
		return Sources.resolveActivitySource(source)
	}

	public final func setSource(_ source: Sources.ActivitySourceNum) {
		self.source = source.rawValue
	}

	public final func tagsArray() -> [Tag] {
		return tags.allObjects as! [Tag]
	}

	public final func setTags(_ newTags: [Tag]) throws {
		removeAllTags()
		for tag in newTags {
			let tagToAdd = try DependencyInjector.db.pull(savedObject: tag, fromSameContextAs: self)
			addToTags(tagToAdd)
		}
	}

	// MARK: - Equatable

	public final func equalTo(_ other: ActivityDefinition) -> Bool {
		return name == other.name &&
			activityDescription == other.activityDescription &&
			tagsArray().elementsEqual(other.tagsArray(), by: { $0.equalTo($1) })
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		let descriptionText = activityDescription ?? "nil"
		var tagsText = ""
		for tag in tagsArray() {
			tagsText += tag.name + ", "
		}
		if !tagsText.isEmpty {
			tagsText.removeLast()
			tagsText.removeLast()
		}
		return "ActivityDefinition named '\(name)' with description '\(descriptionText)' and tags: \(tagsText)"
	}

	// MARK: - Helper Functions

	private final func removeAllTags() {
		for tag in tagsArray() {
			removeFromTags(tag)
		}
	}
}
