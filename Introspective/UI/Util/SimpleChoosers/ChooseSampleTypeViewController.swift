//
//  ChooseSampleTypeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

protocol ChooseSampleTypeViewController: UIViewController {
	var selectedSampleType: Sample.Type? { get set }
	var notificationToSendOnAccept: NotificationName! { get set }
}

final class ChooseSampleTypeViewControllerImpl: UIViewController, ChooseSampleTypeViewController {
	// MARK: - Static Variables

	private typealias Me = ChooseSampleTypeViewControllerImpl

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var sampleTypePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var selectedSampleType: Sample.Type?
	public final var notificationToSendOnAccept: NotificationName!
	private var typeSnapshot: [Sample.Type]?
	private weak var acceptButton: UIButton?
	private let searchButton = UIButton(type: .system)
	private var availableSampleTypes: [Sample.Type] {
		if let snapshot = typeSnapshot { return snapshot }
		let snapshot = injected(SampleFactory.self).allTypes()
		typeSnapshot = snapshot
		return snapshot
	}
	private lazy var searchModel = SampleTypeSearchModel(types: availableSampleTypes)

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		// A catalog can contain hundreds of types. Keep one availability snapshot
		// for the wheel, search results and final selection throughout this choice.
		_ = availableSampleTypes
		sampleTypePicker.dataSource = self
		sampleTypePicker.delegate = self
		acceptButton = view.subviews.compactMap { $0 as? UIButton }.first {
			$0.accessibilityIdentifier == "save button"
		}
		acceptButton?.isEnabled = !availableSampleTypes.isEmpty
		searchButton.setTitle("Search", for: .normal)
		searchButton.accessibilityIdentifier = "search data types"
		searchButton.accessibilityLabel = "Search data types"
		searchButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
		searchButton.titleLabel?.adjustsFontForContentSizeCategory = true
		searchButton.titleLabel?.adjustsFontSizeToFitWidth = true
		searchButton.titleLabel?.minimumScaleFactor = 0.5
		searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
		searchButton.isEnabled = !availableSampleTypes.isEmpty
		view.addSubview(searchButton)
		if selectedSampleType == nil { selectedSampleType = availableSampleTypes.first }
		if selectedSampleType != nil {
			if let selectedIndex = availableSampleTypes
				.firstIndex(where: { $0 == selectedSampleType }) {
				sampleTypePicker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				Me.log.error("Could not find index for specified type")
			}
		}
	}

	final override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let width = view.bounds.width
		let footerY = max(0, view.bounds.height - view.safeAreaInsets.bottom - 45)
		sampleTypePicker.frame = CGRect(x: 0, y: 0, width: width, height: max(0, footerY - 8))
		let buttonWidth = max(0, (width - 8) / 2)
		searchButton.frame = CGRect(x: 0, y: footerY, width: buttonWidth, height: 45)
		acceptButton?.frame = CGRect(x: buttonWidth + 8, y: footerY, width: buttonWidth, height: 45)
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_: Any) {
		let selectedIndex = sampleTypePicker.selectedRow(inComponent: 0)
		guard availableSampleTypes.indices.contains(selectedIndex) else { return }
		let selectedSampleType = availableSampleTypes[selectedIndex]
		self.selectedSampleType = selectedSampleType
		syncPost(
			notificationToSendOnAccept,
			userInfo: [
				.sampleType: selectedSampleType,
			]
		)
		dismiss(animated: false, completion: nil)
	}

	@objc private func showSearch() {
		let navigation = UINavigationController(rootViewController: makeSearchController())
		navigation.modalPresentationStyle = .pageSheet
		navigation.sheetPresentationController?.detents = [.large()]
		present(navigation, animated: true)
	}

	func makeSearchController() -> SampleTypeSearchViewController {
		SampleTypeSearchViewController(model: searchModel, selectedType: selectedSampleType) { [weak self] type in
			guard let self = self, let index = self.availableSampleTypes.firstIndex(where: { $0 == type }) else { return }
			self.selectedSampleType = type
			self.sampleTypePicker.selectRow(index, inComponent: 0, animated: false)
		}
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseSampleTypeViewControllerImpl: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		availableSampleTypes.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseSampleTypeViewControllerImpl: UIPickerViewDelegate {
	public final func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		guard searchModel.items.indices.contains(row) else { return nil }
		return searchModel.items[row].title
	}

	public final func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		guard availableSampleTypes.indices.contains(row) else { return }
		selectedSampleType = availableSampleTypes[row]
	}
}

/// Search changes presentation order only. Every item retains its original
/// metatype and wheel index, so display names never become saved-query IDs.
struct SampleTypeSearchModel {
	struct Item {
		let sampleType: Sample.Type
		let title: String
		let group: String
		let originalIndex: Int
		let searchText: String
	}
	struct Section {
		let title: String
		let items: [Item]
	}
	let items: [Item]

