//
//  IOUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 10/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CSV
import Foundation

// sourcery: AutoMockable
public protocol IOUtil {
	func contentsOf(_ url: URL) throws -> String

	func csvReader(url: URL, hasHeaderRow: Bool) throws -> CSVReader
	func csvWriter(url: URL) throws -> CSVWriter
}

public final class IOUtilImpl: IOUtil {
	public final func contentsOf(_ url: URL) throws -> String {
		try String(contentsOf: url)
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
}
