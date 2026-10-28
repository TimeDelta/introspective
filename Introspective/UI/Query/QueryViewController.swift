//
//  QueryViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Instructions
import Presentr
import UIKit
#if canImport(FoundationModels)
import FoundationModels
#endif

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
		var sampleType: Sample.Type = injected(SampleFactory.self).allTypes()[0]
		var matcher: SubQueryMatcher? = SameDatesSubQueryMatcher()
		var mostRecentEntryOnly = false

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

	// MARK: Notification Names

	private static let acceptedAttributeRestrictionEdit = Notification.Name("acceptedAttributeRestrictionEdit")
	private static let acceptedSubSampleTypeEdit = Notification.Name("acceptedSubSampleTypeEdit")
	private let queryNameChosenNotification = Notification.Name("queryNameChosen.\(UUID().uuidString)")
	private var pendingSaveQuery: Query?

	// MARK: Presenters

	private static let editSampleTypePresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: Logging

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var addPartButton: UIBarButtonItem!
	@IBOutlet final var finishedButton: UIBarButtonItem!
	@IBOutlet final var editButton: UIBarButtonItem!
	@IBOutlet final var toolbar: UIToolbar!
	@IBOutlet final var saveButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var finishedButtonTitle: String = "Run"
	/// Corresponding notification object will contain the built query as the object
	public final var finishedButtonNotification: NotificationName = .runQuery
	/// Setting this will prevent the topmost sample type from being changed by the user
	public final var topmostSampleType: Sample.Type?
	public final var initialQuery: Query?

	// leave non-private for testing purposes
	final var queries = [(sampleTypeInfo: SampleTypeInfo, parts: [BooleanExpressionPart])]()
	private var loadedSavedQuery: StoredQuery?
	private final var editedSampleTypeSectionIndex: Int!
	private final var editedAttributeRestrictionIndex: IndexPath!

	/// Have to maintain a strong reference to this or instructions won't show
	private final var coachMarksController = injected(CoachMarkFactory.self).controller()
	private final var coachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate!

	// MARK: - UIViewController Overloads

	public final override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Describe Query", style: .plain, target: self, action: #selector(describeQuery))

		editButton.target = self
		editButton.action = #selector(editButtonPressed)

		finishedButton.title = finishedButtonTitle

		if let query = initialQuery {
			populateQuery(query)
		} else if let topmostSampleType = topmostSampleType {
			queries = [(sampleTypeInfo: SampleTypeInfo(topmostSampleType), parts: [])]
			partWasAdded()
		} else if queries.isEmpty { // add this condition for testing purposes
			queries = [(sampleTypeInfo: SampleTypeInfo(), parts: [])]
			partWasAdded()
		}

		observe(selector: #selector(saveEditedSubQuerySampleType), name: Me.acceptedSubSampleTypeEdit)
		observe(selector: #selector(saveEditedSampleType), name: .sampleTypeEdited)
		observe(selector: #selector(saveEditedAttributeRestriction), name: .attributeRestrictionEdited)
		observe(selector: #selector(queryNameChosen), name: queryNameChosenNotification)

		addPartButton?.target = self
		addPartButton?.action = #selector(addPartButtonWasPressed)

		coachMarksDataSourceAndDelegate = QueryViewControllerCoachMarksDataSourceAndDelegate(self)
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = DefaultCoachMarksDataSourceAndDelegate.defaultSkipInstructionsView()
	}

	public final override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !injected(UserDefaultsUtil.self).bool(forKey: .queryViewInstructionsShown) {
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

	public final override func numberOfSections(in _: UITableView) -> Int {
		queries.count
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		queries[section].parts.count + 1 // need to add 1 for the sample type cell
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
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
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "Sub Data Type",
				for: indexPath
			) as! SubSampleTypeTableViewCell
			cell.matcher = query.sampleTypeInfo.matcher
			cell.sampleType = query.sampleTypeInfo.sampleType
			return cell
		}

		let part = query.parts[indexPath.row - 1]
		switch part.type {
		case .expression:
			if let attributeRestriction = part.expression as? AttributeRestriction {
				let cell = tableView.dequeueReusableCell(
					withIdentifier: "Attribute Restriction",
					for: indexPath
				) as! AttributeRestrictionTableViewCell
				cell.attributeRestriction = attributeRestriction
				cell.indentationLevel = getIndentationLevelFor(indexPath)
				return cell
			}
			Me.log.error("Unknown expression type in query")
			break
		case .and: return andCell(for: indexPath)
		case .or: return orCell(for: indexPath)
		case .groupStart: return groupStartCell(for: indexPath)
		case .groupEnd: return groupEndCell(for: indexPath)
		case .not: return notCell(for: indexPath)
		}
		Me.log.error("Forgot a type of cell: %@", String(describing: part))
		return UITableViewCell()
	}

	// MARK: - Table View Delegate

	public final override func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		indexPath.section != 0 || indexPath.row != 0
	}

	public final override func tableView(_: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		indexPath.section != 0 || indexPath.row != 0
	}

	public final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		if let fromPart = getPartFor(fromIndexPath) {
			guard to.section != 0 || to.row != 0 else {
				Me.log.debug("User tried to move non-data-type query part to top row of query")
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

	public final override func tableView(
		_ tableView: UITableView,
		editActionsForRowAt indexPath: IndexPath
	) -> [UITableViewRowAction]? {
		guard indexPath.section > 0 || indexPath.row > 0 else { return nil }
		let delete = injected(UiUtil.self)
			.tableViewRowAction(style: .destructive, title: "🗑️") { _, indexPath in
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
			let controller = viewController(
				named: "chooseSampleType",
				fromStoryboard: "Util"
			) as! ChooseSampleTypeViewController
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

	@IBAction final func infoButtonPressed(_: Any) {
		coachMarksController.start(in: .window(over: self))
	}

	@IBAction final func finishedButtonPressed(_: Any) {
		guard let query = buildQuery() else {
			Me.log.error("buildQuery() returned nil")
			showError(title: "Failed to build query")
			return
		}
		if finishedButtonNotification != .runQuery {
			syncPost(
				finishedButtonNotification,
				userInfo: [
					.query: query,
				]
			)
			popFromNavigationController()
		} else {
			showResults(for: query)
		}
	}

	private func showResults(for query: Query) {
		let controller = viewController(named: "results", fromStoryboard: "Results") as! ResultsViewController
		controller.query = query
		pushToNavigationController(controller)
		query.runQuery { [weak controller] (result: QueryResult?, error: Error?) in
			DispatchQueue.main.async {
				if let error = error { controller?.showError(title: "Failed to run query", error: error) }
				else { controller?.samples = result?.samples }
			}
		}
	}

	@objc private func describeQuery() {
#if canImport(FoundationModels)
		if #available(iOS 26.0, *) {
			guard case .available = SystemLanguageModel.default.availability else {
				showError(title: "On-device model unavailable", message: "This feature requires an available Apple Intelligence language model. Use the query builder on other devices. No cloud fallback is used.")
				return
			}
			let alert = UIAlertController(title: "Describe a query", message: "Processed on this device. The generated draft will open for review; it will not run automatically. Supported: data type, past days, rating bounds, note text, minimum duration, active energy, and most recent only.", preferredStyle: .alert)
			alert.addTextField { field in
				field.placeholder = "Moods rated at least 4 in the past 7 days"
				field.autocorrectionType = .no; field.spellCheckingType = .no
			}
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			alert.addAction(UIAlertAction(title: "Create draft", style: .default) { [weak self, weak alert] _ in
				guard let text = alert?.textFields?.first?.text, !text.isEmpty, text.count <= 2000 else { return }
				self?.generateDraft(text)
			})
			present(alert, animated: true)
			return
		}
#endif
		showError(title: "On-device generation requires iOS 26", message: "Use the query builder on this device. No query text is sent to an online service.")
	}
#if canImport(FoundationModels)
	@available(iOS 26.0, *)
	private func generateDraft(_ text: String) {
		navigationItem.rightBarButtonItem?.isEnabled = false
		navigationItem.prompt = "Creating on-device draft…"
		view.isUserInteractionEnabled = false
		Task { @MainActor [weak self] in
			do {
				let session = LanguageModelSession(instructions: "Convert the user's request to a draft query. Supported dataType values: mood, pain, fatigue, activity, workout, activeEnergy, lostItem. Only AND conditions are supported. days means relative past days. Rating limits and minimum duration/energy are inclusive. Note text is literal. Do not approximate unsupported requests, OR, negation, comparisons, subqueries, or exact calendar ranges; set canRepresent=false. Use nil for unspecified optional conditions. No medical interpretation. Never execute anything.")
				let response = try await session.respond(to: text, generating: GeneratedQueryDraft.self)
				let draft = response.content
				guard draft.canRepresent else { throw GenericDisplayableError(title: "Use the builder for this query", description: "The requested conditions cannot all be represented by this experimental draft generator.") }
				let resolved = try OnDeviceQueryPlan(dataType: draft.dataType, days: draft.days, minimumRating: draft.minimumRating,
					maximumRating: draft.maximumRating, noteContains: draft.noteContains, minimumDurationMinutes: draft.minimumDurationMinutes,
					minimumEnergyKcal: draft.minimumEnergyKcal, mostRecentOnly: draft.mostRecentOnly).resolve()
				guard let self = self else { return }
				if let required = self.topmostSampleType, required != resolved.sampleType { throw GenericDisplayableError(title: "This editor requires a different data type.") }
				let query = try injected(QueryFactory.self).queryFor(resolved.sampleType)
				query.expression = resolved.expression; query.mostRecentEntryOnly = resolved.mostRecentOnly
				if let expression = query.expression { _ = try expression.partsForEditing() }
				self.loadedSavedQuery = nil
				self.queries = []; self.populateQuery(query); self.tableView.reloadData(); self.validate()
				self.navigationItem.prompt = "Review every condition before running"
			} catch {
				self?.navigationItem.prompt = nil
				self?.showError(title: "Could not create draft", message: "The request was not applied. Try the query builder or a simpler description.")
			}
			self?.navigationItem.rightBarButtonItem?.isEnabled = true
			self?.view.isUserInteractionEnabled = true
		}
	}
#endif

	@IBAction final func loadButtonPressed(_: Any) {
		var run: ((StoredQuery) -> Void)?
		if finishedButtonNotification == .runQuery {
			run = { [weak self] stored in
				do { self?.showResults(for: try stored.convert()) }
				catch { self?.showError(title: "Failed to run saved query", error: error) }
			}
		}
		let controller = SavedQueriesViewController(requiredSampleType: topmostSampleType, run: run) { [weak self] stored in
			do { try self?.load(stored) }
			catch { self?.showError(title: "Failed to load query", error: error) }
		}
		pushToNavigationController(controller)
	}

	private func load(_ query: StoredQuery) throws {
		let restored = try query.convert()
		var current: Query? = restored
		while let node = current {
			if let expression = node.expression { _ = try expression.partsForEditing() }
			current = node.subQuery?.query
		}
		loadedSavedQuery = query
		queries = []
		populateQuery(restored)
		tableView.reloadData()
		validate()
	}

	@IBAction final func saveButtonPressed(_: Any) {
		guard let query = buildQuery() else { showError(title: "Failed to build query"); return }
		pendingSaveQuery = query
		guard let saved = loadedSavedQuery, !saved.isDeleted else { showQueryNamePicker(); return }
		let alert = UIAlertController(title: "Save query", message: saved.name, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Update saved query", style: .default) { [weak self, weak alert] _ in
			alert?.dismiss(animated: false) {
				do {
					try injected(StoredQueriesDAO.self).update(saved, with: query)
					self?.navigationItem.prompt = "Query saved"
				} catch { self?.showError(title: "Could not update query", error: error) }
			}
		})
		alert.addAction(UIAlertAction(title: "Save as new query", style: .default) { [weak self, weak alert] _ in
			alert?.dismiss(animated: false) { self?.showQueryNamePicker() }
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alert, animated: true)
	}

	private func showQueryNamePicker() {
		let controller: QueryNameViewController = viewController(named: "queryName")
		controller.notificationToSendOnSave = queryNameChosenNotification
		customPresentViewController(QueryNameViewController.presenter, viewController: controller, animated: false)
	}

	@objc private final func queryNameChosen(notification: Notification) {
		if let name: String = value(for: .text, from: notification), let query = pendingSaveQuery {
			do {
				try injected(StoredQueriesDAO.self).save(query, name: name)
				loadedSavedQuery = try? injected(StoredQueriesDAO.self).getQueryWith(name: name)
				pendingSaveQuery = nil
				navigationItem.prompt = "Query saved"
			} catch {
				showError(
					title: "Failed to save query",
					error: error,
					tryAgain: { self.queryNameChosen(notification: notification) }
				)
			}
		}
	}

	@objc private final func addPartButtonWasPressed() {
		showExpressionParts()
	}

	@objc private final func editButtonPressed() {
		editButton.title = isEditing ? "Edit" : "Done"
		_ = editButtonItem.target?.perform(editButtonItem.action)
	}

	// MARK: - Navigation

	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditAttributeRestrictionViewController {
			let controller = segue.destination as! EditAttributeRestrictionViewController
			let source = sender as! UITableViewCell
			editedAttributeRestrictionIndex = tableView.indexPath(for: source)
			controller.sampleType = queries[editedAttributeRestrictionIndex.section].sampleTypeInfo.sampleType
			guard let attributeRestriction = getPartFor(editedAttributeRestrictionIndex)?
				.expression as? AttributeRestriction else {
				Me.log.error("Expected attribute restriction for segue but did not get one")
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
		var updated = SampleTypeInfo(sampleType!)
		updated.mostRecentEntryOnly = queries[editedSampleTypeSectionIndex].sampleTypeInfo.mostRecentEntryOnly
		queries[editedSampleTypeSectionIndex].sampleTypeInfo = updated
		updateAttributeRestrictionsForSampleType(at: editedSampleTypeSectionIndex)
		validate()
		tableView.reloadData()
	}

	@objc final func saveEditedAttributeRestriction(notification: Notification) {
		if let attributeRestriction: AttributeRestriction? = value(for: .attributeRestriction, from: notification) {
			guard let index = editedAttributeRestrictionIndex else {
				Me.log.error("editedAttributeRestrictionIndex was nil")
				return
			}
			queries[index.section].parts[index.row - 1].expression = attributeRestriction
			validate()
			tableView.reloadData()
		}
	}

	@objc final func saveEditedSubQuerySampleType(notification: Notification) {
		guard let sampleTypeInfo: SampleTypeInfo = value(for: .sampleType, from: notification) else { return }
		var updated = sampleTypeInfo
		updated.mostRecentEntryOnly = queries[editedSampleTypeSectionIndex].sampleTypeInfo.mostRecentEntryOnly
		queries[editedSampleTypeSectionIndex].sampleTypeInfo = updated
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
			if var attributeRestriction = queries[sampleTypeIndex].parts[i].expression as? AttributeRestriction {
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
		queries.last!.sampleTypeInfo.sampleType
	}

	private final func bottomMostSampleTypeAbove(_ indexPath: IndexPath) -> Sample.Type {
		queries[indexPath.section].sampleTypeInfo.sampleType
	}

	final fileprivate func partWasAdded() {
		if queries.count > 1 || !queries[0].parts.isEmpty {
			tableView.reloadData()
		}
		validate()
	}

	private final func defaultAttributeRestriction(for sampleType: Sample.Type) -> AttributeRestriction {
		let attribute = sampleType.defaultIndependentAttribute
		let restrictionType = injected(AttributeRestrictionFactory.self).typesFor(attribute)[0]
		return injected(AttributeRestrictionFactory.self)
			.initialize(type: restrictionType, forAttribute: attribute)
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
		saveButton?.isEnabled = finishedButton.isEnabled
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
		guard var attributeRestriction = getPartFor(indexPath)?.expression as? AttributeRestriction else {
			Me.log.error("Expected attribute restriction while ensuring valid expression")
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
			queries[indexPath.section].parts[indexPath.row - 1]
				.expression = defaultAttributeRestriction(for: sampleType)
		}
	}

	// MARK: Populating the UI from a query

	private final func populateQuery(_ query: Query, _ matcher: SubQueryMatcher? = nil) {
		switch query {
		case is ActivityQuery: addQuerySampleType(Activity.self, matcher); break
		case is BloodPressureQuery: addQuerySampleType(BloodPressure.self, matcher); break
		case is BodyMassIndexQuery: addQuerySampleType(BodyMassIndex.self, matcher); break
		case is DietarySugarQuery: addQuerySampleType(DietarySugar.self, matcher); break
		case is FatigueQuery: addQuerySampleType(FatigueImpl.self, matcher); break
		case is HeartRateQuery: addQuerySampleType(HeartRate.self, matcher); break
		case is LeanBodyMassQuery: addQuerySampleType(LeanBodyMass.self, matcher); break
		case is MedicationDoseQuery: addQuerySampleType(MedicationDose.self, matcher); break
		case is MoodQuery: addQuerySampleType(MoodImpl.self, matcher); break
		case is PainQuery: addQuerySampleType(PainImpl.self, matcher); break
		case is RestingHeartRateQuery: addQuerySampleType(RestingHeartRate.self, matcher); break
		case is SexualActivityQuery: addQuerySampleType(SexualActivity.self, matcher); break
		case is SleepQuery: addQuerySampleType(Sleep.self, matcher); break
		case is StepsQuery: addQuerySampleType(Steps.self, matcher); break
		case is WeightQuery: addQuerySampleType(Weight.self, matcher); break
		default: Me.log.error("Forgot query type: %@", String(describing: type(of: query)))
		}
		queries[queries.count - 1].sampleTypeInfo.mostRecentEntryOnly = query.mostRecentEntryOnly
		if let expression = query.expression {
			populateExpression(expression)
		}
		if let subQuery = query.subQuery {
			populateQuery(subQuery.query, subQuery.matcher)
		}
	}

	private final func populateExpression(_ expression: BooleanExpression) {
		do {
			queries[queries.count - 1].parts.append(contentsOf: try expression.partsForEditing())
			partWasAdded()
		} catch { showError(title: "Could not restore query expression", error: error) }
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
		var tail: Query?
		for queryInfo in queries {
			do {
				let currentQuery = try getQueryFor(
					sampleType: queryInfo.sampleTypeInfo.sampleType,
					parts: queryInfo.parts
				)
				currentQuery.mostRecentEntryOnly = queryInfo.sampleTypeInfo.mostRecentEntryOnly
				if let tail = tail {
					guard let matcher = queryInfo.sampleTypeInfo.matcher else {
						throw GenericError("No matcher")
					}
					tail.subQuery = (matcher: matcher, query: currentQuery)
				} else {
					query = currentQuery
				}
				tail = currentQuery
			} catch {
				return nil
			}
		}
		return query
	}

	private final func getQueryFor(sampleType: Sample.Type, parts: [BooleanExpressionPart]) throws -> Query {
		switch sampleType {
		case is Activity.Type: return try injected(QueryFactory.self).activityQuery(parts)
		case is BloodPressure.Type: return try injected(QueryFactory.self).bloodPressureQuery(parts)
		case is BodyMassIndex.Type: return try injected(QueryFactory.self).bmiQuery(parts)
		case is DietarySugar.Type: return try injected(QueryFactory.self).dietarySugarQuery(parts)
		case is Fatigue.Type: return try injected(QueryFactory.self).fatigueQuery(parts)
		case is HeartRate.Type: return try injected(QueryFactory.self).heartRateQuery(parts)
		case is LeanBodyMass.Type: return try injected(QueryFactory.self).leanBodyMassQuery(parts)
		case is MedicationDose.Type: return try injected(QueryFactory.self).medicationDoseQuery(parts)
		case is MoodImpl.Type: return try injected(QueryFactory.self).moodQuery(parts)
		case is PainImpl.Type: return try injected(QueryFactory.self).painQuery(parts)
		case is RestingHeartRate.Type: return try injected(QueryFactory.self).restingHeartRateQuery(parts)
		case is SexualActivity.Type: return try injected(QueryFactory.self).sexualActivityQuery(parts)
		case is Sleep.Type: return try injected(QueryFactory.self).sleepQuery(parts)
		case is Steps.Type: return try injected(QueryFactory.self).stepsQuery(parts)
		case is Weight.Type: return try injected(QueryFactory.self).weightQuery(parts)
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
		let actionSheet = injected(UiUtil.self).alert(title: title, message: nil, preferredStyle: .actionSheet)
		if indexPath == nil {
			actionSheet.addAction(UIAlertAction(title: "Data Type", style: .default) { _ in
				self.addSampleType()
			})
		}
		actionSheet.addAction(injected(UiUtil.self).alertAction(
			title: "Attribute Restriction",
			style: .default,
			handler: { _ in
				self.addOrUpdateAttributeRestrictionFor(indexPath)
			}
		))
		actionSheet.addAction(injected(UiUtil.self).alertAction(
			title: "And",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.and, indexPath)
		))
		actionSheet.addAction(injected(UiUtil.self).alertAction(
			title: "Or",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.or, indexPath)
		))
		actionSheet.addAction(injected(UiUtil.self).alertAction(
			title: "Not",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.not, indexPath)
		))
		actionSheet.addAction(injected(UiUtil.self).alertAction(
			title: "Condition Group Start",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.groupStart, indexPath)
		))
		actionSheet.addAction(injected(UiUtil.self).alertAction(
			title: "Condition Group End",
			style: .default,
			handler: getAddOrEditExpressionPartHandlerFor(.groupEnd, indexPath)
		))
		actionSheet
			.addAction(injected(UiUtil.self).alertAction(title: "Cancel", style: .cancel, handler: nil))
		presentView(actionSheet)
	}

	private final func getAddOrEditExpressionPartHandlerFor(
		_ expressionType: BooleanExpressionType,
		_ indexPath: IndexPath?
	) -> ((UIAlertAction) -> Void) {
		return { _ in
			if let indexPath = indexPath {
				self.queries[indexPath.section].parts[indexPath.row - 1] = (type: expressionType, expression: nil)
			} else {
				self.queries[self.queries.count - 1].parts.append((type: expressionType, expression: nil))
			}
			self.validate()
			self.tableView.reloadData()
		}
	}

	final fileprivate func addOrUpdateAttributeRestrictionFor(_ indexPath: IndexPath?) {
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

	private final func notCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
		cell.indentationLevel = getIndentationLevelFor(indexPath)
		cell.textLabel?.text = "not"
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

// MARK: - Instructions

/// This class is used to break retain cycles between `QueryViewController` and the closures used by `CoachMarkInfo`, preventing them from causing memory leaks
final fileprivate class QueryViewControllerCoachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate {
	private typealias Super = DefaultCoachMarksDataSourceAndDelegate
	private typealias ControllerClass = QueryViewControllerImpl

	private weak final var controller: QueryViewControllerImpl?

	private final var addedRestrictionForInstructions = false
	private final var addedSubQueryForInstructions = false

	private lazy final var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "This is the main data type. It determines what type of data will be returned by this query. Tap it to change the main data type.",
			useArrow: true,
			view: { self.controller?.tableView.visibleCells[0] }
		),
		CoachMarkInfo(
			hint: "Press the + button to add more parts to the query.",
			useArrow: false,
			view: { self.controller?.toolbar }
		),
		CoachMarkInfo(
			hint: "This is an attribute restriction. It allows you to restrict which samples are returned based on their attributes. Tap it to edit.",
			useArrow: false,
			view: {
				guard let controller = self.controller else { return nil }

				var attributeRestrictionIndexPath = IndexPath(row: 1, section: 0)
				for section in 0 ..< controller.queries.count {
					for row in 0 ..< controller.queries[section].parts.count {
						if self.controller?.queries[section].parts[row].type == .expression {
							attributeRestrictionIndexPath = IndexPath(row: row, section: section)
							break
						}
					}
				}
				self.controller?.tableView.scrollToRow(at: attributeRestrictionIndexPath, at: .bottom, animated: true)
				return self.controller?.tableView.visibleCells.last!
			},
			setup: {
				guard let controller = self.controller else { return }

				var hasAttributeRestriction = false
				for query in controller.queries {
					for part in query.parts {
						if part.type == .expression {
							hasAttributeRestriction = true
							break
						}
					}
				}
				if !hasAttributeRestriction {
					controller.addOrUpdateAttributeRestrictionFor(nil)
					self.addedRestrictionForInstructions = true
				}
			}
		),
		CoachMarkInfo(
			hint: "This is the start of a subquery. It allows you to restrict what samples are returned based on other types of data. Tap it to edit.",
			useArrow: false,
			view: {
				self.controller?.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
				return self.controller?.tableView.visibleCells[0]
			},
			setup: {
				guard let controller = self.controller else { return }

				if controller.queries.count < 2 {
					let subQuerySampleType = injected(SampleFactory.self).allTypes()[1]
					controller.queries.append((
						sampleTypeInfo: ControllerClass.SampleTypeInfo(subQuerySampleType),
						parts: []
					))
					controller.partWasAdded()
					self.addedSubQueryForInstructions = true
				}
			}
		),
		CoachMarkInfo(
			hint: "Swipe left on any part of the query (except the main data type) to reveal a button that will remove that part of the query.",
			useArrow: true,
			view: { self.controller?.tableView.visibleCells[2] }
		),
	]

	private lazy var delegate: DefaultCoachMarksDataSourceAndDelegate = {
		DefaultCoachMarksDataSourceAndDelegate(
			self.coachMarksInfo,
			instructionsShownKey: .queryViewInstructionsShown,
			cleanup: {
				guard let controller = self.controller else { return }

				if self.addedSubQueryForInstructions {
					_ = controller.queries.popLast()
				}
				if self.addedRestrictionForInstructions {
					_ = controller.queries[controller.queries.count - 1].parts.popLast()
				}
				if self.addedSubQueryForInstructions || self.addedRestrictionForInstructions {
					controller.tableView.reloadData()
				}
				self.addedRestrictionForInstructions = false
				self.addedSubQueryForInstructions = false
			},
			skipViewLayoutConstraints: Super.defaultCoachMarkSkipViewConstraints()
		)
	}()

	public init(_ controller: QueryViewControllerImpl) {
		self.controller = controller
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		coachMarkViewsAt index: Int,
		madeFrom coachMark: CoachMark
	) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
		delegate.coachMarksController(coachMarksController, coachMarkViewsAt: index, madeFrom: coachMark)
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		coachMarkAt index: Int
	) -> CoachMark {
		delegate.coachMarksController(coachMarksController, coachMarkAt: index)
	}

	public final func numberOfCoachMarks(for controller: CoachMarksController) -> Int {
		delegate.numberOfCoachMarks(for: controller)
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		constraintsForSkipView skipView: UIView,
		inParent parentView: UIView
	) -> [NSLayoutConstraint]? {
		delegate.coachMarksController(coachMarksController, constraintsForSkipView: skipView, inParent: parentView)
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		didEndShowingBySkipping skipped: Bool
	) {
		delegate.coachMarksController(coachMarksController, didEndShowingBySkipping: skipped)
	}
}

/// Saved query management uses live fetches so renamed/deleted records never leave stale rows.
private final class SavedQueriesViewController: UITableViewController, UISearchResultsUpdating {
	private var saved: [StoredQuery] = []
	private var displayed: [StoredQuery] = []
	private let search = UISearchController(searchResultsController: nil)
	private let run: ((StoredQuery) -> Void)?
	private let requiredSampleType: Sample.Type?
	private let selected: (StoredQuery) -> Void

	init(requiredSampleType: Sample.Type?, run: ((StoredQuery) -> Void)?, selected: @escaping (StoredQuery) -> Void) {
		self.run = run
		self.requiredSampleType = requiredSampleType
		self.selected = selected
		super.init(style: .plain)
	}

	required init?(coder: NSCoder) { fatalError("Use init(requiredSampleType:selected:)") }

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Saved Queries"
		tableView.accessibilityIdentifier = "savedQueries"
		search.searchResultsUpdater = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Search names and data types"
		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
		reloadQueries()
	}

	private func reloadQueries() {
		do {
			saved = try injected(StoredQueriesDAO.self).getAllQueries()
			if let type = requiredSampleType {
				let id = injected(SampleFactory.self).sampleTypeId(for: type)
				saved = saved.filter { $0.sampleTypeId == id }
			}
			updateSearchResults(for: search)
		} catch { showError(title: "Failed to fetch saved queries", error: error) }
	}

	func updateSearchResults(for searchController: UISearchController) {
		displayed = saved.filter { $0.matchesSearchText(searchController.searchBar.text ?? "") }
		let label = UILabel()
		label.text = saved.isEmpty ? "No saved queries. Save a query from the query builder." : "No matching saved queries."
		label.numberOfLines = 0
		label.textAlignment = .center
		tableView.backgroundView = displayed.isEmpty ? label : nil
		tableView.reloadData()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { displayed.count }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		let query = displayed[indexPath.row]
		cell.textLabel?.text = query.name
		let factory = injected(SampleFactory.self)
		cell.detailTextLabel?.text = factory.allTypes().first(where: { factory.sampleTypeId(for: $0) == query.sampleTypeId })?.name
		cell.accessoryType = .disclosureIndicator
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let query = displayed[indexPath.row]
		navigationController?.popViewController(animated: false)
		selected(query)
	}

	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard let run = run else { return nil }
		let query = displayed[indexPath.row]
		let action = UIContextualAction(style: .normal, title: "Run") { [weak self] _, _, completion in
			completion(true)
			self?.navigationController?.popViewController(animated: false)
			run(query)
		}
		action.backgroundColor = .systemBlue
		let configuration = UISwipeActionsConfiguration(actions: [action])
		configuration.performsFirstActionWithFullSwipe = false
		return configuration
	}

	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let query = displayed[indexPath.row]
		let rename = UIContextualAction(style: .normal, title: "Rename") { [weak self] _, _, completion in
			completion(true)
			self?.rename(query)
		}
		let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
			completion(true)
			self?.confirmDelete(query)
		}
		let configuration = UISwipeActionsConfiguration(actions: [delete, rename])
		configuration.performsFirstActionWithFullSwipe = false
		return configuration
	}

	private func rename(_ query: StoredQuery) {
		let alert = UIAlertController(title: "Rename query", message: nil, preferredStyle: .alert)
		alert.addTextField { $0.text = query.name }
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
			alert?.dismiss(animated: false) {
			do {
				try injected(StoredQueriesDAO.self).rename(query, to: alert?.textFields?.first?.text ?? "")
				self?.reloadQueries()
			} catch { self?.showError(title: "Could not rename query", error: error) }
			}
		})
		present(alert, animated: true)
	}

	private func confirmDelete(_ query: StoredQuery) {
		let alert = UIAlertController(title: "Delete saved query?", message: query.name, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self, weak alert] _ in
			alert?.dismiss(animated: false) {
			do {
				try injected(StoredQueriesDAO.self).delete(query)
				self?.reloadQueries()
			} catch { self?.showError(title: "Could not delete query", error: error) }
			}
		})
		present(alert, animated: true)
	}
}

#if canImport(FoundationModels)
@available(iOS 26.0, *)
@Generable
private struct GeneratedQueryDraft {
	var canRepresent: Bool
	var dataType: String
	var days: Int?
	var minimumRating: Double?
	var maximumRating: Double?
	var noteContains: String?
	var minimumDurationMinutes: Double?
	var minimumEnergyKcal: Double?
	var mostRecentOnly: Bool
}
#endif