	init(types: [Sample.Type], descriptor: (Sample.Type) -> HealthTypeDescriptor? = { HealthCatalog.descriptor(for: $0) }) {
		items = types.enumerated().map { index, type in
			let entry = descriptor(type)
			// Keep the existing wheel labels for IDs 0...20. Catalog display names
			// preserve medical capitalization such as HbA1c and VO2 Max.
			let title: String
			if let entry = entry, entry.id > 20 {
				title = entry.name
			} else {
				title = type.name.localizedCapitalized
			}
			let group = entry?.group ?? ((type as? HealthKitSample.Type) == nil ? "Introspective" : "Apple Health")
			let searchText = [title, type.name, group, entry?.name ?? "", entry?.identifier ?? ""].joined(separator: " ")
			return Item(sampleType: type, title: title, group: group, originalIndex: index, searchText: searchText)
		}
	}

	func sections(matching query: String) -> [Section] {
		let terms = query.split(whereSeparator: { $0.isWhitespace }).map(String.init)
		let matches = items.filter { item in
			terms.allSatisfy { term in
				item.searchText.range(of: term, options: [.caseInsensitive, .diacriticInsensitive]) != nil
			}
		}
		let groups = Dictionary(grouping: matches, by: { $0.group })
		return groups.keys.sorted { $0.localizedStandardCompare($1) == .orderedAscending }.map { group in
			let ordered = groups[group]!.sorted { left, right in
				let comparison = left.title.localizedStandardCompare(right.title)
				return comparison == .orderedSame ? left.originalIndex < right.originalIndex : comparison == .orderedAscending
			}
			return Section(title: group, items: ordered)
		}
	}
}

final class SampleTypeSearchViewController: UITableViewController, UISearchResultsUpdating {
	let model: SampleTypeSearchModel
	private(set) var sections: [SampleTypeSearchModel.Section]
	private let selectedType: Sample.Type?
	private var onSelection: ((Sample.Type) -> Void)?
	private let search = UISearchController(searchResultsController: nil)

	init(model: SampleTypeSearchModel, selectedType: Sample.Type?, onSelection: @escaping (Sample.Type) -> Void) {
		self.model = model; self.selectedType = selectedType; self.onSelection = onSelection
		sections = model.sections(matching: "")
		super.init(style: .insetGrouped)
	}
	required init?(coder: NSCoder) { fatalError("Use init(model:selectedType:onSelection:)") }

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Data Types"
		tableView.accessibilityIdentifier = "sampleTypeSearch"
		tableView.rowHeight = UITableView.automaticDimension; tableView.estimatedRowHeight = 52
		search.searchResultsUpdater = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Search data types"
		search.searchBar.accessibilityIdentifier = "search data types field"
		search.searchBar.searchTextField.autocorrectionType = .no
		search.searchBar.searchTextField.spellCheckingType = .no
		search.searchBar.searchTextField.autocapitalizationType = .none
		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch))
		definesPresentationContext = true
		updateEmptyState()
	}

	func updateSearchResults(for searchController: UISearchController) { applySearch(searchController.searchBar.text ?? "") }
	func applySearch(_ query: String) {
		sections = model.sections(matching: query)
		guard isViewLoaded else { return }
		tableView.reloadData(); updateEmptyState()
	}
	@objc func cancelSearch() { onSelection = nil; dismiss(animated: true) }

	private func updateEmptyState() {
		guard sections.isEmpty else { tableView.backgroundView = nil; return }
		let label = UILabel()
		label.text = model.items.isEmpty ? "No data types are available." : "No matching data types."
		label.font = .preferredFont(forTextStyle: .body); label.adjustsFontForContentSizeCategory = true
		label.textColor = .secondaryLabel; label.textAlignment = .center; label.numberOfLines = 0
		label.accessibilityIdentifier = "sampleTypeSearchEmpty"
		tableView.backgroundView = label
	}

	override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sections.indices.contains(section) ? sections[section].items.count : 0
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		sections.indices.contains(section) ? sections[section].title : nil
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "sampleTypeSearchRow")
			?? UITableViewCell(style: .default, reuseIdentifier: "sampleTypeSearchRow")
		let item = sections[indexPath.section].items[indexPath.row]
		cell.textLabel?.text = item.title
		cell.textLabel?.font = .preferredFont(forTextStyle: .body)
		cell.textLabel?.adjustsFontForContentSizeCategory = true; cell.textLabel?.numberOfLines = 0
		let selected = selectedType.map { $0 == item.sampleType } ?? false
		cell.accessoryType = selected ? .checkmark : .none
		cell.accessibilityIdentifier = "sampleTypeSearchRow.\(item.originalIndex)"
		cell.accessibilityTraits = selected ? [.button, .selected] : [.button]
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard sections.indices.contains(indexPath.section), sections[indexPath.section].items.indices.contains(indexPath.row),
			let choose = onSelection else { return }
		onSelection = nil
		choose(sections[indexPath.section].items[indexPath.row].sampleType)
		dismiss(animated: true)
	}
}
