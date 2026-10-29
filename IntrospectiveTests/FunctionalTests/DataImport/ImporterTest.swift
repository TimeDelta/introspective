//
//  ImporterTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import CSV
@testable import DataImport

class ImporterTest: FunctionalTest {

	final let url = URL(fileURLWithPath: "/")

	func useInput(_ input: String) {
		Given(ioUtil, .contentsOf(.value(url), willReturn: input))
		Given(ioUtil, .csvReader(url: .value(url), hasHeaderRow: .value(true), willReturn: try! CSVReader(string: input, hasHeaderRow: true)))
		Given(ioUtil, .csvReader(url: .value(url), hasHeaderRow: .value(false), willReturn: try! CSVReader(string: input, hasHeaderRow: false)))
	}

	/// Cancel at a known active boundary and join the worker before any later test
	/// can replace the database or dependency provider used by that worker.
	func cancelActiveImport(_ importer: Importer, execution: ImporterExecution,
		file: StaticString = #file, line: UInt = #line) {
		let started = expectation(description: "Import reached its active record loop")
		let finished = expectation(description: "Cancelled import worker exited")
		let release = DispatchSemaphore(value: 0)
		let group = DispatchGroup()
		let queue = DispatchQueue(label: "test.cancel-import", autoreleaseFrequency: .workItem)
		execution.beforeResume = { started.fulfill(); release.wait() }
		queue.async(group: group) {
			do { try importer.importData(from: self.url) }
			catch { XCTFail("Import failed: \(error)", file: file, line: line) }
		}
		group.notify(queue: .main) { finished.fulfill() }
		wait(for: [started], timeout: 5)
		importer.cancel()
		release.signal()
		wait(for: [finished], timeout: 10)
		execution.beforeResume = nil
	}
}
