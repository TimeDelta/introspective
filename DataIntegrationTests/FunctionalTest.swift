//
//  FunctionalTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class FunctionalTest: XCTestCase {

    override func setUp() {
        super.setUp()
		DependencyInjector.setType(newType: .FunctionalTest)
    }

    override func tearDown() {
        DependencyInjector.setType(newType: .Production)
        UnitTestInjectionProvider.resetMocks()
        super.tearDown()
    }
}
