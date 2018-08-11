//
//  RecordDataPageViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class RecordDataPageViewController: UIPageViewController {

	fileprivate lazy var orderedViewControllers: [UIViewController] = [
		instantiateController(named: "recordDataTable"),
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		dataSource = self

		if let firstViewController = orderedViewControllers.first {
			setViewControllers(
				[firstViewController],
				direction: .forward,
				animated: true,
				completion: nil)
		}
	}

	fileprivate func instantiateController(named name: String) -> UIViewController {
		return UIStoryboard(name: "RecordData", bundle: nil).instantiateViewController(withIdentifier: name)
	}
}

extension RecordDataPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
			return nil
		}

		let previousIndex = viewControllerIndex - 1
		if previousIndex < 0 {
			return nil
		}

		return orderedViewControllers[previousIndex]
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
			return nil
		}

		let nextIndex = viewControllerIndex + 1
		if nextIndex == orderedViewControllers.count {
			return nil
		}

		return orderedViewControllers[nextIndex]
	}

	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return orderedViewControllers.count
	}

	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		guard let firstViewController = viewControllers?.first else {
			return 0
		}

		guard let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
			return 0
		}

		return firstViewControllerIndex
	}
}
