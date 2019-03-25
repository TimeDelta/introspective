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
}

public final class IOUtilImpl: IOUtil {

	public final func contentsOf(_ url: URL) throws -> String {
		return try String(contentsOf: url)
	}

	public final func csvReader(url: URL, hasHeaderRow: Bool) throws -> CSVReader {
		let stream = InputStream(url: url)!
		return try CSVReader(stream: stream, hasHeaderRow: hasHeaderRow)
	}
}
