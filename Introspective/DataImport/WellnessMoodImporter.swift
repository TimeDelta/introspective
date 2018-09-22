//
//  WellnessMoodImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 9/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

//sourcery: AutoMockable
public protocol WellnessMoodImporter: Importer {}

public final class WellnessMoodImporterImpl: WellnessMoodImporter {

	private typealias Me = WellnessMoodImporterImpl
	private static let dateRegex = "^\\d\\d?/\\d\\d?/\\d\\d, \\d\\d:\\d\\d"

	public final let dataTypePluralName: String = "moods"
	public final let sourceName: String = "Wellness"

	public final func importData(from url: URL) throws {
		let contents = try String(contentsOf: url)
		var currentMood: Mood? = nil
		var currentNote = ""
		for line in contents.components(separatedBy: "\n")[1...] {
			if string(line, matches: Me.dateRegex) { // new mood record
				currentMood?.note = currentNote
				currentMood = DependencyInjector.sample.mood()
				let parts = line.components(separatedBy: ",")
				currentMood!.timestamp = DependencyInjector.util.calendarUtil.date(from: parts[0...1].joined(), format: "M/d/yy HH:mm")!
				currentMood!.maxRating = 7.0
				currentMood!.rating = Double(parts[2])!
				currentNote = parts[3...].joined()
			} else {
				currentNote += line
			}
		}
		DependencyInjector.db.save()
	}

	private final func string(_ str: String, matches regex: String) -> Bool {
		return str.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}
}
