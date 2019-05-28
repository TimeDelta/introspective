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
		setYAxisAttributes(originalYAxisAttributes)

		// when
		setYAxisAttributes(yAxisAttributes)

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
		setYAxisInformation(originalYAxis)

		// when
		setYAxisInformation(yAxis)

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
		setYAxisAttributes(yAxisAttributes)
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
		setYAxisInformation(yAxis)
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
		app.buttons["Use Query"].tap()

		// then
		XCTAssertEqual(app.buttons["choose query button"].value as? String, "Query chosen (click to change)")
	}

	func testClearingQueryOnSingleDataTypeScreen_correctlyUpdatesChooseQueryButtonTitle() {
		// given
		goToSingleDataTypeGraphSetupScreen()
		app.buttons["choose query button"].tap()
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
		app.buttons["Use Query"].tap()
		setGrouping(groupingType: "series", timeUnit: "day")
		setGrouping(groupingType: "point", timeUnit: "day")
		setSingleDataTypeXAxis(attribute: "timestamp", groupResolutionMethod: "count")
		setYAxisInformation([(attribute: "timestamp", information: "count")])

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
		setYAxisInformation(originalYAxis)

		// when
		setYAxisInformation(yAxis)

		// then
		XCTAssertEqual(app.buttons["choose y-axis information button"].value as? String, getYAxisInformationCommaSeparatedList(yAxis))
	}

	func testSettingXAxisQueryOnMultipleDataTypeScreen_correctlyUpdatesChooseXAxisQueryButtonTitle() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setXAxisDataType()

		// when
		app.buttons["choose x-axis query button"].tap()
		app.buttons["Use Query"].tap()

		// then
		XCTAssertEqual(app.buttons["choose x-axis query button"].value as? String, "Query chosen (click to change)")
	}

	func testClearingXAxisQueryOnMultipleDataTypeScreen_correctlyUpdatesChooseXAxisQueryButtonTitle() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setXAxisDataType()
		app.buttons["choose x-axis query button"].tap()
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
		app.buttons["Use Query"].tap()

		// then
		XCTAssertEqual(app.buttons["choose y-axis query button"].value as? String, "Query chosen (click to change)")
	}

	func testClearingYAxisQueryOnMultipleDataTypeScreen_correctlyUpdatesChooseYAxisQueryButtonTitle() {
		// given
		goToMultipleDataTypesGraphSetupScreen()
		setYAxisDataType()
		app.buttons["choose y-axis query button"].tap()
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
		populateQueryScreen()
		let parts = getStaticTextsFromQueryParts()
		app.buttons["Use Query"].tap()

		// when
		app.buttons["choose x-axis query button"].tap()

		// then
		for i in 0 ..< parts.count {
			let cell = app.tables.cells.element(boundBy: i)
			XCTAssertEqual(cell.value as? String, parts[i])
		}
	}

	// MARK: - Helper Functions

	private final func goToSingleDataTypeGraphSetupScreen() {
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Graph"].tap()
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
		app.buttons["save grouper button"].tap()
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
		app.buttons["save button"].tap()
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
		app.buttons["save button"].tap()
	}

	private final func setYAxisAttributes(_ attributes: [String]) {
		app.buttons["choose y-axis information button"].tap()
		app.tables.buttons["Clear"].tap()
		for attribute in attributes {
			app.tables.buttons["Add"].tap()
			app.tables.staticTexts.allElementsBoundByIndex.last?.tap()
			setPicker("attribute picker", to: attribute)
			app.buttons["save button"].tap()
		}
		app.tables.buttons["Done"].tap()
	}

	private final func setYAxisInformation(_ axis: [(attribute: String, information: String)]) {
		app.buttons["choose y-axis information button"].tap()
		app.tables.buttons["Clear"].tap()
		for entry in axis {
			app.tables.buttons["Add"].tap()
			app.tables.staticTexts.allElementsBoundByIndex.last?.tap()
			setPicker("attribute picker", to: entry.attribute)
			setPicker("grouping method picker", to: entry.information)
			app.buttons["save button"].tap()
		}
		app.tables.buttons["Done"].tap()
	}

	private final func getYAxisInformationCommaSeparatedList(_ axis: [(attribute: String, information: String)]) -> String {
		return getCommaSeparatedList(axis.map{ $0.information + " " + $0.attribute })
	}

	private final func populateQueryScreen() {
		addAttributeRestrictionToQuery()
		addAttributeRestrictionToQuery()
		app.tables.cells.element(boundBy: 1).tap()
		setPicker("restricted attribute", to: "Name")
		app.buttons["set value button"].tap()
		setTextFor(field: app.textViews.element(boundBy: 0), to: "fhjewio")
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
