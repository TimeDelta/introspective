//
//  QueryViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import Instructions

import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
import Samples
import UIExtensions

public protocol QueryViewController: UITableViewController {

	var finishedButtonTitle: String { get set }
	var finishedButtonNotification: NotificationName { get set }
	var topmostSampleType: Sample.Type? { get set }
	var initialQuery: Query? { get set }
}

public final class QueryViewControllerImpl: UITableViewController, QueryViewController {

	// MARK: - Structs

	struct SampleTypeInfo {
		var sampleType: Sample.Type = DependencyInjector.get(SampleFactory.self).allTypes()[0]
		var matcher: SubQueryMatcher? = SameDatesSubQueryMatcher()

		init() {}
		init(_ sampleType: Sample.Type) {
			self.sampleType = sampleType
		}
		init(_ sampleType: Sample.Type, _ matcher: SubQueryMatcher) {
			self.sampleType = sampleType
			self.matcher = matcher
		}
	}

	// MARK: - Static Variables

	private typealias Me = QueryViewControllerImpl
	private static let acceptedAttributeRestrictionEdit = Notification.Name("acceptedAttributeRestrictionEdit")
	private static let acceptedSubSampleTypeEdit = Notification.Name("acceptedSubSampleTypeEdit")

	private static let editSampleTypePresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var addPartButton: UIBarButtonItem!
	@IBOutlet weak final var finishedButton: UIBarButtonItem!
	@IBOutlet weak final var editButton: UIBarButtonItem!
	@IBOutlet weak final var toolbar: UIToolbar!

	// MARK: - Instance Variables

	public final var finishedButtonTitle: String = "Run"
	/// Corresponding notification object will contain the built query as the object
	public final var finishedButtonNotification: NotificationName = .runQuery
	/// This will prevent the topmost sample type from being changed by the user
	public final var topmostSampleType: Sample.Type?
	public final var initialQuery: Query?

	// leave non-private for testing purposes
	final var queries = [(sampleTypeInfo: SampleTypeInfo, parts: [BooleanExpressionPart])]()
	private final var editedSampleTypeSectionIndex: Int!
	private final var editedAttributeRestrictionIndex: IndexPath!

	private final let log = Log()

