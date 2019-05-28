//
//  PickerMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

/// - Parameter component: The component of the picker for which the expected row should apply.
func hasSelected(row expectedRow: Int, forComponent component: Int = 0) -> Matcher<UIPickerView> {
	let matcherDescription = "has row \(expectedRow) selected for component \(component)"
	return Matcher(matcherDescription) { (actual: UIPickerView) -> MatchResult in
		let selectedRow = actual.selectedRow(inComponent: component)
		if expectedRow == selectedRow {
			return .match
		}
		return .mismatch("has row \(selectedRow) selected")
	}
}
