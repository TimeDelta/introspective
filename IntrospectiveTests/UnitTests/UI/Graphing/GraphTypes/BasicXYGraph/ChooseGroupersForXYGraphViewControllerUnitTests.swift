//
//  ChooseGroupersForXYGraphViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 5/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import Presentr

@testable import Introspective
@testable import Attributes
@testable import Common
@testable import SampleGroupers
@testable import Samples

final class ChooseGroupersForXYGraphViewControllerUnitTests: UnitTest {

	private final let defaultSampleType: Sample.Type = HeartRate.self

	private final var chooseAttributeTypeButton: UIButton!
	private final var chooseGrouperTypeButton: UIButton!
	private final var chooseXGrouperButton: UIButton!
	private final var chooseYGrouperButton: UIButton!
	private final var saveButton: UIButton!

	private final var controller: ChooseGroupersForXYGraphViewControllerImpl!

	override func setUp() {
		super.setUp()

		chooseAttributeTypeButton = UIButton()
		chooseGrouperTypeButton = UIButton()
		chooseXGrouperButton = UIButton()
		chooseYGrouperButton = UIButton()
		saveButton = UIButton()

		let storyboard = UIStoryboard(name: "BasicXYGraph", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "chooseXYGroupers") as! ChooseGroupersForXYGraphViewControllerImpl)
		controller.chooseAttributeTypeButton = chooseAttributeTypeButton
		controller.chooseGrouperTypeButton = chooseGrouperTypeButton
		controller.chooseXGrouperButton = chooseXGrouperButton
		controller.chooseYGrouperButton = chooseYGrouperButton
		controller.saveButton = saveButton
	}

	// MARK: - viewDidLoad()

	func testGivenNoCommonAttributeTypes_viewDidLoad_popsFromNavigationController() {
		// given
		let xSampleType = HeartRate.self
		let ySampleType = TestSample.self
		controller.xSampleType = xSampleType
		controller.ySampleType = ySampleType

		// when
		controller.viewDidLoad()

		// then
		Verify(mockUiUtil, .popFrom(.any, animated: .any))
	}

	func testGivenCommonAttributeTypes_viewDidLoad_doesNotPopFromNavigationController() {
		// given
		let xSampleType = HeartRate.self
		let ySampleType = HeartRate.self
		controller.xSampleType = xSampleType
		controller.ySampleType = ySampleType

		// when
		controller.viewDidLoad()

		// then
		Verify(mockUiUtil, .never, .popFrom(.any, animated: .any))
	}

	func testGivenNavBarTitle_viewDidLoad_setsControllerTitleToNavBarTitle() {
		// given
		let navBarTitle = "this should be the controller title"
		controller.navBarTitle = navBarTitle
		controller.xSampleType = TestSample.self
		controller.ySampleType = TestSample.self

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.title, equalTo(navBarTitle))
	}

	func testGivenCurrentAttributeTypeNil_viewDidLoad_setsCorrectTitleForChooseAttributeTypeButton() {
		// given
		let currentAttributeType: String? = nil
		controller.currentAttributeType = currentAttributeType
		setValidViewDidLoadRequirements()
		useButtonDescriber(describeButtonWithCurrentTitle)

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.chooseAttributeTypeButton, hasTitle("Choose Attribute Type"))
	}

	func testGivenCurrentAttributeTypeSet_viewDidLoad_setsCorrectTitleForChooseAttributeTypeButton() {
		// given
		let currentAttributeType = CommonSampleAttributes.startDate.typeName
		controller.currentAttributeType = currentAttributeType
		setValidViewDidLoadRequirements()
		useButtonDescriber(describeButtonWithCurrentTitle)

		// when
		controller.viewDidLoad()

		// then
		assertThat(
			controller.chooseAttributeTypeButton,
			hasTitle(
				allOf(
					containsString("Attribute Type"),
					containsString(currentAttributeType))))
	}

	func testGivenXGrouperNil_viewDidLoad_setsCorrectTitleForChooseXGrouperButton() {
		// given
		let xGrouper: SampleGrouper? = nil
		controller.xGrouper = xGrouper
		setValidViewDidLoadRequirements()
		useButtonDescriber(describeButtonWithCurrentTitle)

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.chooseXGrouperButton, hasTitle("Choose X-Axis Grouping"))
	}

	func testGivenXGrouperSet_viewDidLoad_setsCorrectTitleForChooseXGrouperButton() {
		// given
		let xGrouper = AdvancedSampleGrouper(attributes: [])
		controller.xGrouper = xGrouper
		setValidViewDidLoadRequirements()
		useButtonDescriber(describeButtonWithCurrentTitle)

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.chooseXGrouperButton, hasTitle("X-Axis Grouping Chosen"))
	}

	func testGivenYGrouperNil_viewDidLoad_setsCorrectTitleForChooseYGrouperButton() {
		// given
		let yGrouper: SampleGrouper? = nil
		controller.yGrouper = yGrouper
		setValidViewDidLoadRequirements()
		useButtonDescriber(describeButtonWithCurrentTitle)

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.chooseYGrouperButton, hasTitle("Choose Y-Axis Grouping"))
	}

	func testGivenYGrouperSet_viewDidLoad_setsCorrectTitleForChooseYGrouperButton() {
		// given
		let yGrouper = AdvancedSampleGrouper(attributes: [])
		controller.yGrouper = yGrouper
		setValidViewDidLoadRequirements()
		useButtonDescriber(describeButtonWithCurrentTitle)

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.chooseYGrouperButton, hasTitle("Y-Axis Grouping Chosen"))
	}

	// MARK: - chooseAttributeTypeButtonPressed()

	func testGivenAttributeTypesInCommon_chooseAttributeTypeButtonPressed_initsChooserWithCommonTypes() {
		// given
		controller.xSampleType = HeartRate.self
		controller.ySampleType = Sleep.self
		controller.viewDidLoad()
		let expectedPresentedController = mockChooseTextViewController()
		Given(mockUiUtil, .defaultPresenter(getter: Presentr(presentationType: .alert)))

		// when
		controller.chooseAttributeTypeButtonPressed(self)

		// then
		assertThat(expectedPresentedController.availableChoices, equalTo(["Date & Time"]))
	}

	func testGivenCurrentAttributeTypeAlreadyChosen_chooseAttributeTypeButtonPressed_initsChooserWithCurrentType() {
		// given
		let expectedValue = "Date and time"
		setValidViewDidLoadRequirements()
		controller.viewDidLoad()
		controller.currentAttributeType = expectedValue
		let expectedPresentedController = mockChooseTextViewController()
		Given(mockUiUtil, .defaultPresenter(getter: Presentr(presentationType: .alert)))

		// when
		controller.chooseAttributeTypeButtonPressed(self)

		// then
		assertThat(expectedPresentedController.selectedText, equalTo(expectedValue))
	}

	func testGivenAttributeTypesInCommon_chooseAttributeTypeButtonPressed_presentsAttributeTypeChooser() {
		// given
		setValidViewDidLoadRequirements()
		let expectedPresentedController = mockChooseTextViewController()
		Given(mockUiUtil, .defaultPresenter(getter: Presentr(presentationType: .alert)))

		// when
		controller.chooseAttributeTypeButtonPressed(self)

		// then
		let presentedControllerCaptor = ArgumentCaptor<UIViewController>()
		Verify(mockUiUtil, .present(.capturing(presentedControllerCaptor), on: .any, using: .any, animated: .any, completion: .any))
		if let presentedController = presentedControllerCaptor.value {
			assertThat(presentedController, equalTo(expectedPresentedController))
		}
	}

	// MARK: - chooseGrouperTypeButtonPressed()

	func testGivenNoXAttributesForCurrentAttributeType_chooseGrouperTypeButtonPressed_doesNotPresentChooser() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "does not exist"
		controller.viewDidLoad()

		Given(mockUiUtil, .defaultPresenter(getter: Presentr(presentationType: .alert)))
		mockChooseSampleGrouperTypeViewController()

		// when
		controller.chooseGrouperTypeButtonPressed(self)

		// then
		Verify(mockUiUtil, .never, .present(.any, on: .any, using: .any, animated: .any, completion: .any))
	}

	func testGivenXAttributesForCurrentAttributeType_chooseGrouperTypeButtonPressed_initsChooserWithGrouperTypesForThoseAttributes() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()

		let expectedSampleGrouperTypes: [SampleGrouper.Type] = [AdvancedSampleGrouper.self, SameTimeUnitSampleGrouper.self]
		Given(mockUiUtil, .defaultPresenter(getter: Presentr(presentationType: .alert)))
		Given(mockSampleGrouperFactory, .typesFor(attributes: [CommonSampleAttributes.healthKitTimestamp], willReturn: expectedSampleGrouperTypes))
		let chooserSampleGrouperTypeController = mockChooseSampleGrouperTypeViewController()

		// when
		controller.chooseGrouperTypeButtonPressed(self)

		// then
		for type in expectedSampleGrouperTypes {
			assertThat(chooserSampleGrouperTypeController.grouperTypes, hasItem(equals(type)))
		}
	}

	func testGivenGrouperTypeAlreadyChosen_chooseGrouperTypeButtonPressed_initsChooserWithCurrentGrouperType() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()

		let expectedGrouperType: SampleGrouper.Type = AdvancedSampleGrouper.self
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouperType))
		Given(mockUiUtil, .defaultPresenter(getter: Presentr(presentationType: .alert)))
		Given(mockSampleGrouperFactory, .typesFor(attributes: [CommonSampleAttributes.healthKitTimestamp], willReturn: [expectedGrouperType]))
		let chooserSampleGrouperTypeController = mockChooseSampleGrouperTypeViewController()

		NotificationCenter.default.post(
			name: NotificationName.grouperTypeChanged.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouperType])

		// when
		controller.chooseGrouperTypeButtonPressed(self)

		// then
		assertThat(chooserSampleGrouperTypeController.selectedGrouperType, equals(expectedGrouperType))
	}

	// MARK: - chooseXAxisGrouperButtonPressed()

	func testGivenAdvancedGrouper_chooseXAxisGrouperButtonPressed_initsChooserWithXSampleType() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.xGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()
		let groupingChooserController = mockGroupingChooserTableViewController()

		// when
		controller.chooseXAxisGrouperButtonPressed(self)

		// then
		assertThat(groupingChooserController.sampleType, equals(controller.xSampleType))
	}

	func testGivenAdvancedGrouper_chooseXAxisGrouperButtonPressed_doesNotAllowUserToChangeGrouperType() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()
		let groupingChooserController = mockGroupingChooserTableViewController()

		// when
		controller.chooseXAxisGrouperButtonPressed(self)

		// then
		XCTAssertFalse(groupingChooserController.allowUserToChangeGrouperType)
	}

	func testGivenAdvancedGrouperAlreadyChosen_chooseXAxisGrouperButtonPressed_initsChooserWithCurrentXGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()
		let groupingChooserController = mockGroupingChooserTableViewController()

		// when
		controller.chooseXAxisGrouperButtonPressed(self)

		// then
		assertThat(groupingChooserController.currentGrouper, equals(controller.xGrouper))
	}

	func testGivenNonAdvancedGrouperAlreadyChosen_chooseXAxisGrouperButtonPressed_initsChooserWithCurrentXGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = SameTimeUnitSampleGrouper(sampleType: controller.xSampleType)
		controller.viewDidLoad()
		let editGrouperController = mockEditGrouperViewController()

		// when
		controller.chooseXAxisGrouperButtonPressed(self)

		// then
		assertThat(editGrouperController.currentGrouper, equals(controller.xGrouper))
	}

	func testGivenGrouperNotChosen_chooseXAxisGrouperButtonPressed_initsChooserWithDefaultXGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()
		let expectedGrouperType: SameTimeUnitSampleGrouper.Type = SameTimeUnitSampleGrouper.self
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouperType))
		let editGrouperController = mockEditGrouperViewController()

		NotificationCenter.default.post(
			name: NotificationName.grouperTypeChanged.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouperType])

		// when
		controller.chooseXAxisGrouperButtonPressed(self)

		// then
		assertThat(editGrouperController.currentGrouper as Any, isA(expectedGrouperType))
	}

	// MARK: - chooseYAxisGrouperButtonPressed()

	func testGivenAdvancedGrouper_chooseYAxisGrouperButtonPressed_initsChooserWithYSampleType() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()
		let groupingChooserController = mockGroupingChooserTableViewController()

		// when
		controller.chooseYAxisGrouperButtonPressed(self)

		// then
		assertThat(groupingChooserController.sampleType, equals(controller.ySampleType))
	}

	func testGivenAdvancedGrouper_chooseYAxisGrouperButtonPressed_doesNotAllowUserToChangeGrouperType() {
		// given
		setValidViewDidLoadRequirements()
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()
		let groupingChooserController = mockGroupingChooserTableViewController()

		// when
		controller.chooseYAxisGrouperButtonPressed(self)

		// then
		XCTAssertFalse(groupingChooserController.allowUserToChangeGrouperType)
	}

	func testGivenAdvancedGrouperAlreadyChosen_chooseYAxisGrouperButtonPressed_initsChooserWithCurrentYGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()
		let groupingChooserController = mockGroupingChooserTableViewController()

		// when
		controller.chooseYAxisGrouperButtonPressed(self)

		// then
		assertThat(groupingChooserController.currentGrouper, equals(controller.yGrouper))
	}

	func testGivenNonAdvancedGrouperAlreadyChosen_chooseYAxisGrouperButtonPressed_initsChooserWithCurrentYGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.yGrouper = SameTimeUnitSampleGrouper(sampleType: controller.ySampleType)
		controller.viewDidLoad()
		let editGrouperController = mockEditGrouperViewController()

		// when
		controller.chooseYAxisGrouperButtonPressed(self)

		// then
		assertThat(editGrouperController.currentGrouper, equals(controller.yGrouper))
	}

	func testGivenGrouperNotChosen_chooseYAxisGrouperButtonPressed_initsChooserWithDefaultYGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()
		let expectedGrouperType: SameTimeUnitSampleGrouper.Type = SameTimeUnitSampleGrouper.self
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouperType))
		let editGrouperController = mockEditGrouperViewController()

		NotificationCenter.default.post(
			name: NotificationName.grouperTypeChanged.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouperType])

		// when
		controller.chooseYAxisGrouperButtonPressed(self)

		// then
		assertThat(editGrouperController.currentGrouper as Any, isA(expectedGrouperType))
	}

	// MARK: - saveButtonPressed()

	func testGivenValidState_saveButtonPressed_postsNotificationWithCurrentAttributeType() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.xGrouper = AdvancedSampleGrouper()
		controller.yGrouper = SameTimeUnitSampleGrouper(sampleType: BloodPressure.self)
		controller.viewDidLoad()

		// when
		controller.saveButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<[UserInfoKey: Any]?>()
		Verify(mockNotificationUtil, .post(.value(.groupersEdited), object: .any, userInfo: .capturing(userInfoCaptor), qos: .any))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No UserInfo")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.attribute, withValue: controller.currentAttributeType))
	}

	func testGivenValidState_saveButtonPressed_postsNotificationWithXGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.xGrouper = AdvancedSampleGrouper()
		controller.yGrouper = SameTimeUnitSampleGrouper(sampleType: BloodPressure.self)
		controller.viewDidLoad()

		// when
		controller.saveButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<[UserInfoKey: Any]?>()
		Verify(mockNotificationUtil, .post(.value(.groupersEdited), object: .any, userInfo: .capturing(userInfoCaptor), qos: .any))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No UserInfo")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.x, withValue: controller.xGrouper, { $0.equalTo($1) }))
	}

	func testGivenValidState_saveButtonPressed_postsNotificationWithYGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.xGrouper = AdvancedSampleGrouper()
		controller.yGrouper = SameTimeUnitSampleGrouper(sampleType: BloodPressure.self)
		controller.viewDidLoad()

		// when
		controller.saveButtonPressed(self)

		// then
		let userInfoCaptor = ArgumentCaptor<[UserInfoKey: Any]?>()
		Verify(mockNotificationUtil, .post(.value(.groupersEdited), object: .any, userInfo: .capturing(userInfoCaptor), qos: .any))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No UserInfo")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.y, withValue: controller.yGrouper, { $0.equalTo($1) }))
	}

	func testGivenValidState_saveButtonPressed_popsFromNavigationController() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.xGrouper = AdvancedSampleGrouper()
		controller.yGrouper = SameTimeUnitSampleGrouper(sampleType: BloodPressure.self)
		controller.viewDidLoad()

		// when
		controller.saveButtonPressed(self)

		// then
		Verify(mockUiUtil, .popFrom(.any, animated: .any))
	}

	// MARK: - attributeTypeEdited()

	func testGivenValidNotification_attributeTypeEdited_setsCurrentAttributeType() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()
		let expectedAttributeType = controller.currentAttributeType + "other stuff"
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: expectedAttributeType))

		// when
		NotificationCenter.default.post(
			name: NotificationName.attributeTypeEdited.toName(),
			object: self,
			userInfo: [UserInfoKey.text: expectedAttributeType])

		// then
		assertThat(controller.currentAttributeType, equalTo(expectedAttributeType))
	}

	func testGivenValidNotification_attributeTypeEdited_enablesChooseGrouperTypeButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = nil
		controller.viewDidLoad()
		let expectedAttributeType = "other stuff"
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: expectedAttributeType))

		// when
		NotificationCenter.default.post(
			name: NotificationName.attributeTypeEdited.toName(),
			object: self,
			userInfo: [UserInfoKey.text: expectedAttributeType])

		// then
		XCTAssert(controller.chooseGrouperTypeButton.isEnabled)
	}

	func testGivenValidNotification_attributeTypeEdited_setsCorrectTitleForChooseAttributeTypeButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()
		let expectedAttributeType = controller.currentAttributeType + "other stuff"
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: expectedAttributeType))

		// when
		NotificationCenter.default.post(
			name: NotificationName.attributeTypeEdited.toName(),
			object: self,
			userInfo: [UserInfoKey.text: expectedAttributeType])

		// then
		assertThat(controller.chooseAttributeTypeButton, hasTitle(containsString(expectedAttributeType)))
	}

	// MARK: - grouperTypeEdited()

	func testGivenValidNotification_grouperTypeEdited_enablesChooseXGrouperButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()
		let expectedGrouperType = AdvancedSampleGrouper.self
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouperType))

		// when
		NotificationCenter.default.post(
			name: NotificationName.grouperTypeChanged.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouperType])

		// then
		XCTAssert(controller.chooseXGrouperButton.isEnabled)
	}

	func testGivenValidNotification_grouperTypeEdited_enablesChooseYGrouperButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()
		let expectedGrouperType = AdvancedSampleGrouper.self
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouperType))

		// when
		NotificationCenter.default.post(
			name: NotificationName.grouperTypeChanged.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouperType])

		// then
		XCTAssert(controller.chooseYGrouperButton.isEnabled)
	}

	func testGivenValidNotification_grouperTypeEdited_setsCorrectTitleForChooseGrouperTypeButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.currentAttributeType = "Date & Time"
		controller.viewDidLoad()
		let expectedGrouperType = AdvancedSampleGrouper.self
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouperType))

		// when
		NotificationCenter.default.post(
			name: NotificationName.grouperTypeChanged.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouperType])

		// then
		assertThat(controller.chooseGrouperTypeButton, hasTitle(containsString(expectedGrouperType.userVisibleDescription)))
	}

	// MARK: - xGrouperEdited()

	func testGivenValidNotification_xGrouperEdited_setsXGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()

		let expectedGrouper = SameTimeUnitSampleGrouper(sampleType: HeartRate.self)
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouper))

		// when
		NotificationCenter.default.post(
			name: NotificationName.xGrouperEdited.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouper])

		// then
		assertThat(controller.xGrouper, equals(expectedGrouper))
	}

	func testGivenValidNotification_xGrouperEdited_setsCorrectTitleForChooseXGrouperButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()

		mockGroupingChooserTableViewController()
		controller.chooseXAxisGrouperButtonPressed(self)
		let expectedGrouper = SameTimeUnitSampleGrouper(sampleType: HeartRate.self)
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouper))

		// when
		NotificationCenter.default.post(
			name: NotificationName.grouperEdited.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouper])

		// then
		assertThat(controller.chooseXGrouperButton, hasTitle("X-Axis Grouping Chosen"))
	}

	// MARK: - yGrouperEdited()

	func testGivenValidNotification_yGrouperEdited_setsYGrouper() {
		// given
		setValidViewDidLoadRequirements()
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()

		let expectedGrouper = SameTimeUnitSampleGrouper(sampleType: HeartRate.self)
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouper))

		// when
		NotificationCenter.default.post(
			name: NotificationName.yGrouperEdited.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouper])

		// then
		assertThat(controller.yGrouper, equals(expectedGrouper))
	}

	func testGivenValidNotification_yGrouperEdited_setsCorrectTitleForChooseYGrouperButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()

		mockGroupingChooserTableViewController()
		controller.chooseYAxisGrouperButtonPressed(self)
		let expectedGrouper = SameTimeUnitSampleGrouper(sampleType: HeartRate.self)
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: expectedGrouper))

		// when
		NotificationCenter.default.post(
			name: NotificationName.yGrouperEdited.toName(),
			object: self,
			userInfo: [UserInfoKey.sampleGrouper: expectedGrouper])

		// then
		assertThat(controller.chooseYGrouperButton, hasTitle("Y-Axis Grouping Chosen"))
	}

	// MARK: - xGrouperSet()

	func testGivenYGrouperAlreadySetThenXGrouperSetToNil_xGrouperSet_disablesSaveButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = AdvancedSampleGrouper()
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()

		// when
		controller.xGrouper = nil

		// then
		assertThat(controller.saveButton, not(isEnabled()))
	}

	func testGivenYGrouperAlreadySetThenXGrouperSet_xGrouperSet_enablesSaveButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = nil
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()

		// when
		controller.xGrouper = AdvancedSampleGrouper()

		// then
		assertThat(controller.saveButton, isEnabled())
	}

	// MARK: - yGrouperSet()

	func testGivenXGrouperAlreadySetThenYGrouperSetToNil_yGrouperSet_disablesSaveButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = AdvancedSampleGrouper()
		controller.yGrouper = AdvancedSampleGrouper()
		controller.viewDidLoad()

		// when
		controller.yGrouper = nil

		// then
		assertThat(controller.saveButton, not(isEnabled()))
	}

	func testGivenXGrouperAlreadySetThenYGrouperSet_yGrouperSet_enablesSaveButton() {
		// given
		setValidViewDidLoadRequirements()
		controller.xGrouper = AdvancedSampleGrouper()
		controller.yGrouper = nil
		controller.viewDidLoad()

		// when
		controller.yGrouper = AdvancedSampleGrouper()

		// then
		assertThat(controller.saveButton, isEnabled())
	}

	// MARK: - Helper Classes

	private class TestSample: Sample {
		static var name: String = ""
		static var attributes: [Attribute] = []
		static var defaultDependentAttribute: Attribute = CommonSampleAttributes.endDate
		static var defaultIndependentAttribute: Attribute = CommonSampleAttributes.endDate
		static var dateAttributes = [DateType: DateAttribute]()
		let attributedName: String = ""
		let attributes: [Attribute] = []
		let description: String = ""

		func dates() -> [DateType : Date] { return [:] }
		func value(of attribute: Attribute) throws -> Any? { return nil }
		func set(attribute: Attribute, to value: Any?) throws {}
	}

	// MARK: - Helper Functions

	private final func setValidViewDidLoadRequirements() {
		controller.xSampleType = HeartRate.self
		controller.ySampleType = BloodPressure.self
	}

	@discardableResult
	private final func mockChooseSampleGrouperTypeViewController() -> ChooseSampleGrouperTypeViewController {
		let controller = ChooseSampleGrouperTypeViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseSampleGrouperType"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockChooseTextViewController() -> ChooseTextViewController {
		let controller = ChooseTextViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseText"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockGroupingChooserTableViewController() -> GroupingChooserTableViewController {
		let controller = GroupingChooserTableViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseGrouper"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockEditGrouperViewController() -> EditGrouperViewController {
		let controller = EditGrouperViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("editGrouper"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}
}
