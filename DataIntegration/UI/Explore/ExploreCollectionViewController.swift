//
//  ExploreCollectionViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class ExploreCollectionViewController: UICollectionViewController {

	private typealias Me = ExploreCollectionViewController
	private static let queryCellReuseIdentifier = "query"
	private static let graphCellReuseIdentifier = "graph"
	private static let runQueryNotification = Notification.Name("runQueryFromExploreTab")

	final override func viewDidLoad() {
		super.viewDidLoad()
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

		os_log("Unknown row when trying to create UICollectionViewCell: %d", type: .error, indexPath.row)
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
}
