//
//  ExploreCollectionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ExploreCollectionViewController: UICollectionViewController {

	// MARK: - Static Variables

	private typealias Me = ExploreCollectionViewController
	private static let queryCellReuseIdentifier = "query"
	private static let graphCellReuseIdentifier = "graph"
	private static let unifiedViewCellReuseIdentifier = "unifiedView"

	// MARK: - Instance Variables

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		observe(selector: #selector(showResultsScreen), name: NotificationNames.showResultsScreen)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - UICollectionViewDataSource

	final override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}


	final override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
	}

	final override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.row == 0 {
			return collectionView.dequeueReusableCell(withReuseIdentifier: Me.queryCellReuseIdentifier, for: indexPath)
		}
		if indexPath.row == 1 {
			return collectionView.dequeueReusableCell(withReuseIdentifier: Me.graphCellReuseIdentifier, for: indexPath)
		}

		log.error("Unknown row when trying to create UICollectionViewCell: %d", indexPath.row)
		return UICollectionViewCell()
	}

	// MARK: - UICollectionViewDelegate

	final override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
		return indexPath.row == 1
	}

	final override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
		return true
	}

	final override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

	}

	// MARK: - Received Notifications

	@objc private final func showResultsScreen(notification: Notification) {
		if let query: Query = value(for: .query, from: notification) {
			let resultsController = DependencyInjector.util.ui.controller(
				named: "results",
				from: "Results",
				as: ResultsViewController.self)
			query.runQuery { (result: QueryResult?, error: Error?) in
				if let error = error {
					DispatchQueue.main.async {
						resultsController.showError(title: "Failed to run query", error: error)
					}
					self.log.error("Query returned error: %@", errorInfo(error))
					return
				}
				resultsController.samples = result?.samples
			}
			resultsController.query = query
			if let navigationController = navigationController {
				resultsController.backButtonTitle = navigationController.topViewController?.navigationItem.title
				navigationController.pushViewController(resultsController, animated: false)
			} else {
				log.error("no navigation controller found")
			}
		}
	}
}
