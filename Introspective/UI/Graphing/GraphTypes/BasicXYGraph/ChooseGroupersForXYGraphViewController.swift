//
//  ChooseGroupersForXYGraphViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 5/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import DependencyInjection
import SampleGroupers
import Samples
import UIExtensions

public protocol ChooseGroupersForXYGraphViewController: UIViewController {
	var xSampleType: Sample.Type! { get set }
	var ySampleType: Sample.Type! { get set }
	var navBarTitle: String! { get set }
	var xGrouper: SampleGrouper! { get set }
	var yGrouper: SampleGrouper! { get set }
	var currentAttributeType: String! { get set }
	var notificationToSendOnAccept: NotificationName! { get set }
}

public final class ChooseGroupersForXYGraphViewControllerImpl: UIViewController,
	ChooseGroupersForXYGraphViewController {
	// MARK: - IBOutlets

	@IBOutlet final var chooseAttributeTypeButton: UIButton!
	@IBOutlet final var chooseGrouperTypeButton: UIButton!
	@IBOutlet final var chooseXGrouperButton: UIButton!
	@IBOutlet final var chooseYGrouperButton: UIButton!
	@IBOutlet final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var xSampleType: Sample.Type!
	public final var ySampleType: Sample.Type!
	public final var navBarTitle: String!
	public final var xGrouper: SampleGrouper! {
		didSet { waitUntilLoaded { self.xGrouperSet() } }
	}

	public final var yGrouper: SampleGrouper! {
		didSet { waitUntilLoaded { self.yGrouperSet() } }
	}

	public final var currentAttributeType: String! {
		didSet { waitUntilLoaded { self.attributeTypeSet() } }
	}

	public final var notificationToSendOnAccept: NotificationName!

	private final var xAttributeTypeToAttributes = [String: [Attribute]]()
	private final var yAttributeTypeToAttributes = [String: [Attribute]]()
	private final var commonAttributeTypes = [String]()

	private final var availableGroupers = [SampleGrouper]()
	private final var chosenGrouperType: SampleGrouper.Type! {
		didSet { waitUntilLoaded { self.chosenGrouperTypeSet() } }
	}

	/// Leave this as member field because saving an AdvancedSampleGrouper doesn't work otherwise
	private final var currentGrouperChooser: GroupingChooserTableViewController!

	/// Avoid resetting dependent values for first set of members from outside class
	private final var publicSetDone = false
	private final var finishedLoading = false
	/// Delay certain functions until loading complete to avoid errors being thrown
	/// (i.e. accessing a UI element before it has been initialized)
	private final var runWhenFinishedLoading = [() -> Void]()
	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		title = navBarTitle

		populateXAttributes()
		populateYAttributes()

		guard !commonAttributeTypes.isEmpty else {
			parent?.showError(title: "No Attribute types in common")
			popFromNavigationController()
			return
		}

		observe(selector: #selector(attributeTypeEdited), name: .attributeTypeEdited)
		observe(selector: #selector(grouperTypeEdited), name: .grouperTypeChanged)
		observe(selector: #selector(xGrouperEdited), name: .xGrouperEdited)
		observe(selector: #selector(yGrouperEdited), name: .yGrouperEdited)

		finishedLoading = true
		for function in runWhenFinishedLoading {
			function()
		}
		publicSetDone = true
	}

	// MARK: - Button Actions

	@IBAction final func chooseAttributeTypeButtonPressed(_: Any) {
		let controller = viewController(named: "chooseText", fromStoryboard: "Util") as! ChooseTextViewController
		controller.availableChoices = commonAttributeTypes
		controller.selectedText = currentAttributeType
		controller.notificationToSendOnAccept = .attributeTypeEdited
		present(controller, using: DependencyInjector.get(UiUtil.self).defaultPresenter)
	}

	@IBAction final func chooseGrouperTypeButtonPressed(_: Any) {
		let controller = viewController(
			named: "chooseSampleGrouperType",
			fromStoryboard: "Util"
		) as! ChooseSampleGrouperTypeViewController
		guard let attributes = xAttributeTypeToAttributes[currentAttributeType] else {
			log.error("No attributes of chosen type found for x-axis")
			return
		}
		controller.grouperTypes = DependencyInjector.get(SampleGrouperFactory.self).typesFor(attributes: attributes)
		controller.selectedGrouperType = chosenGrouperType
		present(controller, using: DependencyInjector.get(UiUtil.self).defaultPresenter)
	}

	@IBAction final func chooseXAxisGrouperButtonPressed(_: Any) {
		var grouper = xGrouper
		if grouper == nil {
			if let xApplicableAttributes = xAttributeTypeToAttributes[currentAttributeType] {
				grouper = chosenGrouperType.init(attributes: xApplicableAttributes)
			}
		}

		guard let currentGrouper = grouper else {
			log.error("No x-axis attributes for chosen attribute type")
			return
		}

		showGrouperEditController(
			grouper: currentGrouper,
			notificationToSendOnAccept: .xGrouperEdited,
			sampleType: xSampleType
		)
	}

	@IBAction final func chooseYAxisGrouperButtonPressed(_: Any) {
		var grouper = yGrouper
		if grouper == nil {
			if let yApplicableAttributes = yAttributeTypeToAttributes[currentAttributeType] {
				grouper = chosenGrouperType.init(attributes: yApplicableAttributes)
			}
		}

		guard let currentGrouper = grouper else {
			log.error("No y-axis attributes for chosen attribute type")
			return
		}

		showGrouperEditController(
			grouper: currentGrouper,
			notificationToSendOnAccept: .yGrouperEdited,
			sampleType: ySampleType
		)
	}

	@IBAction final func saveButtonPressed(_: Any) {
		syncPost(
			.groupersEdited,
			userInfo: [
				.attribute: currentAttributeType,
				.x: xGrouper,
				.y: yGrouper,
			]
		)
		popFromNavigationController()
	}

	// MARK: - Received Notifications

	@objc private final func attributeTypeEdited(notification: Notification) {
		if let attributeType: String = value(for: .text, from: notification) {
			guard currentAttributeType != attributeType else { return }
			currentAttributeType = attributeType
		}
	}

	@objc private final func grouperTypeEdited(notification: Notification) {
		if let grouperType: SampleGrouper.Type? = value(for: .sampleGrouper, from: notification) {
			guard chosenGrouperType != grouperType else { return }
			chosenGrouperType = grouperType
		}
	}

	@objc private final func xGrouperEdited(notification: Notification) {
		if let grouper: SampleGrouper = value(for: .sampleGrouper, from: notification) {
			guard xGrouper != nil else {
				xGrouper = grouper
				return
			}
			guard !xGrouper.equalTo(grouper) else { return }
			xGrouper = grouper
		}
	}

	@objc private final func yGrouperEdited(notification: Notification) {
		if let grouper: SampleGrouper = value(for: .sampleGrouper, from: notification) {
			guard yGrouper != nil else {
				yGrouper = grouper
				return
			}
			guard !yGrouper.equalTo(grouper) else { return }
			yGrouper = grouper
		}
	}

	// MARK: - Helper Functions

	private final func populateXAttributes() {
		for attribute in xSampleType.attributes {
			if var attributes = xAttributeTypeToAttributes[attribute.typeName] {
				attributes.append(attribute)
				xAttributeTypeToAttributes[attribute.typeName] = attributes
			} else {
				xAttributeTypeToAttributes[attribute.typeName] = [attribute]
			}
		}
	}

	private final func populateYAttributes() {
		for attribute in ySampleType.attributes {
			if var attributes = yAttributeTypeToAttributes[attribute.typeName] {
				attributes.append(attribute)
				yAttributeTypeToAttributes[attribute.typeName] = attributes
			} else {
				yAttributeTypeToAttributes[attribute.typeName] = [attribute]
			}
			if let _ = xAttributeTypeToAttributes[attribute.typeName] {
				if !commonAttributeTypes.contains(attribute.typeName) {
					commonAttributeTypes.append(attribute.typeName)
				}
			}
		}
	}

	private final func showGrouperEditController(
		grouper: SampleGrouper,
		notificationToSendOnAccept: NotificationName,
		sampleType: Sample.Type
	) {
		// go straight to AttributedList controller if not advanced sample grouper to give a
		// better user experience
		if grouper is AdvancedSampleGrouper {
			currentGrouperChooser =
				(viewController(named: "chooseGrouper", fromStoryboard: "Util") as! GroupingChooserTableViewController)
			currentGrouperChooser.sampleType = sampleType
			currentGrouperChooser.currentGrouper = grouper
			currentGrouperChooser.allowUserToChangeGrouperType = false
			currentGrouperChooser.notificationToSendOnAccept = notificationToSendOnAccept
			pushToNavigationController(currentGrouperChooser)
		} else {
			let controller = viewController(named: "editGrouper", fromStoryboard: "Util") as! EditGrouperViewController
			controller.currentGrouper = grouper
			controller.availableGroupers = [grouper]
			controller.notificationToSendWhenAccepted = notificationToSendOnAccept
			pushToNavigationController(controller)
		}
	}

	private final func updateSaveButtonState() {
		saveButton.isEnabled = xGrouper != nil && yGrouper != nil
	}

	// MARK: Variable Did Set Functions

	private final func attributeTypeSet() {
		guard let attributeType = currentAttributeType else {
			chooseAttributeTypeButton.setTitle("Choose Attribute Type", for: .normal)
			chooseGrouperTypeButton.isEnabled = false
			chooseXGrouperButton.isEnabled = false
			chooseYGrouperButton.isEnabled = false
			return
		}
		chooseAttributeTypeButton.setTitle("Attribute Type: " + attributeType, for: .normal)
		chooseGrouperTypeButton.isEnabled = true
		if publicSetDone {
			chosenGrouperType = nil
		}
	}

	private final func chosenGrouperTypeSet() {
		guard let chosenGrouperType = chosenGrouperType else {
			chooseGrouperTypeButton.setTitle("Choose Grouping Type", for: .normal)
			chooseXGrouperButton.isEnabled = false
			chooseYGrouperButton.isEnabled = false
			return
		}
		let grouperTypeName = chosenGrouperType.userVisibleDescription.localizedCapitalized
		chooseGrouperTypeButton.setTitle(grouperTypeName, for: .normal)
		chooseXGrouperButton.isEnabled = true
		chooseYGrouperButton.isEnabled = true
		if publicSetDone {
			xGrouper = nil
			yGrouper = nil
		}
	}

	private final func xGrouperSet() {
		if let grouper = xGrouper {
			chooseXGrouperButton.setTitle("X-Axis Grouping Chosen", for: .normal)
			if chosenGrouperType == nil {
				chosenGrouperType = type(of: grouper)
			}
		} else {
			chooseXGrouperButton.setTitle("Choose X-Axis Grouping", for: .normal)
		}
		updateSaveButtonState()
	}

	private final func yGrouperSet() {
		if let grouper = yGrouper {
			chooseYGrouperButton.setTitle("Y-Axis Grouping Chosen", for: .normal)
			if chosenGrouperType == nil {
				chosenGrouperType = type(of: grouper)
			}
		} else {
			chooseYGrouperButton.setTitle("Choose Y-Axis Grouping", for: .normal)
		}
		updateSaveButtonState()
	}

	/// Delay certain functions until loading complete to avoid errors being thrown
	/// (i.e. accessing a UI element before it has been initialized)
	private final func waitUntilLoaded(_ function: @escaping () -> Void) {
		guard finishedLoading else {
			runWhenFinishedLoading.append(function)
			return
		}
		function()
	}
}
