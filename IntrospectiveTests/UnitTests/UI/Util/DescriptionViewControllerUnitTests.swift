//
//  DescriptionViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/20/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest

@testable import Introspective

final class DescriptionViewControllerUnitTests: UnitTest {

	// MARK: - Test Setup

	private var controller: DescriptionViewController!
	private var descriptionTextView: UITextView!

	public override func setUp() {
		super.setUp()
		descriptionTextView = UITextView()
		controller = DescriptionViewController()
		controller.descriptionTextView = descriptionTextView
	}

	// MARK: - viewDidLoad()

	public func testGivenDescriptionTextSet_viewDidLoad_setsDescriptionViewText() {
		// given
		let expectedText = "fndjai;njiofka njiovkfns ad"
		controller.descriptionText = expectedText

		// when
		controller.viewDidLoad()

		// then
		assertThat(descriptionTextView, hasText(expectedText))
	}
}
