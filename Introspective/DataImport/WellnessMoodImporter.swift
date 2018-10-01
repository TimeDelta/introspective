//
//  WellnessMoodImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 9/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import os

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
		let contents = try DependencyInjector.util.ioUtil.contentsOf(url)
		var currentMood: Mood? = nil
		var currentNote = ""
		var latestDate: Date! = lastImport // use temp var to avoid bug where initial import doesn't import anything
		for line in contents.components(separatedBy: "\n")[1...] {
			if string(line, matches: Me.dateRegex) { // new mood record
				currentMood?.note = currentNote
				let parts = line.components(separatedBy: ",")
				let date = DependencyInjector.util.calendarUtil.date(from: parts[0...1].joined(), format: "M/d/yy HH:mm")!
				if latestDate == nil { latestDate = date }
				if date.isAfterDate(latestDate, granularity: .nanosecond) {
					latestDate = date
				}
				if !importOnlyNewData || lastImport == nil || (importOnlyNewData && lastImport != nil && date.isAfterDate(lastImport!, granularity: .nanosecond)) {
					currentMood = DependencyInjector.sample.mood()
					currentMood!.timestamp = date
					currentMood!.maxRating = 7.0
					currentMood!.rating = Double(parts[2])!
					currentNote = parts[3...].joined()
				} else {
					currentMood = nil
				}
			} else {
				currentNote += line
			}
		}
		lastImport = latestDate
		DependencyInjector.db.save()
	}

	private final func string(_ str: String, matches regex: String) -> Bool {
		return str.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}
}
