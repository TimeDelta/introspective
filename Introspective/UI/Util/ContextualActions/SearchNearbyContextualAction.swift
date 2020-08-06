//
//  SearchNearbyContextualAction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import AttributeRestrictions
import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
import Samples
import Settings
import UIExtensions

public final class SearchNearbyContextualAction: UIContextualAction {
	// MARK: - Static Variables

	private typealias Me = SearchNearbyContextualAction

	public static let choseSearchNearbyDuration = Notification.Name("choseSearchNearbyDuration")

	private static let log = Log()

	// MARK: - Instance Variables

	private weak final var parentController: UIViewController?

	private final let backButtonTitle: String
	private final let selectedSampleDates: [DateType: Date]
	private final var selectedSampleType: Sample.Type!

	public final override var backgroundColor: UIColor! {
		get { .systemBlue }
		set {} // don't let background color change
	}

	public final override var style: UIContextualAction.Style { .normal }
	public final override var title: String? {
		get { "🔍 Nearby" }
		set {} // don't let title change
	}

	public final override var handler: UIContextualAction.Handler {
		{ action, view, completion in
			let actionSheet = DependencyInjector.get(UiUtil.self).alert(
				title: "Which data type?",
				message: "Choose a type of data for which to search.",
				preferredStyle: .actionSheet
			)
			for sampleType in DependencyInjector.get(SampleFactory.self).allTypes() {
				let dateAttributes = sampleType.attributes.filter { $0 is DateAttribute }
				guard dateAttributes.count > 0 else { continue }
				actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
					title: sampleType.name,
					style: .default
				) { _ in
					// if the parent controllere doesn't exist anymore, no point in continuing
					guard let parentController = self.parentController else { return }

					let controller = parentController.viewController(
						named: "durationChooser",
						fromStoryboard: "Util"
					) as! SelectDurationViewController
					controller.initialDuration = DependencyInjector.get(Settings.self).defaultSearchNearbyDuration
					controller.notificationToSendOnAccept = Me.choseSearchNearbyDuration
					self.selectedSampleType = sampleType
					parentController.present(controller, using: DependencyInjector.get(UiUtil.self).defaultPresenter)
				})
			}
			actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
				title: "Cancel",
				style: .cancel,
				handler: nil
			))
			self.parentController?.presentView(actionSheet, completion: { completion(true) })
		}
	}

	// MARK: - Initializers

	public init(controller: UIViewController, backButtonTitle: String?, originDates: [DateType: Date]) {
		parentController = controller
		self.backButtonTitle = backButtonTitle ?? "Back"
		selectedSampleDates = originDates
		super.init()
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(searchNearby),
			name: Me.choseSearchNearbyDuration,
			object: nil
		)
	}

	// MARK: - Received Notifications

	@objc private final func searchNearby(notification: Notification) {
		// if the parent controller doesn't exist anymore, no point in continuing
		guard let parentController = parentController else { return }

		guard let duration: TimeDuration = value(for: .duration, from: notification) else {
			Me.log.error("Missing duration for searchNearby notification")
			return
		}
		do {
			var query = try DependencyInjector.get(QueryFactory.self).queryFor(selectedSampleType)
			let start = selectedSampleDates[.start]
			let end = selectedSampleDates[.end]
			if let startDate = start, let endDate = end {
				try buildNearbyQuery(
					&query,
					sampleType: selectedSampleType,
					startDate: startDate,
					endDate: endDate,
					duration: duration
				)
			} else if let timestamp = start {
				try buildNearbyQuery(
					&query,
					sampleType: selectedSampleType,
					timestamp: timestamp,
					duration: duration
				)
			} else {
				Me.log.error("Sample type has no dates: %@", selectedSampleType.name)
			}
			let controller = parentController.viewController(
				named: "results",
				fromStoryboard: "Results"
			) as! ResultsViewController
			query.runQuery { (result: QueryResult?, error: Error?) in
				if let error = error {
					DispatchQueue.main.async {
						controller.showError(title: "Failed to run query", error: error)
					}
					return
				}
				controller.samples = result?.samples
			}
			controller.query = query
			controller.backButtonTitle = backButtonTitle
			parentController.pushToNavigationController(controller)
		} catch {
			if let displayableError = error as? DisplayableError {
				parentController.showError(
					title: displayableError.displayableTitle,
					message: displayableError.displayableDescription
				)
			} else {
				parentController.showError(title: "Failed to generate query")
			}
		}
	}

	// MARK: - Helper Functions

	/// Build a query to search nearby a sample that has two dates.
	private final func buildNearbyQuery(
		_ query: inout Query,
		sampleType: Sample.Type,
		startDate: Date,
		endDate: Date,
		duration: TimeDuration
	) throws {
		let minDate = startDate - duration
		let maxDate = endDate + duration
		guard let startAttribute = sampleType.dateAttributes[.start] else {
			Me.log.error("Missing start attribute for %@", sampleType.name)
			throw GenericDisplayableError(
				title: "Unable to search nearby",
				description: "You found a bug: please report RVCbnq1"
			)
		}
		if let endAttribute = sampleType.dateAttributes[.end] {
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: endAttribute, date: maxDate)
			)
		} else { // only one attribute on target sample type
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: maxDate)
			)
		}
	}

	/// Build a query to search nearby a sample that has only one date.
	private final func buildNearbyQuery(
		_ query: inout Query,
		sampleType: Sample.Type,
		timestamp: Date,
		duration: TimeDuration
	) throws {
		let minDate = timestamp - duration
		let maxDate = timestamp + duration
		guard let startAttribute = sampleType.dateAttributes[.start] else {
			Me.log.error("Missing start attribute for %@", sampleType.name)
			throw GenericDisplayableError(
				title: "Unable to search nearby",
				description: "You found a bug: please report RVCbnq3"
			)
		}
		if let endAttribute = sampleType.dateAttributes[.end] {
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: endAttribute, date: maxDate)
			)
		} else { // only one attribute on target sample type
			query.expression = AndExpression(
				AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minDate),
				BeforeDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: maxDate)
			)
		}
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	private final func value<Type>(
		for key: UserInfoKey,
		from notification: Notification,
		keyIsOptional: Bool = false
	) -> Type? {
		DependencyInjector.get(UiUtil.self).value(for: key, from: notification, keyIsOptional: keyIsOptional)
	}
}
