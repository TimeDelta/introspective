//
//  MedicationDosesTableViewControllerFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import SwiftDate
@testable import Introspective
@testable import Common
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

final class MedicationDosesTableViewControllerFunctionalTests: FunctionalTest {

	private final var tableView: UITableView {
		return controller.tableView
	}

	private final var previousDateRangeButton: UIBarButtonItem!
	private final var dateRangeButton: UIBarButtonItem!
	private final var nextDateRangeButton: UIBarButtonItem!

	private final var controller: MedicationDosesTableViewController!

	final override func setUp() {
		super.setUp()

		previousDateRangeButton = UIBarButtonItem()
		dateRangeButton = UIBarButtonItem()
		nextDateRangeButton = UIBarButtonItem()

		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "medicationDoses") as! MedicationDosesTableViewController)

		controller.previousDateRangeButton = previousDateRangeButton
		controller.dateRangeButton = dateRangeButton
		controller.nextDateRangeButton = nextDateRangeButton
	}

	// MARK: - viewDidLoad()

	func test_viewDidLoad_setsNavigationItemTitleToMedicationName() {
		// given
		let expectedName = "hfueirwqnj; af ino"
		let medication = MedicationDataTestUtil.createMedication(name: expectedName)
		controller.medication = medication

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.navigationItem, hasTitle(expectedName))
	}

	// MARK: - numberOfSections()

	func test_numberOfSections_returns1() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 1)

		// when
		let sections = controller.numberOfSections(in: tableView)

		// then
		assertThat(sections, equalTo(2))
	}

	// MARK: - tableViewNumberOfRowsInSection()

	func testGivenNoFiltering_tableViewNumberOfRowsInSection_returnsNumberOfDoses() throws {
		// given
		let expectedNumberOfRows = 3
		let medication = try createMedicationWith(numberOfDoses: expectedNumberOfRows)
		controller.medication = medication

		// when
		let numberOfRows = controller.tableView(tableView, numberOfRowsInSection: 1)

		// then
		assertThat(numberOfRows, equalTo(expectedNumberOfRows))
	}

	// MARK: - tableViewEditActionsForRowAt()

	func testGivenUserChoosesNoAfterPressingDelete_tableViewEditActionsForRowAt_doesNotDeleteAnything() throws {
		// given
		let expectedNumberOfRows = 3
		let medication = try createMedicationWith(numberOfDoses: expectedNumberOfRows)
		controller.medication = medication
		mockDeleteActionRequirements()
		let indexPath = IndexPath(row: 0, section: 1)

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let deleteHandlerCaptor = ArgumentCaptor<((UITableViewRowAction, IndexPath) -> Void)>()
		Verify(uiUtil, .tableViewRowAction(style: .any, title: .any, handler: deleteHandlerCaptor.capture()))
		deleteHandlerCaptor.value!(actions![0], indexPath)
		let noHandlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(uiUtil, .alertAction(title: .value("No"), style: .any, handler: noHandlerCaptor.capture()))

		// then
		if let _ = noHandlerCaptor.value as? ((UIAlertAction) -> Void) {
			XCTFail("Handler should not be present")
		}
	}

	func testGivenUserChoosesYesAfterPressingDeleteWhileNotFiltering_tableViewEditActionsForRowAt_deletesCorrectDose() throws {
		// given
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(medication: medication, dosage: Dosage(1, "mg"))
		let dose2 = MedicationDataTestUtil.createDose(medication: medication, dosage: Dosage(2, "mg"))
		MedicationDataTestUtil.createDose(medication: medication, dosage: Dosage(3, "mg"))
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		mockDeleteActionRequirements()
		// note that doses are displayed as most recent first so this should delete the third dose
		let indexPath = IndexPath(row: 0, section: 1)

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let deleteHandlerCaptor = ArgumentCaptor<((UITableViewRowAction, IndexPath) -> Void)>()
		Verify(uiUtil, .tableViewRowAction(style: .any, title: .any, handler: deleteHandlerCaptor.capture()))
		deleteHandlerCaptor.value!(actions![0], indexPath)
		let yesHandlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(uiUtil, .alertAction(title: .value("Yes"), style: .any, handler: yesHandlerCaptor.capture()))
		yesHandlerCaptor.value!!(UIAlertAction())

		// then
		let updatedMedication = try injected(Database.self).pull(savedObject: medication)
		let doses = updatedMedication.doses.array as! [MedicationDose]
		assertThat(doses, arrayHasExactly([dose1, dose2], areEqual: { $0.equalTo($1) }))
	}

	func testGivenUserChoosesYesAfterPressingDeleteWhileFiltering_tableViewEditActionsForRowAt_deletesCorrectDose() throws {
		// given
		var medication = MedicationDataTestUtil.createMedication()
		let filterDateMin = Date()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: filterDateMin - 1.days)
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: filterDateMin + 1.days)
		let dose3 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(3, "mg"),
			timestamp: filterDateMin + 1.days + 1.hours)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: filterDateMin)
		mockDeleteActionRequirements()
		// note that doses are displayed as most recent first so this should delete the second dose
		let indexPath = IndexPath(row: 1, section: 1)

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let deleteHandlerCaptor = ArgumentCaptor<((UITableViewRowAction, IndexPath) -> Void)>()
		Verify(uiUtil, .tableViewRowAction(style: .any, title: .any, handler: deleteHandlerCaptor.capture()))
		deleteHandlerCaptor.value!(actions![0], indexPath)
		let yesHandlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(uiUtil, .alertAction(title: .value("Yes"), style: .any, handler: yesHandlerCaptor.capture()))
		yesHandlerCaptor.value!!(UIAlertAction())

		// then
		let updatedMedication = try injected(Database.self).pull(savedObject: medication)
		let doses = updatedMedication.doses.array as! [MedicationDose]
		assertThat(doses, arrayHasExactly([dose1, dose3], areEqual: { $0.equalTo($1) }))
	}

	// MARK: - tableViewDidSelectRowAt()

	func test_tableViewDidSelectRowAt_setsCorrectDoseOnPresentedController() throws {
		// given
		let presentedController = mockMedicationDoseEditorViewController()
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(medication: medication, dosage: Dosage(1, "mg"))
		MedicationDataTestUtil.createDose(medication: medication, dosage: Dosage(2, "mg"))
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication

		// when
		// display order: descending order of timestamp
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 1))

		// then
		assertThat(presentedController.medicationDose, equals(dose1))
	}

	func testGivenSectionOne_tableViewDidSelectRowAt_setsCorrectMedicationOnPresentedController() throws {
		// given
		let presentedController = mockMedicationDoseEditorViewController()
		var medication = MedicationDataTestUtil.createMedication()
		MedicationDataTestUtil.createDose(medication: medication, dosage: Dosage(1, "mg"))
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))

		// then
		assertThat(presentedController.medication, equals(medication))
	}

	// MARK: - dateRangeSet()

	func testGivenNoDates_dateRangeSet_unfiltersDoses() throws {
		// given
		let expectedNumberOfDoses = 4
		controller.medication = try createMedicationWith(numberOfDoses: expectedNumberOfDoses)
		setDateRange(from: Date())

		// when
		setDateRange(from: nil, to: nil)

		// then
		let numberOfRows = controller.tableView(tableView, numberOfRowsInSection: 1)
		assertThat(numberOfRows, equalTo(expectedNumberOfDoses))
	}

	func testGivenNoDates_dateRangeSet_disablesPreviousButton() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: Date())
		controller.previousDateRangeButton.isEnabled = true

		// when
		setDateRange(from: nil, to: nil)

		// then
		assertThat(controller.previousDateRangeButton, not(isEnabled()))
	}

	func testGivenNoDates_dateRangeSet_disablesNextButton() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: Date())
		controller.nextDateRangeButton.isEnabled = true

		// when
		setDateRange(from: nil, to: nil)

		// then
		assertThat(controller.nextDateRangeButton, not(isEnabled()))
	}

	func testGivenNoDates_dateRangeSet_setsCorrectTitleForDateRangeButton() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: Date())
		controller.dateRangeButton.title = "fnejwi"

		// when
		setDateRange(from: nil, to: nil)

		// then
		assertThat(controller.dateRangeButton, hasTitle("Filter Dates"))
	}

	func testGivenOnlyFromDate_dateRangeSet_properlyFiltersDoses() throws {
		// given
		let filterDateMin = Date()
		let medication = MedicationDataTestUtil.createMedication()
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: filterDateMin - 1.days)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: filterDateMin + 1.days)
		let dose3 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(3, "mg"),
			timestamp: filterDateMin + 1.days + 1.hours)
		controller.medication = medication

		// when
		setDateRange(from: filterDateMin, to: nil)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose2, dose3], areEqual: { $0.equalTo($1) }))
	}

	func testGivenOnlyFromDate_dateRangeSet_enablesPreviousButon() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: nil)
		controller.previousDateRangeButton.isEnabled = false

		// when
		setDateRange(from: Date(), to: nil)

		// then
		assertThat(controller.previousDateRangeButton, isEnabled())
	}

	func testGivenOnlyFromDate_dateRangeSet_enablesNextButon() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: nil)
		controller.nextDateRangeButton.isEnabled = false

		// when
		setDateRange(from: Date(), to: nil)

		// then
		assertThat(controller.nextDateRangeButton, isEnabled())
	}

	func testGivenOnlyFromDate_dateRangeSet_setsCorrectTitleForDateRangeButton() throws {
		// given
		let filterDateMin = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)

		// when
		setDateRange(from: filterDateMin, to: nil)

		// then
		let expectedDate = dateString(filterDateMin, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("After " + expectedDate))
	}

	func testGivenOnlyToDate_dateRangeSet_properlyFiltersDoses() throws {
		// given
		let filterDateMax = Date()
		let medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: filterDateMax - 1.days - 1.hours)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: filterDateMax - 1.days)
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(3, "mg"),
			timestamp: filterDateMax + 1.days)
		controller.medication = medication

		// when
		setDateRange(from: nil, to: filterDateMax)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose1, dose2], areEqual: { $0.equalTo($1) }))
	}

	func testGivenOnlyToDate_dateRangeSet_enablesPreviousButon() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: nil)
		controller.previousDateRangeButton.isEnabled = false

		// when
		setDateRange(from: nil, to: Date())

		// then
		assertThat(controller.previousDateRangeButton, isEnabled())
	}

	func testGivenOnlyToDate_dateRangeSet_enablesNextButon() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: nil)
		controller.nextDateRangeButton.isEnabled = false

		// when
		setDateRange(from: nil, to: Date())

		// then
		assertThat(controller.nextDateRangeButton, isEnabled())
	}

	func testGivenOnlyToDate_dateRangeSet_setsCorrectTitleForDateRangeButton() throws {
		// given
		let filterDateMax = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)

		// when
		setDateRange(from: nil, to: filterDateMax)

		// then
		let expectedDate = dateString(filterDateMax, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("Before " + expectedDate))
	}

	func testGivenBothFromAndToDates_dateRangeSet_properlyFiltersDoses() throws {
		// given
		let filterDateMin = Date() - 1.days
		let filterDateMax = Date() + 1.days
		let medication = MedicationDataTestUtil.createMedication()
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: filterDateMin - 1.days)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: Date())
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(3, "mg"),
			timestamp: filterDateMax + 1.days)
		controller.medication = medication

		// when
		setDateRange(from: filterDateMin, to: filterDateMax)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose2], areEqual: { $0.equalTo($1) }))
	}

	func testGivenBothFromAndToDates_dateRangeSet_enablesPreviousButton() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: nil)
		controller.previousDateRangeButton.isEnabled = false

		// when
		setDateRange(from: Date(), to: Date())

		// then
		assertThat(controller.previousDateRangeButton, isEnabled())
	}

	func testGivenBothFromAndToDates_dateRangeSet_enablesNextButton() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: nil)
		controller.nextDateRangeButton.isEnabled = false

		// when
		setDateRange(from: Date(), to: Date())

		// then
		assertThat(controller.nextDateRangeButton, isEnabled())
	}

	func testGivenBothFromAndToDates_dateRangeSet_setsCorrectTitleForDateRangeButton() throws {
		// given
		let filterDateMin = Date() - 1.days
		let filterDateMax = Date() + 1.days
		controller.medication = try createMedicationWith(numberOfDoses: 0)

		// when
		setDateRange(from: filterDateMin, to: filterDateMax)

		// then
		let expectedMinDate = dateString(filterDateMin, dateStyle: .short, timeStyle: .none)
		let expectedMaxDate = dateString(filterDateMax, dateStyle: .short, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("From " + expectedMinDate + " to " + expectedMaxDate))
	}

	func testGivenSameFromAndToDate_dateRangeSet_setsCorrectTitleForDateRangeButton() throws {
		// given
		let date = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)

		// when
		setDateRange(from: date, to: date)

		// then
		let expectedDate = dateString(date, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("On " + expectedDate))
	}

	// MARK: - medicationDoseEdited()
	// gave up on these tests because of issues with incompatible ManagedObjectContexts
	// between the test and controller

