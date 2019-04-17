//
//  ExporterFunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import CSV
@testable import Introspective

class ExporterFunctionalTest: FunctionalTest {

	static func headerRowFor(fields: [String]) -> String {
		return fields.map{ "\"\($0)\"" }.joined(separator: ",")
	}

	final func getOutputStreamFor(_ type: Exportable.Type) throws -> OutputStream {
		let fileUrl = URL(fileURLWithPath: "/\(type.exportFileDescription) file.csv")
		Given(ioUtil, .urlOfExportFile(for: .value(type), in: .any, willReturn: fileUrl))
		let outputStream = OutputStream.toMemory()
		let writer = try CSVWriter(stream: outputStream, delimiter: ",", newline: .lf)
		Given(ioUtil, .csvWriter(url: .value(fileUrl), willReturn: writer))
		return outputStream
	}

	final func getTextWrittenTo(_ outputStream: OutputStream) -> String? {
		if let contentsWrittenToFile = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data {
			return String(data: contentsWrittenToFile, encoding: .utf8)
		}
		return nil
	}
}
