//
//  UnitTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class UnitTest: XCTestCase {

    override func setUp() {
        super.setUp()
		DependencyInjector.setType(newType: .UnitTest)
    }

    override func tearDown() {
        DependencyInjector.setType(newType: .Production)
    }
}