//	func testGivenEditedDoseShouldBeFilteredOut_medicationDoseEdited_correctlyFiltersDoses() throws {
//		// given
//		let date = Date()
//		var medication = MedicationDataTestUtil.createMedication()
//		let dose1 = MedicationDataTestUtil.createDose(
//			medication: medication,
//			dosage: Dosage(1, "mg"),
//			timestamp: date + 1.days)
//		var dose2 = MedicationDataTestUtil.createDose(
//			medication: medication,
//			dosage: Dosage(2, "mg"),
//			timestamp: date + 2.days)
//		medication = try injected(Database.self).pull(savedObject: medication)
//		controller.medication = medication
//		setDateRange(from: date, to: nil)
//		mockMedicationDoseEditorViewController()
//		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
//		let transaction = injected(Database.self).transaction()
//		dose2 = try transaction.pull(savedObject: dose2)
//		dose2.dosage = Dosage(3, "mg")
//		try transaction.commit()
//		dose2 = try injected(Database.self).pull(savedObject: dose2)
//
//		// when
//		Given(uiUtil, .value(for: .value(.dose), from: .any, keyIsOptional: .any, willReturn: dose2))
//		NotificationCenter.default.post(
//			name: MedicationDosesTableViewController.medicationDoseEdited,
//			object: nil,
//			userInfo: [
//				UserInfoKey.dose: dose2,
//			])
//
//		// then
//		assertThat(controller.filteredDoses, arrayHasExactly([dose1], areEqual: { $0.equalTo($1) }))
//	}
//
//	func testGivenEditedDoseShouldNotBeFilteredOut_medicationDoseEdited_correctlyFiltersDoses() throws {
//		// given
//		let date = Date()
//		var medication = MedicationDataTestUtil.createMedication()
//		let dose1 = MedicationDataTestUtil.createDose(
//			medication: medication,
//			dosage: Dosage(1, "mg"),
//			timestamp: date + 1.days)
//		var dose2 = MedicationDataTestUtil.createDose(
//			medication: medication,
//			dosage: Dosage(2, "mg"),
//			timestamp: date + 2.days)
//		medication = try injected(Database.self).pull(savedObject: medication)
//		controller.medication = medication
//		setDateRange(from: date, to: nil)
//		mockMedicationDoseEditorViewController()
//		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
//		let transaction = injected(Database.self).transaction()
//		dose2 = try transaction.pull(savedObject: dose2)
//		dose2.dosage = Dosage(3, "mg")
//		try transaction.commit()
//		dose2 = try injected(Database.self).pull(savedObject: dose2)
//
//		// when
//		Given(uiUtil, .value(for: .value(.dose), from: .any, keyIsOptional: .any, willReturn: dose2))
//		NotificationCenter.default.post(
//			name: MedicationDosesTableViewController.medicationDoseEdited,
//			object: nil,
//			userInfo: [
//				UserInfoKey.dose: dose2,
//			])
//
//		// then
//		assertThat(controller.filteredDoses, arrayHasExactly([dose1, dose2], areEqual: { $0.equalTo($1) }))
//	}

	// MARK: - filterDatesButtonPressed()

	func testGivenFromDatePreviouslySet_filterDatesButtonPressed_setsInitialFromDateOnPresentedController() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		let expectedInitialFromDate = Date() - 1.days
		setDateRange(from: expectedInitialFromDate, to: nil)
		let presentedController = mockDateRangeViewController()

		// when
		controller.filterDatesButtonPressed(dateRangeButton)

		// then
		assertThat(presentedController.initialFromDate, equalTo(expectedInitialFromDate))
	}

	func testGivenToDatePreviouslySet_filterDatesButtonPressed_setsInitialToDateOnPresentedController() throws {
		// given
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		let expectedInitialToDate = Date() - 1.days
		setDateRange(from: nil, to: expectedInitialToDate)
		let presentedController = mockDateRangeViewController()

		// when
		controller.filterDatesButtonPressed(dateRangeButton)

		// then
		assertThat(presentedController.initialToDate, equalTo(expectedInitialToDate))
	}

	// MARK: - previousDateRangeButtonPressed()

	func testGivenSameNonNilFromAndToDate_previousDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let date = Date()
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: date - 1.days)
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: date)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: date, to: date)
		controller.filteredDoses = []

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose1], areEqual: { $0.equalTo($1) }))
	}

	func testGivenSameNonNilFromAndToDate_previousDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let date = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: date, to: date)

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		let expectedDate = dateString(date - 1.days, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("On " + expectedDate))
	}

	func testGivenOnlyToDateSet_previousDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let date = Date()
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: date - 2.days)
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: date - 1.days)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: nil, to: date)
		controller.filteredDoses = []

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose1], areEqual: { $0.equalTo($1) }))
	}

	func testGivenOnlyToDateSet_previousDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let date = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: date)

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		let expectedDate = dateString(date - 1.days, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("Before " + expectedDate))
	}

	func testGivenOnlyFromDateSet_previousDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let date = Date()
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: date)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: date + 1.days)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: date, to: nil)
		controller.filteredDoses = []

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose1, dose2], areEqual: { $0.equalTo($1) }))
	}

	func testGivenOnlyFromDateSet_previousDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let date = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: date, to: nil)

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		let expectedDate = dateString(date - 1.days, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("After " + expectedDate))
	}

	func testGivenDifferentNonNilFromAndToDates_previousDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let fromDate = Date()
		let toDate = fromDate + 2.days
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: fromDate - 1.days)
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: fromDate + 1.days)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: fromDate, to: toDate)
		controller.filteredDoses = []

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose1], areEqual: { $0.equalTo($1) }))
	}

	func testGivenDifferentNonNilFromAndToDates_previousDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let fromDate = Date()
		let toDate = fromDate + 2.days
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: fromDate, to: toDate)

		// when
		controller.previousDateRangeButtonPressed(previousDateRangeButton)

		// then
		let expectedFromDate = dateString(fromDate - 2.days, dateStyle: .short, timeStyle: .none)
		let expectedToDate = dateString(toDate - 2.days, dateStyle: .short, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("From " + expectedFromDate + " to " + expectedToDate))
	}

	// MARK: - nextDateRangeButtonPressed()

	func testGivenSameNonNilFromAndToDate_nextDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let date = Date()
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: date + 1.days)
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: date)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: date, to: date)
		controller.filteredDoses = []

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose1], areEqual: { $0.equalTo($1) }))
	}

	func testGivenSameNonNilFromAndToDate_nextDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let date = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: date, to: date)

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		let expectedDate = dateString(date + 1.days, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("On " + expectedDate))
	}

	func testGivenOnlyToDateSet_nextDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let date = Date()
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: date - 1.days)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: date)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: nil, to: date)
		controller.filteredDoses = []

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose1, dose2], areEqual: { $0.equalTo($1) }))
	}

	func testGivenOnlyToDateSet_nextDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let date = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: nil, to: date)

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		let expectedDate = dateString(date + 1.days, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("Before " + expectedDate))
	}

	func testGivenOnlyFromDateSet_nextDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let date = Date()
		var medication = MedicationDataTestUtil.createMedication()
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: date + 1.days)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: date + 2.days)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: date, to: nil)
		controller.filteredDoses = []

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose2], areEqual: { $0.equalTo($1) }))
	}

	func tesstGivenOnlyFromDateSet_nextDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let date = Date()
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: date, to: nil)

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		let expectedDate = dateString(date + 1.days, dateStyle: .medium, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("After " + expectedDate))
	}

	func testGivenDifferentNonNilFromAndToDates_nextDateRangeButtonPressed_correctlyRefiltersDoses() throws {
		// given
		let fromDate = Date()
		let toDate = fromDate + 2.days
		var medication = MedicationDataTestUtil.createMedication()
		MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(1, "mg"),
			timestamp: fromDate - 1.days)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(2, "mg"),
			timestamp: fromDate + 3.days)
		medication = try injected(Database.self).pull(savedObject: medication)
		controller.medication = medication
		setDateRange(from: fromDate, to: toDate)
		controller.filteredDoses = []

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		assertThat(controller.filteredDoses, arrayHasExactly([dose2], areEqual: { $0.equalTo($1) }))
	}

	func testGivenDifferentNonNilFromAndToDates_nextDateRangeButtonPressed_setsCorrectTitleForDateRangeButton() throws {
		// given
		let fromDate = Date()
		let toDate = fromDate + 2.weeks
		controller.medication = try createMedicationWith(numberOfDoses: 0)
		setDateRange(from: fromDate, to: toDate)

		// when
		controller.nextDateRangeButtonPressed(nextDateRangeButton)

		// then
		let expectedFromDate = dateString(fromDate + 2.weeks, dateStyle: .short, timeStyle: .none)
		let expectedToDate = dateString(toDate + 2.weeks, dateStyle: .short, timeStyle: .none)
		assertThat(controller.dateRangeButton, hasTitle("From " + expectedFromDate + " to " + expectedToDate))
	}

	// MARK: - Helper Functions

	func setDateRange(from: Date? = nil, to: Date? = nil) {
		Given(uiUtil, .value(for: .value(.fromDate), from: .any, keyIsOptional: .any, willReturn: from))
		Given(uiUtil, .value(for: .value(.toDate), from: .any, keyIsOptional: .any, willReturn: to))
		NotificationCenter.default.post(
			name: MedicationDosesTableViewController.dateRangeSet,
			object: nil,
			userInfo: [
				UserInfoKey.fromDate: from as Any,
				UserInfoKey.toDate: to as Any,
			])
	}

	@discardableResult
	func createMedicationWith(name: String = "", numberOfDoses: Int) throws -> Medication {
		let medication = MedicationDataTestUtil.createMedication(name: name)
		for _ in 0 ..< numberOfDoses {
			MedicationDataTestUtil.createDose(medication: medication)
		}
		return try injected(Database.self).pull(savedObject: medication)
	}

	func mockDeleteActionRequirements() {
		Given(uiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: UIAlertController()))
		Given(uiUtil, .alertAction(title: .any, style: .any, handler: .any, willReturn: UIAlertAction()))
		Given(uiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))
	}

	func dateString(_ date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = dateStyle
		formatter.timeStyle = timeStyle
		formatter.timeZone = TimeZone.autoupdatingCurrent
		return formatter.string(from: date)
	}

	// MARK: Mocked View Controllers

	@discardableResult
	func mockDateRangeViewController() -> DateRangeViewControllerMock {
		let controller = DateRangeViewControllerMock()
		Given(uiUtil, .controller(
			named: .value("dateRangeChooser"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	func mockMedicationDoseEditorViewController() -> MedicationDoseEditorViewControllerMock {
		let controller = MedicationDoseEditorViewControllerMock()
		Given(uiUtil, .controller(
			named: .value("medicationDoseEditor"),
			from: .any(UIStoryboard.self),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}
}