	private final var coachMarksController = DependencyInjector.get(CoachMarkFactory.self).controller()
	private final var coachMarksDataSourceAndDelegate: DefaultCoachMarksDataSourceAndDelegate!
	private final lazy var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "This is the main data type. It determines what type of data will be returned by this query. Tap it to change the main data type.",
			useArrow: true,
			view: { return self.tableView.visibleCells[0] }),
		CoachMarkInfo(
			hint: "Press the + button to add more parts to the query.",
			useArrow: false,
			view: { return self.toolbar }),
		CoachMarkInfo(
			hint: "This is an attribute restriction. It allows you to restrict which samples are returned based on their attributes. Tap it to edit.",
			useArrow: false,
			view: {
				var attributeRestrictionIndexPath = IndexPath(row: 1, section: 0)
				for section in 0 ..< self.queries.count {
					for row in 0 ..< self.queries[section].parts.count {
						if self.queries[section].parts[row].type == .expression {
							attributeRestrictionIndexPath = IndexPath(row: row, section: section)
							break
						}
					}
				}
				self.tableView.scrollToRow(at: attributeRestrictionIndexPath, at: .bottom, animated: true)
				return self.tableView.visibleCells.last!
			},
			setup: {
				var hasAttributeRestriction = false
				for query in self.queries {
					for part in query.parts {
						if part.type == .expression {
							hasAttributeRestriction = true
							break
						}
					}
				}
				if !hasAttributeRestriction {
					self.addOrUpdateAttributeRestrictionFor(nil)
				}
			}),
		CoachMarkInfo(
			hint: "This is the start of a subquery. It allows you to restrict what samples are returned based on other types of data. Tap it to edit.",
			useArrow: false,
			view: {
				self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
				return self.tableView.visibleCells[0]
			},
			setup: {
				if self.queries.count < 2 {
					self.queries.append((sampleTypeInfo: SampleTypeInfo(DependencyInjector.get(SampleFactory.self).allTypes()[1]), parts: []))
					self.partWasAdded()
				}
			}),
		CoachMarkInfo(
			hint: "Swipe left on any part of the query (except the main data type) to reveal a button that will remove that part of the query.",
			useArrow: true,
			view: { return self.tableView.visibleCells[2] })
	]

	// MARK: - UIViewController Overloads

	public final override func viewDidLoad() {
		super.viewDidLoad()

		editButton.target = self
		editButton.action = #selector(editButtonPressed)

		finishedButton.title = finishedButtonTitle

		if let query = initialQuery {
			populateQuery(query)
		} else if topmostSampleType != nil {
			queries = [(sampleTypeInfo: SampleTypeInfo(topmostSampleType!), parts: [])]
			partWasAdded()
		} else if queries.count == 0 { // add this condition for testing purposes
			queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [])]
			partWasAdded()
		}

		observe(selector: #selector(saveEditedSubQuerySampleType), name: Me.acceptedSubSampleTypeEdit)
		observe(selector: #selector(saveEditedSampleType), name: .sampleTypeEdited)
		observe(selector: #selector(saveEditedAttributeRestriction), name: .attributeRestrictionEdited)

		addPartButton?.target = self
		addPartButton?.action = #selector(addPartButtonWasPressed)

		coachMarksDataSourceAndDelegate = DefaultCoachMarksDataSourceAndDelegate(
			coachMarksInfo,
			instructionsShownKey: .queryViewInstructionsShown,
			skipViewLayoutConstraints: defaultCoachMarkSkipViewConstraints())
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = defaultSkipInstructionsView()
	}

	public final override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !DependencyInjector.get(UserDefaultsUtil.self).bool(forKey: .queryViewInstructionsShown) {
			coachMarksController.start(in: .window(over: self))
		}
	}

	public final override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		coachMarksController.stop(immediately: true)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table View Data Source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return queries.count
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return queries[section].parts.count + 1 // need to add 1 for the sample type cell
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let query = queries[indexPath.section]

		if indexPath.section == 0 && indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Data Type", for: indexPath)
			cell.textLabel?.text = query.sampleTypeInfo.sampleType.name
			cell.textLabel?.accessibilityValue = query.sampleTypeInfo.sampleType.name
			if topmostSampleType != nil {
				cell.isUserInteractionEnabled = false
			}
			return cell
		}

		guard indexPath.row != 0 else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Sub Data Type", for: indexPath) as! SubSampleTypeTableViewCell
			cell.matcher = query.sampleTypeInfo.matcher
			cell.sampleType = query.sampleTypeInfo.sampleType
			return cell
		}

		let part = query.parts[indexPath.row - 1]
		switch (part.type) {
			case .expression:
				if let attributeRestriction = part.expression as? AttributeRestriction {
					let cell = tableView.dequeueReusableCell(
						withIdentifier: "Attribute Restriction",
						for: indexPath) as! AttributeRestrictionTableViewCell
					cell.attributeRestriction = attributeRestriction
					cell.indentationLevel = getIndentationLevelFor(indexPath)
					return cell
				}
				log.error("Unknown expression type in query")
				break
			case .and:
				return andCell(for: indexPath)
			case .or:
				return orCell(for: indexPath)
			case .groupStart:
				return groupStartCell(for: indexPath)
			case .groupEnd:
				return groupEndCell(for: indexPath)
		}
		log.error("Forgot a type of cell: %@", String(describing: part))
		return UITableViewCell()
	}

	// MARK: - Table View Delegate

	public final override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section != 0 || indexPath.row != 0
	}

	public final override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section != 0 || indexPath.row != 0
	}

	public final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		if let fromPart = getPartFor(fromIndexPath) {
			guard to.section != 0 || to.row != 0 else {
				log.debug("User tried to move non-data-type query part to top row of query")
				return
			}
			if fromPart.type != .expression {
				movePart(from: fromIndexPath, to: to)
			} else {
				movePart(from: fromIndexPath, to: to)
				ensureValidExpression(at: to)
			}
		} else {
			if fromIndexPath.section != to.section {
				let orphanedParts = queries[fromIndexPath.section].parts
				let fromSampleTypeInfo = queries[fromIndexPath.section].sampleTypeInfo
				queries.remove(at: fromIndexPath.section)

				// user not allowed to move section 0, row 0 so this won't produce out of range error
				queries[fromIndexPath.section - 1].parts.append(contentsOf: orphanedParts)
				updateAttributeRestrictionsForSampleType(at: fromIndexPath.section - 1)

				var partsToTakeOwnershipOf = [BooleanExpressionPart]()
				let toSectionIndex: Int
				if to.row == 0 {
					toSectionIndex = to.section
				} else {
					if fromIndexPath.section < to.section {
						toSectionIndex = to.section
					} else {
						toSectionIndex = to.section + 1
					}
					let firstRowToTakeOwnershipOf = to.row - 1 // row has + 1 because of data type cell
					partsToTakeOwnershipOf = Array(queries[toSectionIndex - 1].parts[firstRowToTakeOwnershipOf...])
					queries[toSectionIndex - 1].parts.removeLast(partsToTakeOwnershipOf.count)
				}
				updateAttributeRestrictionsForSampleType(at: fromIndexPath.section - 1)
				let newSection = (sampleTypeInfo: fromSampleTypeInfo, parts: partsToTakeOwnershipOf)
				queries.insert(newSection, at: toSectionIndex)
				updateAttributeRestrictionsForSampleType(at: toSectionIndex)
			} else { // same section
				let orphanedParts = Array(queries[fromIndexPath.section].parts[0 ..< to.row])
				queries[fromIndexPath.section].parts.removeFirst(orphanedParts.count)
				queries[fromIndexPath.section - 1].parts.append(contentsOf: orphanedParts)
				updateAttributeRestrictionsForSampleType(at: fromIndexPath.section - 1)
			}
		}
		tableView.reloadData()
		validate()
	}

	public final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		guard indexPath.section > 0 || indexPath.row > 0 else { return nil }
		let delete = DependencyInjector.get(UiUtil.self).tableViewRowAction(style: .destructive, title: "🗑️") { (_, indexPath) in
			if indexPath.row == 0 {
				let orphanedParts = self.queries[indexPath.section].parts
				self.queries.remove(at: indexPath.section)
				self.queries[indexPath.section - 1].parts.append(contentsOf: orphanedParts)
				self.updateAttributeRestrictionsForSampleType(at: indexPath.section - 1)
			} else {
				// row has + 1 because of data type cell
				self.queries[indexPath.section].parts.remove(at: indexPath.row - 1)
			}
			tableView.reloadData()
			self.validate()
		}

		return [delete]
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.row == 0 {
			let controller = viewController(named: "chooseSampleType", fromStoryboard: "Util") as! ChooseSampleTypeViewController
			editedSampleTypeSectionIndex = 0
			controller.selectedSampleType = queries[0].sampleTypeInfo.sampleType
			controller.notificationToSendOnAccept = .sampleTypeEdited
			tableView.deselectRow(at: indexPath, animated: false)
			customPresentViewController(Me.editSampleTypePresenter, viewController: controller, animated: false)
		} else if let part = getPartFor(indexPath) {
			if part.type != .expression {
				showExpressionParts(indexPath)
			}
		}
	}

	// MARK: - Button Actions

	@IBAction final func infoButtonPressed(_ sender: Any) {
		coachMarksController.start(in: .window(over: self))
	}

	@IBAction final func finishedButtonPressed(_ sender: Any) {
		guard let query = buildQuery() else {
			log.error("buildQuery() returned nil")
			showError(title: "Failed to build query")
			return
		}
		if finishedButtonNotification != .runQuery {
			syncPost(
				finishedButtonNotification,
				userInfo: [
					.query: query,
				])
			popFromNavigationController()
		} else {
			let controller = viewController(named: "results", fromStoryboard: "Results") as! ResultsViewController
			query.runQuery { (result: QueryResult?, error: Error?) in
				if error != nil {
					DispatchQueue.main.async {
						controller.showError(title: "Failed to run query", error: error)
					}
					return
				}
				controller.samples = result?.samples
			}
			controller.query = query
			pushToNavigationController(controller)
		}
	}

	@objc private final func addPartButtonWasPressed() {
		showExpressionParts()
	}

	@objc private final func editButtonPressed() {
		editButton.title = isEditing ? "Edit" : "Done"
		let _ = editButtonItem.target?.perform(editButtonItem.action)
	}

	// MARK: - Navigation

	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditAttributeRestrictionViewController {
			let controller = segue.destination as! EditAttributeRestrictionViewController
			let source = sender as! UITableViewCell
			editedAttributeRestrictionIndex = tableView.indexPath(for: source)
			controller.sampleType = queries[editedAttributeRestrictionIndex.section].sampleTypeInfo.sampleType
			guard let attributeRestriction = getPartFor(editedAttributeRestrictionIndex)?.expression as? AttributeRestriction else {
				log.error("Expected attribute restriction for segue but did not get one")
				return
			}
			controller.attributeRestriction = attributeRestriction
		} else if segue.destination is EditSubSampleTypeViewController {
			let controller = (segue.destination as! EditSubSampleTypeViewController)
			let source = (sender as! UITableViewCell)
			editedSampleTypeSectionIndex = tableView.indexPath(for: source)!.section
			controller.sampleType = queries[editedSampleTypeSectionIndex].sampleTypeInfo.sampleType
			controller.matcher = queries[editedSampleTypeSectionIndex].sampleTypeInfo.matcher
			controller.notificationToSendWhenAccepted = Me.acceptedSubSampleTypeEdit
		}
	}

	// MARK: - Received Notifications

	@objc final func saveEditedSampleType(notification: Notification) {
		guard let sampleType: Sample.Type? = value(for: .sampleType, from: notification) else { return }
		queries[editedSampleTypeSectionIndex].sampleTypeInfo = SampleTypeInfo(sampleType!)
		updateAttributeRestrictionsForSampleType(at: editedSampleTypeSectionIndex)
		validate()
		tableView.reloadData()
	}

	@objc final func saveEditedAttributeRestriction(notification: Notification) {
		if let attributeRestriction: AttributeRestriction? = value(for: .attributeRestriction, from: notification) {
			guard let index = editedAttributeRestrictionIndex else {
				log.error("editedAttributeRestrictionIndex was nil")
				return
			}
			queries[index.section].parts[index.row - 1].expression = attributeRestriction
			validate()
			tableView.reloadData()
		}
	}

	@objc final func saveEditedSubQuerySampleType(notification: Notification) {
		guard let sampleTypeInfo: SampleTypeInfo = value(for: .sampleType, from: notification) else { return }
		queries[editedSampleTypeSectionIndex].sampleTypeInfo = sampleTypeInfo
		updateAttributeRestrictionsForSampleType(at: editedSampleTypeSectionIndex)
		validate()
		tableView.reloadData()
	}

	// MARK: - Helper Functions

	private final func addSampleType() {
		queries.append((sampleTypeInfo: SampleTypeInfo(), parts: []))
		partWasAdded()
	}

	private final func updateAttributeRestrictionsForSampleType(at sampleTypeIndex: Int) {
		for i in 0 ..< queries[sampleTypeIndex].parts.count {
			if let attributeRestriction = queries[sampleTypeIndex].parts[i].expression as? AttributeRestriction {
				let attribute = attributeRestriction.restrictedAttribute
				let sampleType = queries[sampleTypeIndex].sampleTypeInfo.sampleType
				if let attributeIndex = sampleType.attributes.firstIndex(where: { $0.equalTo(attribute) }) {
					attributeRestriction.restrictedAttribute = sampleType.attributes[attributeIndex]
					queries[sampleTypeIndex].parts[i].expression = attributeRestriction
				} else {
					queries[sampleTypeIndex].parts[i].expression = defaultAttributeRestriction(for: sampleType)
				}
			}
		}
	}

	private final func bottomMostSampleType() -> Sample.Type {
		return queries.last!.sampleTypeInfo.sampleType
	}

	private final func bottomMostSampleTypeAbove(_ indexPath: IndexPath) -> Sample.Type {
		return queries[indexPath.section].sampleTypeInfo.sampleType
	}

	private final func partWasAdded() {
		if queries.count > 1 || queries[0].parts.count > 0 {
			tableView.reloadData()
		}
		validate()
	}

	private final func defaultAttributeRestriction(for sampleType: Sample.Type) -> AttributeRestriction {
		let attribute = sampleType.defaultDependentAttribute
		let restrictionType = DependencyInjector.get(AttributeRestrictionFactory.self).typesFor(attribute)[0]
		return DependencyInjector.get(AttributeRestrictionFactory.self).initialize(type: restrictionType, forAttribute: attribute)
	}

	private final func getPartFor(_ indexPath: IndexPath) -> BooleanExpressionPart? {
		// each section starts with a sample type cell
		if indexPath.row == 0 {
			return nil
		}
		return queries[indexPath.section].parts[indexPath.row - 1]
	}

	private final func validate() {
		finishedButton.isEnabled = buildQuery() != nil
	}

	// MARK: Reordering

	private final func movePart(from: IndexPath, to: IndexPath) {
		// each sections starts with sample type cell
		let fromRow = from.row - 1
		let toRow = to.row - 1

		let fromPart = queries[from.section].parts.remove(at: fromRow)
		if from.section == to.section {
			if fromRow > toRow {
				queries[to.section].parts.insert(fromPart, at: toRow)
			} else if from.row < to.row {
				// removing something from lower index changes target index
				queries[to.section].parts.insert(fromPart, at: toRow - 1)
			}
		} else {
			queries[to.section].parts.insert(fromPart, at: toRow)
		}
	}

	private final func ensureValidExpression(at indexPath: IndexPath) {
		guard let attributeRestriction = getPartFor(indexPath)?.expression as? AttributeRestriction else {
			log.error("Expected attribute restriction while ensuring valid expression")
			return
		}
		let sampleType = bottomMostSampleTypeAbove(indexPath)
		let attributeIndex = sampleType.attributes.firstIndex(where: {
			$0.equalTo(attributeRestriction.restrictedAttribute)
		})
		// only salvage the existing restrition if a matching attribute can be found
		if let attributeIndex = attributeIndex {
			attributeRestriction.restrictedAttribute = sampleType.attributes[attributeIndex]
			queries[indexPath.section].parts[indexPath.row - 1].expression = attributeRestriction
		} else {
			queries[indexPath.section].parts[indexPath.row - 1].expression = defaultAttributeRestriction(for: sampleType)
		}
	}

	// MARK: Populating the UI from a query

	private final func populateQuery(_ query: Query, _ matcher: SubQueryMatcher? = nil) {
		switch (query) {
			case is ActivityQuery: addQuerySampleType(Activity.self, matcher); break
			case is BloodPressureQuery: addQuerySampleType(BloodPressure.self, matcher); break
			case is BodyMassIndexQuery: addQuerySampleType(BodyMassIndex.self, matcher); break
			case is HeartRateQuery: addQuerySampleType(HeartRate.self, matcher); break
			case is LeanBodyMassQuery: addQuerySampleType(LeanBodyMass.self, matcher); break
			case is MedicationDoseQuery: addQuerySampleType(MedicationDose.self, matcher); break
			case is MoodQuery: addQuerySampleType(MoodImpl.self, matcher); break
			case is RestingHeartRateQuery: addQuerySampleType(RestingHeartRate.self, matcher); break
			case is SexualActivityQuery: addQuerySampleType(SexualActivity.self, matcher); break
			case is SleepQuery: addQuerySampleType(Sleep.self, matcher); break
			case is WeightQuery: addQuerySampleType(Weight.self, matcher); break
			default: log.error("Forgot query type: %@", String(describing: type(of: query)))
		}
		if let expression = query.expression {
			populateExpression(expression)
		}
		if let subQuery = query.subQuery {
			populateQuery(subQuery.query, subQuery.matcher)
		}
	}

	private final func populateExpression(_ expression: BooleanExpression) {
		if let and = expression as? AndExpression {
			populateExpression(and.expression1)
			queries[queries.count - 1].parts.append((type: .and, expression: nil))
			partWasAdded()
			populateExpression(and.expression2)
		} else if let or = expression as? OrExpression {
			populateExpression(or.expression1)
			queries[queries.count - 1].parts.append((type: .or, expression: nil))
			partWasAdded()
			populateExpression(or.expression2)
		} else if let group = expression as? BooleanExpressionGroup {
			queries[queries.count - 1].parts.append((type: .groupStart, expression: nil))
			partWasAdded()
			populateExpression(group.subExpression)
			queries[queries.count - 1].parts.append((type: .groupEnd, expression: nil))
			partWasAdded()
		} else if let attributeRestriction = expression as? AttributeRestriction {
			queries[queries.count - 1].parts.append((type: .expression, expression: attributeRestriction))
			partWasAdded()
		} else {
			log.error("Unknown expression type")
			showError(
				title: "You found a bug",
				message: "Please report that you found a bug with expression population.")
			return
		}
	}

	private final func addQuerySampleType(_ type: Sample.Type, _ matcher: SubQueryMatcher?) {
		if let matcher = matcher {
			queries.append((sampleTypeInfo: SampleTypeInfo(type, matcher), parts: []))
		} else {
			queries.append((sampleTypeInfo: SampleTypeInfo(type), parts: []))
		}
		partWasAdded()
	}

	// MARK: Building the query from the UI

	private final func buildQuery() -> Query? {
		var query: Query?
		for queryInfo in queries {
			do {
				let currentQuery = try getQueryFor(sampleType: queryInfo.sampleTypeInfo.sampleType, parts: queryInfo.parts)
				if let query = query {
					guard let matcher = queryInfo.sampleTypeInfo.matcher else {
						throw GenericError("No matcher")
					}
					query.subQuery = (matcher: matcher, query: currentQuery)
				} else {
					query = currentQuery
				}
			} catch {
				return nil
			}
		}
		return query
	}

	private final func getQueryFor(sampleType: Sample.Type, parts: [BooleanExpressionPart]) throws -> Query {
		switch (sampleType) {
			case is Activity.Type: return try DependencyInjector.get(QueryFactory.self).activityQuery(parts)
			case is BloodPressure.Type: return try DependencyInjector.get(QueryFactory.self).bloodPressureQuery(parts)
			case is BodyMassIndex.Type: return try DependencyInjector.get(QueryFactory.self).bmiQuery(parts)
			case is HeartRate.Type: return try DependencyInjector.get(QueryFactory.self).heartRateQuery(parts)
			case is LeanBodyMass.Type: return try DependencyInjector.get(QueryFactory.self).leanBodyMassQuery(parts)
			case is MedicationDose.Type: return try DependencyInjector.get(QueryFactory.self).medicationDoseQuery(parts)
			case is MoodImpl.Type: return try DependencyInjector.get(QueryFactory.self).moodQuery(parts)
			case is RestingHeartRate.Type: return try DependencyInjector.get(QueryFactory.self).restingHeartRateQuery(parts)
			case is SexualActivity.Type: return try DependencyInjector.get(QueryFactory.self).sexualActivityQuery(parts)
			case is Sleep.Type: return try DependencyInjector.get(QueryFactory.self).sleepQuery(parts)
			case is Weight.Type: return try DependencyInjector.get(QueryFactory.self).weightQuery(parts)
			default: throw GenericError("Unknown sample type: \(sampleType.name)")
		}
	}

	// MARK: Presented Controllers

	/// - Parameter indexPath:
	///     If provided, the presented options will modify the expression part at this index.
	///     Otherwise, they will add the associated type of expression part.
	private final func showExpressionParts(_ indexPath: IndexPath? = nil) {
		var title = "What would you like to add?"
		if indexPath != nil {
			title = "What would you like to change this to?"
		}
		let actionSheet = DependencyInjector.get(UiUtil.self).alert(title: title, message: nil, preferredStyle: .actionSheet)
		if indexPath == nil {
			actionSheet.addAction(UIAlertAction(title: "Data Type", style: .default) { _ in
				self.addSampleType()
			})
		}
		actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
			title: "Attribute Restriction",
			style: .default,
			handler: { _ in self.addOrUpdateAttributeRestrictionFor(indexPath) }))
		actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
			title: "And",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.and, indexPath)))
		actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
			title: "Or",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.or, indexPath)))
		actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
			title: "Condition Group Start",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.groupStart, indexPath)))
		actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(
			title: "Condition Group End",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.groupEnd, indexPath)))
		actionSheet.addAction(DependencyInjector.get(UiUtil.self).alertAction(title: "Cancel", style: .cancel, handler: nil))
		presentView(actionSheet)
	}

	private final func getAddOrEditExpressionPartHandlerFor(
		_ expressionType: BooleanExpressionType,
		_ indexPath: IndexPath?)
	-> ((UIAlertAction) -> Void) {
		return { _ in
			if let indexPath = indexPath {
				self.queries[indexPath.section].parts[indexPath.row - 1] = ((type: expressionType, expression: nil))
			} else {
				self.queries[self.queries.count - 1].parts.append((type: expressionType, expression: nil))
			}
			self.validate()
			self.tableView.reloadData()
		}
	}

	private final func addOrUpdateAttributeRestrictionFor(_ indexPath: IndexPath?) {
		if let indexPath = indexPath {
			let restriction = defaultAttributeRestriction(for: bottomMostSampleTypeAbove(indexPath))
			queries[indexPath.section].parts[indexPath.row - 1] = (type: .expression, expression: restriction)
		} else {
			let restriction = defaultAttributeRestriction(for: bottomMostSampleType())
			queries[queries.count - 1].parts.append((type: .expression, expression: restriction))
		}
		validate()
		tableView.reloadData()
	}

	// MARK: TableViewCell Creators

	private final func andCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = "and"
		return cell
	}

	private final func orCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = "or"
		return cell
	}

	private final func groupStartCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = "("
		return cell
	}

	private final func groupEndCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = ")"
		return cell
	}

	private final func getIndentationLevelFor(_ indexPath: IndexPath) -> Int {
		guard indexPath.row > 0 else { return 0 }
		let expressionParts = queries[indexPath.section].parts
		let targetIndex = indexPath.row - 1
		var indentation: Int = 1
		for i in 0 ..< targetIndex {
			let part = expressionParts[i]
			switch part.type {
				case .groupStart:
					indentation += 1
					break
				case .groupEnd:
					indentation -= 1
					break
				default: break
			}
		}
		let targetExpressionPart = expressionParts[targetIndex]
		if targetIndex > 1 && targetExpressionPart.type == .groupEnd {
			indentation -= 1
		}
		return max(indentation, 1)
	}
}
