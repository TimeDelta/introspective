//
//  WellnessMoodImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 9/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

//sourcery: AutoMockable
public protocol WellnessMoodImporter: Importer {}

public final class WellnessMoodImporterImpl: NSManagedObject, WellnessMoodImporter, CoreDataObject {

	private typealias Me = WellnessMoodImporterImpl
	public static let entityName = "WellnessMoodImporter"
	private static let dateRegex = "^\\d\\d?/\\d\\d?/\\d\\d, \\d\\d:\\d\\d"

	public final let dataTypePluralName: String = "moods"
	public final let sourceName: String = "Wellness"
	public final var importOnlyNewData: Bool = true

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.util.io.contentsOf(url)
		var currentMood: Mood? = nil
		var currentNote = ""
		var latestDate: Date! = lastImport // use temp var to avoid bug where initial import doesn't import anything
		for line in contents.components(separatedBy: "\n")[1...] {
			if string(line, matches: Me.dateRegex) { // new mood record
				currentMood?.note = currentNote
				let parts = line.components(separatedBy: ",")
				let date = DependencyInjector.util.calendar.date(from: parts[0...1].joined(), format: "M/d/yy HH:mm")!
				if latestDate == nil { latestDate = date }
				if date.isAfterDate(latestDate, granularity: .nanosecond) {
					latestDate = date
				}
				if shouldImport(date) {
					currentMood = try DependencyInjector.sample.mood()
					currentMood!.timestamp = date
					currentMood!.minRating = 1
					currentMood!.maxRating = 7
					currentMood!.rating = Double(parts[2])!
					currentMood!.setSource(.wellness)
					if DependencyInjector.settings.scaleMoodsOnImport {
						DependencyInjector.util.mood.scaleMood(currentMood!)
					}
					currentNote = parts[3...].joined()
				} else {
					currentMood = nil
				}
			} else {
				if !currentNote.isEmpty {
					currentNote += "\n"
				}
				currentNote += line
			}
		}
		lastImport = latestDate
		try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
	}

	public final func resetLastImportDate() throws {
		lastImport = nil
		try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
	}

	// MARK: - Helper Functions

	private final func string(_ str: String, matches regex: String) -> Bool {
		return str.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}

	private final func shouldImport(_ date: Date) -> Bool {
		return !importOnlyNewData || // user doesn't care about data duplication -> import everything
			lastImport == nil || (   // never imported before -> import everything
				importOnlyNewData &&
				lastImport != nil &&
				date.isAfterDate(lastImport!, granularity: .nanosecond)
			)
	}
}
