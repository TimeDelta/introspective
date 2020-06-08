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

class ImporterTest: FunctionalTest {

	final let url = URL(fileURLWithPath: "/")

	func useInput(_ input: String) {
		Given(ioUtil, .contentsOf(.value(url), willReturn: input))
		Given(ioUtil, .csvReader(url: .value(url), hasHeaderRow: .value(true), willReturn: try! CSVReader(string: input, hasHeaderRow: true)))
		Given(ioUtil, .csvReader(url: .value(url), hasHeaderRow: .value(false), willReturn: try! CSVReader(string: input, hasHeaderRow: false)))
	}
}
