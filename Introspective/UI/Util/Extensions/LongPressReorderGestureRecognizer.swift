//
//  LongPressReorderGestureRecognizer.swift
//  Introspective
//
//  Created by Bryan Nova on 8/6/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public final class LongPressReorderGestureRecognizer: UILongPressGestureRecognizer {

	// MARK: - Instance Variables

	private final var tableView: UITableView {
		return tableViewController().tableView
	}
	private final let tableViewController: () -> UITableViewController
	private final let allowReorder: ((IndexPath, IndexPath?) -> Bool)?

	private final var initialIndexPath: IndexPath!
	private final var cellSnapshot: UIView?

	// MARK: - Initializers

	public init(
		_ tableViewController: @escaping () -> UITableViewController,
		allowReorder: ((IndexPath, IndexPath?) -> Bool)? = nil)
	{
		self.tableViewController = tableViewController
		self.allowReorder = allowReorder

		super.init(target: nil, action: nil)
		addTarget(self, action: #selector(longPressGestureRecognized))
	}

	// MARK: - Actions

	@objc private final func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
		let longPress = gestureRecognizer as! UILongPressGestureRecognizer
		let state = longPress.state
		let locationInView = longPress.location(in: tableView)
		let indexPath = tableView.indexPathForRow(at: locationInView)

		switch state {
			case .began:
				guard let indexPath = indexPath else { return }
				initialIndexPath = indexPath
				if let allowReorder = allowReorder {
					guard allowReorder(initialIndexPath, indexPath) else { return }
				}
				guard let cell = tableView.cellForRow(at: indexPath) else { return }
				cellSnapshot = snapshotOfCell(inputView: cell)
				var center = cell.center
				cellSnapshot!.center = center
				cellSnapshot!.alpha = 0.0
				tableView.addSubview(cellSnapshot!)

				UIView.animate(
					withDuration: 0.25,
					animations: {
						center.y = locationInView.y
						self.cellSnapshot!.center = center
						self.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
						self.cellSnapshot!.alpha = 0.5
						cell.alpha = 0.0
					},
					completion: { finished in
						if finished { cell.isHidden = true }
					})
				break
			case .changed:
				var center = cellSnapshot!.center
				center.y = locationInView.y
				cellSnapshot!.center = center
				break
			case .ended:
				guard let indexPath = indexPath else { return }
				if indexPath != initialIndexPath {
					tableViewController().tableView(tableView, moveRowAt: initialIndexPath, to: indexPath)
					initialIndexPath = indexPath
				}
				if let allowReorder = allowReorder {
					guard allowReorder(initialIndexPath, indexPath) else { return }
				}
				guard let cell = tableView.cellForRow(at: initialIndexPath!) else { return }
				cell.isHidden = false
				cell.alpha = 0.0
				UIView.animate(
					withDuration: 0.25,
					animations: {
						self.cellSnapshot!.center = cell.center
						self.cellSnapshot!.transform = CGAffineTransform.identity
						self.cellSnapshot!.alpha = 0.0
						cell.alpha = 1.0
					},
					completion: { finished in
						if finished {
							self.initialIndexPath = nil
							self.cellSnapshot!.removeFromSuperview()
							self.cellSnapshot = nil
						}
					})
				break
			default:
				break
		}
	}

	// MARK: - Helper Functions

	private final func snapshotOfCell(inputView: UIView) -> UIView {
		UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
		inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
		UIGraphicsEndImageContext()
		let cellSnapshot : UIView = UIImageView(image: image)
		cellSnapshot.layer.masksToBounds = false
		cellSnapshot.layer.cornerRadius = 0.0
		cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
		cellSnapshot.layer.shadowRadius = 5.0
		cellSnapshot.layer.shadowOpacity = 0.4
		return cellSnapshot
	}
}
