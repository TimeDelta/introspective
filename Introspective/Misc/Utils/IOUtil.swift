//
//  IOUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 10/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CSV

//sourcery: AutoMockable
public protocol IOUtil {
	func contentsOf(_ url: URL) throws -> String

	func csvReader(url: URL, hasHeaderRow: Bool) throws -> CSVReader
	func csvWriter(url: URL) throws -> CSVWriter

	func urlOfExportFile(for sampleType: Exportable.Type, in directory: URL) -> URL
}

public final class IOUtilImpl: IOUtil {

	public final func contentsOf(_ url: URL) throws -> String {
		return try String(contentsOf: url)
	}

	public final func csvReader(url: URL, hasHeaderRow: Bool) throws -> CSVReader {
		let stream = InputStream(url: url)!
		return try CSVReader(stream: stream, hasHeaderRow: hasHeaderRow)
	}

	public final func csvWriter(url: URL) throws -> CSVWriter {
		if let outputStream = OutputStream(url: url, append: false) {
			return try CSVWriter(stream: outputStream, delimiter: ",", newline: .lf)
		}
		throw GenericError("Failed to instantiate OutputStream for CSVWriter")
	}

	public final func urlOfExportFile(for type: Exportable.Type, in directory: URL) -> URL {
		let now = DependencyInjector.util.calendar.string(for: Date(), inFormat: "yyyy-MM-dd_HH:mm")
		let fileName = "\(type.exportFileDescription.localizedCapitalized) " + now + ".csv"
		return URL(fileURLWithPath: fileName, relativeTo: directory)
	}
}
