//
//  GraphSetupScreenUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 10/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class GraphSetupScreenUITests: UITest {

	// MARK: - Graph Type Changes

	func testSettingGraphType_updatesGraphTypeButtonTitle() {
		// given
		let graphType = "Scatter"
		goToSingleDataTypeGraphSetupScreen()

		// when
		set(graphType: graphType)

		// then
		XCTAssertEqual(app.buttons["select graph type button"].value as? String, graphType)
	}

	func testChangingGraphTypeFromLineToScatter_doesNotResetSelections() {
		// given
		let graphType = "Scatter"
		let xAxisAttribute = "diastolic blood pressure"
		let aggregationTimeUnit = "week"
		let aggregationMethod = "average"
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setGrouping(groupingType: "series", timeUnit: aggregationTimeUnit)
		setGrouping(groupingType: "point", timeUnit: aggregationTimeUnit)
		setSingleDataTypeXAxis(attribute: xAxisAttribute, groupResolutionMethod: aggregationMethod)

		// when
		set(graphType: graphType)

		// then
		XCTAssertEqual(
			app.buttons["choose x-axis information button"].value as? String,
			"X-Axis: " + aggregationMethod + " " + xAxisAttribute)
		XCTAssertEqual(seriesGroupingButton().value as? String, "Series grouping chosen")
		XCTAssertEqual(pointGroupingButton().value as? String, "Point grouping chosen")
	}

	func testChangingGraphTypeFromScatterToBar_doesNotResetSelections() {
		// given
		let originalGraphType = "Scatter"
		let graphType = "Bar"
		let xAxisAttribute = "diastolic blood pressure"
		let aggregationTimeUnit = "week"
		let aggregationMethod = "average"
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setGrouping(groupingType: "series", timeUnit: aggregationTimeUnit)
		setGrouping(groupingType: "point", timeUnit: aggregationTimeUnit)
		setSingleDataTypeXAxis(attribute: xAxisAttribute, groupResolutionMethod: aggregationMethod)
		set(graphType: originalGraphType)

		// when
		set(graphType: graphType)

		// then
		XCTAssertEqual(
			app.buttons["choose x-axis information button"].value as? String,
			"X-Axis: " + aggregationMethod + " " + xAxisAttribute)
		XCTAssertEqual(seriesGroupingButton().value as? String, "Series grouping chosen")
		XCTAssertEqual(pointGroupingButton().value as? String, "Point grouping chosen")
	}

	// MARK: - Single Data Type

	func testEditingXAxisAttributeWithoutGroupingOnSingleDataTypeScreen_correctlyUpdatesXAxisAttributeButtonTitle() {
		// given
		let xAxisAttribute = "diastolic blood pressure"
		let originalXAxisAttribute = "systolic blood pressure"
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setSingleDataTypeXAxis(attribute: originalXAxisAttribute)

		// when
		setSingleDataTypeXAxis(attribute: xAxisAttribute)

		// then
		XCTAssertEqual(
			app.buttons["choose x-axis information button"].value as? String,
			"X-Axis: " + xAxisAttribute)
	}

	func testEditingYAxisInformationWithoutGroupingOnSingleDataTypeScreen_correctlyUpdatesYAxisInformationButtonTitle() {
		// given
		let xAxisAttribute = "diastolic blood pressure"
		let originalYAxisAttributes = ["diastolic blood pressure", "systolic blood pressure"]
		let yAxisAttributes = ["systolic blood pressure"]
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setSingleDataTypeXAxis(attribute: xAxisAttribute)
		guard setYAxisAttributes(originalYAxisAttributes) else { return }

		// when
		guard setYAxisAttributes(yAxisAttributes) else { return }

		// then
		XCTAssertEqual(app.buttons["choose y-axis information button"].value as? String, "Y-Axis: " + getCommaSeparatedList(yAxisAttributes))
	}

	func testEditingXAxisAttributeWithGroupingOnSingleDataTypeScreen_correctlyUpdatesXAxisAttributeButtonTitle() {
		// given
		let xAxisAttribute = "diastolic blood pressure"
		let aggregationTimeUnit = "week"
		let aggregationMethod = "average"
		let originalXAxisAttribute = "systolic blood pressure"
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setGrouping(groupingType: "series", timeUnit: aggregationTimeUnit)
		setGrouping(groupingType: "point", timeUnit: aggregationTimeUnit)
		setSingleDataTypeXAxis(attribute: originalXAxisAttribute, groupResolutionMethod: aggregationMethod)

		// when
		setSingleDataTypeXAxis(attribute: xAxisAttribute)

		// then
		XCTAssertEqual(
			app.buttons["choose x-axis information button"].value as? String,
			"X-Axis: " + aggregationMethod + " " + xAxisAttribute)
	}

	func testEditingYAxisInformationWithGroupingOnSingleDataTypeScreen_correctlyUpdatesYAxisInformationButtonTitle() {
		// given
		let xAxisAttribute = "diastolic blood pressure"
		let aggregationTimeUnit = "week"
		let xAxisAggregationMethod = "average"
		let originalYAxis = [
			(attribute: "diastolic blood pressure", information: "maximum"),
			(attribute: "timestamp", information: "count"),
		]
		let yAxis = [
			(attribute: "systolic blood pressure", information: "maximum"),
			(attribute: "systolic blood pressure", information: "minimum"),
		]
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setGrouping(groupingType: "series", timeUnit: aggregationTimeUnit)
		setGrouping(groupingType: "point", timeUnit: aggregationTimeUnit)
		setSingleDataTypeXAxis(attribute: xAxisAttribute, groupResolutionMethod: xAxisAggregationMethod)
		guard setYAxisInformation(originalYAxis) else { return }

		// when
		guard setYAxisInformation(yAxis) else { return }

		// then
		XCTAssertEqual(app.buttons["choose y-axis information button"].value as? String, "Y-Axis: " + getYAxisInformationCommaSeparatedList(yAxis))
	}

	func testDeletingYAxisAttributeOnSingleDataTypeScreen_removesThatAttributeFromTableView() {
		// given
		let xAxisAttribute = "diastolic blood pressure"
		let yAxisAttributes = ["systolic blood pressure", "diastolic blood pressure"]
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setSingleDataTypeXAxis(attribute: xAxisAttribute)
		guard setYAxisAttributes(yAxisAttributes) else { return }
		app.buttons["choose y-axis information button"].tap()

		// when
		app.tables.staticTexts[yAxisAttributes[0].localizedCapitalized].swipeLeft()
		app.tables.cells.buttons["🗑️"].tap()

		// then
		XCTAssert(!app.tables.staticTexts[yAxisAttributes[0].localizedCapitalized].exists)
		XCTAssert(app.tables.staticTexts[yAxisAttributes[1].localizedCapitalized].exists)
	}

	func testDeletingYAxisInformationOnSingleDataTypeScreen_removesThatAttributeFromTableView() {
		// given
		let xAxisAttribute = "diastolic blood pressure"
		let aggregationTimeUnit = "week"
		let xAxisAggregationMethod = "average"
		let yAxis = [
			(attribute: "systolic blood pressure", information: "Maximum"),
			(attribute: "systolic blood pressure", information: "Minimum"),
		]
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		setGrouping(groupingType: "series", timeUnit: aggregationTimeUnit)
		setGrouping(groupingType: "point", timeUnit: aggregationTimeUnit)
		setSingleDataTypeXAxis(attribute: xAxisAttribute, groupResolutionMethod: xAxisAggregationMethod)
		guard setYAxisInformation(yAxis) else { return }
		app.buttons["choose y-axis information button"].tap()

		// when
		let cellTitleToDelete = yAxis[0].information + " " + yAxis[0].attribute
		app.tables.staticTexts[cellTitleToDelete].swipeLeft()
		app.tables.cells.buttons["🗑️"].tap()

		// then
		let cellTitleThatShouldStillExist = yAxis[1].information + " " + yAxis[1].attribute
		XCTAssert(!app.tables.staticTexts[cellTitleToDelete].exists)
		XCTAssert(app.tables.staticTexts[cellTitleThatShouldStillExist].exists)
	}

	func testSettingQueryOnSingleDataTypeScreen_correctlyUpdatesChooseQueryButtonTitle() {
		// given
		goToSingleDataTypeGraphSetupScreen()

		// when
		app.buttons["choose query button"].tap()
		skipInstructionsIfPresent(.query)
		app.buttons["Use Query"].tap()

		// then
		XCTAssertEqual(app.buttons["choose query button"].value as? String, "Query chosen (click to change)")
	}

	func testClearingQueryOnSingleDataTypeScreen_correctlyUpdatesChooseQueryButtonTitle() {
		// given
		goToSingleDataTypeGraphSetupScreen()
		app.buttons["choose query button"].tap()
		skipInstructionsIfPresent(.query)
		app.buttons["Use Query"].tap()

		// when
		app.buttons["clear query button"].tap()

		// then
		XCTAssertEqual(app.buttons["choose query button"].value as? String, "Choose query (optional)")
	}

	func testChangingSampleTypeOnSingleDataTypeScreen_resetsAllButtonTitles() {
		// given
		goToSingleDataTypeGraphSetupScreen()
		setPicker(to: "Blood Pressure")
		app.buttons["choose query button"].tap()
		skipInstructionsIfPresent(.query)
		app.buttons["Use Query"].tap()
		setGrouping(groupingType: "series", timeUnit: "day")
		setGrouping(groupingType: "point", timeUnit: "day")
		setSingleDataTypeXAxis(attribute: "timestamp", groupResolutionMethod: "count")
		guard setYAxisInformation([(attribute: "timestamp", information: "count")]) else { return }

		// when
		setPicker("sample type picker", to: "Weight")

		// then
		XCTAssertEqual(app.buttons["choose query button"].value as? String, "Choose query (optional)")
		XCTAssertEqual(app.buttons["choose x-axis information button"].value as? String, "Choose x-axis information")
		XCTAssertEqual(app.buttons["choose y-axis information button"].value as? String, "Choose y-axis information")
		XCTAssertEqual(seriesGroupingButton().value as? String, "Choose series grouping (optional)")
		XCTAssertEqual(pointGroupingButton().value as? String, "Choose point grouping (optional)")
	}

	// MARK: - Multiple Data Types

	func testEditingXAxisAttributeOnMultipleDataTypeScreen_correctlyUpdatesXAxisAttributeButtonTitle() {
		// given
		let xAxisAttribute = "diastolic blood pressure"
		let aggregationMethod = "average"
		let originalXAxisAttribute = "systolic blood pressure"
		let originalAggregationMethod = "minimum"
		goToMultipleDataTypesGraphSetupScreen()
		setXAxisDataType("Blood Pressure")
		setMultipleDataTypeXAxis(attribute: originalXAxisAttribute, aggregationMethod: originalAggregationMethod)

		// when
		setMultipleDataTypeXAxis(attribute: xAxisAttribute, aggregationMethod: aggregationMethod)

		// then
		XCTAssertEqual(
			app.buttons["choose x-axis information button"].value as? String,
			aggregationMethod + " " + xAxisAttribute)
	}

	func testEditingYAxisInformationEnabledOnMultipleDataTypeScreen_correctlyUpdatesYAxisInformationButtonTitle() {
		// given
		let originalYAxis = [
			(attribute: "diastolic blood pressure", information: "maximum"),
			(attribute: "timestamp", information: "count"),
		]
		let yAxis = [
			(attribute: "systolic blood pressure", information: "maximum"),
			(attribute: "systolic blood pressure", information: "minimum"),
		]
		goToMultipleDataTypesGraphSetupScreen()
		setYAxisDataType("Blood Pressure")
		guard setYAxisInformation(originalYAxis) else { return }

		// when
		guard setYAxisInformation(yAxis) else { return }

		// then
		XCTAssertEqual(app.buttons["choose y-axis information button"].value as? String, getYAxisInformationCommaSeparatedList(yAxis))
	}

	func testSettingXAxisQueryOnMultipleDataTypeScreen_correctlyUpdatesChooseXAxisQueryButtonTitle() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setXAxisDataType()

		// when
		app.buttons["choose x-axis query button"].tap()
		skipInstructionsIfPresent(.query)
		app.buttons["Use Query"].tap()

		// then
		XCTAssertEqual(app.buttons["choose x-axis query button"].value as? String, "Query chosen (click to change)")
	}

	func testClearingXAxisQueryOnMultipleDataTypeScreen_correctlyUpdatesChooseXAxisQueryButtonTitle() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setXAxisDataType()
		app.buttons["choose x-axis query button"].tap()
		skipInstructionsIfPresent(.query)
		app.buttons["Use Query"].tap()

		// when
		app.buttons["clear x-axis query button"].tap()

		// then
		XCTAssertEqual(app.buttons["choose x-axis query button"].value as? String, "Choose query (optional)")
	}

	func testSettingYAxisQueryOnMultipleDataTypeScreen_correctlyUpdatesChooseYAxisQueryButtonTitle() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setYAxisDataType()

		// when
		app.buttons["choose y-axis query button"].tap()
		skipInstructionsIfPresent(.query)
		app.buttons["Use Query"].tap()

		// then
		XCTAssertEqual(app.buttons["choose y-axis query button"].value as? String, "Query chosen (click to change)")
	}

	func testClearingYAxisQueryOnMultipleDataTypeScreen_correctlyUpdatesChooseYAxisQueryButtonTitle() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setYAxisDataType()
		app.buttons["choose y-axis query button"].tap()
		skipInstructionsIfPresent(.query)
		app.buttons["Use Query"].tap()

		// when
		app.buttons["clear y-axis query button"].tap()

		// then
		XCTAssertEqual(app.buttons["choose y-axis query button"].value as? String, "Choose query (optional)")
	}

	func testEditingAlreadyChosenXAxisQuery_correctlyPopulatesEditQueryScreen() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setXAxisDataType()
		app.buttons["choose x-axis query button"].tap()
		skipInstructionsIfPresent(.query)
		populateQueryScreen()
		let parts = getStaticTextsFromQueryParts()
		app.buttons["Use Query"].tap()

		// when
		app.buttons["choose x-axis query button"].tap()
		skipInstructionsIfPresent(.query)

		// then
		XCTAssertEqual(app.tables.cells.count, parts.count)
		for i in 0 ..< parts.count {
			let cell = app.tables.cells.element(boundBy: i)
			XCTAssertEqual(cell.value as? String, parts[i])
		}
	}

	// MARK: - Helper Functions

	private final func goToSingleDataTypeGraphSetupScreen() {
		guard goToTabIfNotSelected("Explore") else { return }
		let graph = app.collectionViews.staticTexts["Graph"]
		guard waitForHittableElement(graph) else {
			XCTFail("Explore's Graph destination did not become reachable")
			return
		}
		graph.tap()
		XCTAssertTrue(waitForElement(app.buttons["select graph type button"]), "Graph setup did not appear")
	}

	private final func goToMultipleDataTypesGraphSetupScreen() {
		goToSingleDataTypeGraphSetupScreen()
		app.segmentedControls.buttons["Two Data Types"].tap()
	}

	private final func set(graphType: String) {
		app.buttons["select graph type button"].tap()
		setPicker("graph type picker", to: graphType)
		app.buttons["save graph type button"].tap()
	}

	private final func setGrouping(groupingType: String, timeUnit: String) {
		app.buttons["choose \(groupingType) grouping button"].tap()
		app.tables.cells.allElementsBoundByIndex[0].tap()
		app.buttons["set time unit button"].tap()
		setPicker(to: timeUnit)
		app.buttons["save button"].tap()
		waitForValue(timeUnit.localizedCapitalized, of: app.buttons["set time unit button"])
		let save = app.buttons["save grouper button"]
		guard waitForElement(save) else { XCTFail("Grouper Save did not appear"); return }
		let scroll = app.scrollViews.containing(.button, identifier: "save grouper button").firstMatch
		for _ in 0..<3 {
			if save.isHittable || !scroll.exists { break }
			scroll.swipeUp()
		}
		let ready = NSPredicate { _, _ in save.exists && save.isHittable }
		if !ready.evaluate(with: save) {
			let expectation = XCTNSPredicateExpectation(predicate: ready, object: save)
			guard XCTWaiter.wait(for: [expectation], timeout: 5) == .completed || ready.evaluate(with: save) else {
				XCTFail("Grouper Save did not become tappable")
				return
			}
		}
		save.tap()
		guard waitForElement(app.buttons["Done"]) else { XCTFail("Grouper editor did not close after Save"); return }
		app.buttons["Done"].tap()
	}

	private final func setSingleDataTypeXAxis(attribute: String, groupResolutionMethod: String? = nil) {
		app.buttons["choose x-axis information button"].tap()
		setPicker("attribute picker", to: attribute)
		if let groupResolutionMethod = groupResolutionMethod {
			setPicker("grouping method picker", to: groupResolutionMethod)
		}
		app.buttons["save x-axis button"].tap()
	}

	private final func setMultipleDataTypeXAxis(attribute: String, aggregationMethod: String) {
		app.buttons["choose x-axis information button"].tap()
		setPicker("attribute picker", to: attribute.localizedCapitalized)
		setPicker("grouping method picker", to: aggregationMethod)
		app.buttons["save x-axis button"].tap()
	}

	private final func setXAxisDataType(_ type: String? = nil) {
		set(axis: "x", toDataType: type)
	}

	private final func setYAxisDataType(_ type: String? = nil) {
		set(axis: "y", toDataType: type)
	}

	private final func set(axis: String, toDataType type: String?) {
		app.buttons["choose \(axis)-axis data type button"].tap()
		if let type = type {
			setPicker("data type picker", to: type)
		}
		if app.buttons["save button"].exists {
			app.buttons["save button"].tap()
		} else if app.buttons["save x-axis button"].exists {
			app.buttons["save \(axis)-axis button"].tap()
		} else {
			XCTFail("Unable to find save button")
		}
	}

	private final func setYAxisAttributes(_ attributes: [String]) -> Bool {
		return setYAxisEntries(attributes.map { (attribute: $0, information: nil) })
	}

	private final func setYAxisInformation(_ axis: [(attribute: String, information: String)]) -> Bool {
		return setYAxisEntries(axis.map { (attribute: $0.attribute, information: $0.information) })
	}

	private final func setYAxisEntries(_ entries: [(attribute: String, information: String?)]) -> Bool {
		let chooseYAxis = app.buttons["choose y-axis information button"]
		guard waitForYAxisState("Y-axis chooser did not become reachable", condition: {
			chooseYAxis.exists && chooseYAxis.isHittable
		}) else { return false }
		chooseYAxis.tap()
		let chooser = app.tables.containing(.button, identifier: "Done").firstMatch
		let clear = chooser.buttons["Clear"]
		guard waitForYAxisState("Y-axis Clear did not become reachable", condition: {
			clear.exists && clear.isEnabled && clear.isHittable
		}) else { return false }
		clear.tap()
		guard waitForYAxisState("Y-axis Clear did not remove all rows", condition: {
			chooser.exists && chooser.cells.count == 0
		}) else { return false }
		for entry in entries {
			let rowIndex = chooser.cells.count
			let add = chooser.buttons["Add"]
			guard waitForYAxisState("Y-axis Add did not become reachable", condition: {
				add.exists && add.isEnabled && add.isHittable
			}) else { return false }
			add.tap()
			guard waitForYAxisState("Y-axis Add did not append exactly one row", condition: {
				chooser.exists && chooser.cells.count == rowIndex + 1
			}) else { return false }
			let row = chooser.cells.element(boundBy: rowIndex)
			guard waitForYAxisState("New Y-axis row did not become reachable", condition: {
				row.exists && row.isHittable
			}) else { return false }
			row.tap()
			let attributeWheel = app.pickers["attribute picker"].pickerWheels.firstMatch
			guard waitForYAxisState("Y-axis attribute editor did not appear", condition: {
				attributeWheel.exists && attributeWheel.isHittable
			}) else { return false }
			let attributeTitle = entry.attribute.localizedCapitalized
			attributeWheel.adjust(toPickerWheelValue: attributeTitle)
			guard waitForYAxisState("Y-axis attribute picker did not select \(attributeTitle)", condition: {
				self.yAxisAttributeWheel(attributeWheel, displays: attributeTitle)
			}) else { return false }
			let informationWheel = app.pickers["grouping method picker"].pickerWheels.firstMatch
			if let information = entry.information {
				guard waitForYAxisState("Y-axis information picker did not appear", condition: {
					informationWheel.exists && informationWheel.isHittable
				}) else { return false }
				informationWheel.adjust(toPickerWheelValue: information.localizedCapitalized)
			}
			let save = app.buttons["save button"]
			guard waitForYAxisState("Y-axis editor did not become ready to save \(entry)", condition: {
				self.yAxisAttributeWheel(attributeWheel, displays: attributeTitle) &&
					(entry.information == nil || (informationWheel.exists &&
						informationWheel.value as? String == entry.information?.localizedCapitalized)) &&
					save.exists && save.isEnabled && save.isHittable
			}) else { return false }
			save.tap()
			guard waitForYAxisState("Y-axis editor did not close after Save", condition: {
				!attributeWheel.exists && !save.exists && chooser.exists && chooser.buttons["Done"].isHittable
			}) else { return false }
			let rowTitle: String
			if let information = entry.information {
				// CountInformation omits the attribute; Maximum/Minimum include its lowercase name.
				let informationTitle = information.localizedCapitalized
				rowTitle = informationTitle == "Count" ? informationTitle : informationTitle + " " + entry.attribute.localizedLowercase
			} else {
				rowTitle = attributeTitle
			}
			guard waitForYAxisState("Saved Y-axis row did not update to \(rowTitle)", condition: {
				chooser.cells.count == rowIndex + 1 &&
					chooser.cells.element(boundBy: rowIndex).staticTexts[rowTitle].exists
			}) else { return false }
		}
		let done = chooser.buttons["Done"]
		guard waitForYAxisState("Y-axis Done did not become reachable", condition: {
			done.exists && done.isEnabled && done.isHittable
		}) else { return false }
		done.tap()
		return waitForYAxisState("Y-axis chooser did not close after Done", condition: {
			!chooser.exists && chooseYAxis.exists && chooseYAxis.isHittable
		})
	}

	private final func yAxisAttributeWheel(_ wheel: XCUIElement, displays title: String) -> Bool {
		guard wheel.exists, let value = wheel.value as? String else { return false }
		if value == title { return true }
		// UIKit may truncate long picker titles in accessibility. The saved row must still match in full.
		for ellipsis in ["...", "…"] where value.hasSuffix(ellipsis) {
			let prefix = String(value.dropLast(ellipsis.count))
			if !prefix.isEmpty && title.hasPrefix(prefix) { return true }
		}
		return false
	}

	private final func waitForYAxisState(_ message: String, file: StaticString = #file, line: UInt = #line,
		condition: @escaping () -> Bool) -> Bool {
		if condition() { return true }
		let expectation = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in condition() }, object: nil)
		_ = XCTWaiter.wait(for: [expectation], timeout: 5)
		if condition() { return true }
		let hierarchy = XCTAttachment(string: app.debugDescription)
		hierarchy.name = "Y-axis setup failure UI hierarchy"
		hierarchy.lifetime = .keepAlways
		add(hierarchy)
		XCTFail(message, file: file, line: line)
		return false
	}

	private final func getYAxisInformationCommaSeparatedList(_ axis: [(attribute: String, information: String)]) -> String {
		return getCommaSeparatedList(axis.map{ $0.information + " " + $0.attribute })
	}

	private final func populateQueryScreen() {
		addAttributeRestrictionToQuery()
		addAndToQuery()
		addAttributeRestrictionToQuery()
		app.tables.cells.element(boundBy: 1).tap()
		setPicker("restricted attribute", to: "Name")
		app.buttons["set value button"].tap()
		setTextFor(field: app.textViews["attribute value text"], to: "fhjewio")
		app.buttons["save button"].tap()
		app.buttons["save attribute restriction button"].tap()
		addDataTypeToQuery("Blood Pressure")
		addDataTypeToQuery("Body Mass Index")
		addAttributeRestrictionToQuery()
	}

	private final func getStaticTextsFromQueryParts() -> [String?] {
		var parts = [String?]()
		for cell in app.tables.cells.allElementsBoundByIndex {
			parts.append(cell.value as? String)
		}
		return parts
	}

	private final func seriesGroupingButton() -> XCUIElement {
		return app.buttons["choose series grouping button"]
	}

	private final func pointGroupingButton() -> XCUIElement {
		return app.buttons["choose point grouping button"]
	}
}
