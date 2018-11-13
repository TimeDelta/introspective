//
//  MultiSelectAttributeValueSelectTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

public final class MultiSelectAttributeValueSelectTableViewController: UITableViewController {

	// MARK: - Instance Variables

	public final var multiSelectAttribute: MultiSelectAttribute!
	public final var initialValue: Any?
	public private(set) final var selectedValues = [Any]()

	private final let searchController = UISearchController(searchResultsController: nil)
	private final var filteredValues = [Any]()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		filteredValues = multiSelectAttribute.possibleValues
		if let initialValue = initialValue {
			do {
				let initiallySelectedValues = try multiSelectAttribute.valueAsArray(initialValue)
				selectRowsForValues(initiallySelectedValues)
			} catch {
				os_log("Failed to set initial multi-select value: %@", type: .error, error.localizedDescription)
			}
		}

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search \(multiSelectAttribute.pluralName.localizedLowercase)"
		tableView.tableHeaderView = searchController.searchBar
		definesPresentationContext = true
	}

	// MARK: - TableViewDataSource

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredValues.count
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		let value = filteredValues[indexPath.row]
		var displayValue: String
		do {
			displayValue = try multiSelectAttribute.convertPossibleValueToDisplayableString(value)
		} catch {
			os_log("Failed to convert '$@' displayable value: %@", type: .error, String(describing: value), error.localizedDescription)
			displayValue = String(describing: value)
		}
		cell.textLabel!.text = displayValue
		return cell
	}


	// MARK: - TableViewDelegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedValues.append(filteredValues[indexPath.row])
	}

	public final override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let indexToRemove = multiSelectAttribute.indexOf(possibleValue: filteredValues[indexPath.row], in: selectedValues) {
			selectedValues.remove(at: indexToRemove)
		} else {
			os_log("Did not find value to remove from selection in selected values", type: .error)
			// do nothing because we're already in the state the user is currently requesting
		}
	}

	// MARK: - Helper Functions

	private final func selectRowsForValues(_ values: [Any]) {
		for value in values {
			if let index = multiSelectAttribute.indexOf(possibleValue: value, in: filteredValues) {
				tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
			}
		}
	}
}

// MARK: - UISearchResultsUpdating

extension MultiSelectAttributeValueSelectTableViewController: UISearchResultsUpdating {

	public func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text!.localizedLowercase
		filteredValues = multiSelectAttribute.possibleValues
		if !searchText.isEmpty {
			filteredValues = filteredValues.filter({ value in
				do {
					let stringValue = try self.multiSelectAttribute.convertPossibleValueToDisplayableString(value)
					return stringValue.localizedLowercase.contains(searchText)
				} catch {
					os_log("Failed to convert '$@' displayable value: %@", type: .error, String(describing: value), error.localizedDescription)
					return false
				}
			})
		}
		tableView.reloadData()
		selectRowsForValues(selectedValues)
	}
}
