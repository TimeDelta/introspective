//
//  ExploreCollectionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import Queries

final class ExploreCollectionViewController: UICollectionViewController {
	// MARK: - Static Variables

	private typealias Me = ExploreCollectionViewController

	private static let queryCellReuseIdentifier = "query"
	private static let graphCellReuseIdentifier = "graph"
	private static let unifiedViewCellReuseIdentifier = "unifiedView"
	private static let timelineCellReuseIdentifier = "timeline"

	private static let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		observe(selector: #selector(showResultsScreen), name: .showResultsScreen)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - UICollectionViewDataSource

	final override func numberOfSections(in _: UICollectionView) -> Int {
		1
	}

	final override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		3
	}

	final override func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		if indexPath.row == 0 {
			return collectionView.dequeueReusableCell(withReuseIdentifier: Me.queryCellReuseIdentifier, for: indexPath)
		}
		if indexPath.row == 1 {
			return collectionView.dequeueReusableCell(withReuseIdentifier: Me.graphCellReuseIdentifier, for: indexPath)
		}
		if indexPath.row == 2 {
			return collectionView.dequeueReusableCell(
				withReuseIdentifier: Me.timelineCellReuseIdentifier,
				for: indexPath
			)
		}

		Me.log.error("Unknown row when trying to create UICollectionViewCell: %d", indexPath.row)
		return UICollectionViewCell()
	}

	// MARK: - UICollectionViewDelegate

	final override func collectionView(_: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
		indexPath.row == 1
	}

	final override func collectionView(
		_: UICollectionView,
		canPerformAction _: Selector,
		forItemAt _: IndexPath,
		withSender _: Any?
	) -> Bool {
		true
	}

	final override func collectionView(
		_: UICollectionView,
		performAction _: Selector,
		forItemAt _: IndexPath,
		withSender _: Any?
	) {}

	// MARK: - Received Notifications

	@objc private final func showResultsScreen(notification: Notification) {
		if let query: Query = value(for: .query, from: notification) {
			let resultsController = viewController(
				named: "results",
				fromStoryboard: "Results"
			) as! ResultsViewController
			query.runQuery { (result: QueryResult?, error: Error?) in
				if let error = error {
					DispatchQueue.main.async {
						resultsController.showError(title: "Failed to run query", error: error)
					}
					Me.log.error("Query returned error: %@", errorInfo(error))
					return
				}
				resultsController.samples = result?.samples
			}
			resultsController.query = query
			if let navigationController = navigationController {
				resultsController.backButtonTitle = navigationController.topViewController?.navigationItem.title
				navigationController.pushViewController(resultsController, animated: false)
			} else {
				Me.log.error("no navigation controller found")
			}
		}
	}
}
