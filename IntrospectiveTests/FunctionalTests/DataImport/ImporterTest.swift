//
//  ImporterTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky

class ImporterTest: FunctionalTest {

	final let url = URL(fileURLWithPath: "/")

	final func useInput(_ input: String) {
		Given(ioUtil, .contentsOf(.value(url), willReturn: input))
	}
}
