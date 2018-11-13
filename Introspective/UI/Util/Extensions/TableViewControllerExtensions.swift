//
//  TableViewControllerExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

extension UITableViewController {

	final func reorderOnLongPress() {
		let longpressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
		tableView.addGestureRecognizer(longpressRecognizer)
	}

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

	@objc private final func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
		let longPress = gestureRecognizer as! UILongPressGestureRecognizer
		let state = longPress.state
		let locationInView = longPress.location(in: self.tableView)
		let indexPath = self.tableView.indexPathForRow(at: locationInView)

		struct My {
			static var cellSnapshot: UIView? = nil
		}
		struct Path {
			static var initialIndexPath: IndexPath? = nil
		}

		switch state {
			case .began:
				guard let indexPath = indexPath else { return }
				Path.initialIndexPath = indexPath
				guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
				My.cellSnapshot = snapshotOfCell(inputView: cell)
				var center = cell.center
				My.cellSnapshot!.center = center
				My.cellSnapshot!.alpha = 0.0
				self.tableView.addSubview(My.cellSnapshot!)

				UIView.animate(
					withDuration: 0.25,
					animations: {
						center.y = locationInView.y
						My.cellSnapshot!.center = center
						My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
						My.cellSnapshot!.alpha = 0.98
						cell.alpha = 0.0
					},
					completion: { finished in
						if finished { cell.isHidden = true }
					})
			case .changed:
				var center = My.cellSnapshot!.center
				center.y = locationInView.y
				My.cellSnapshot!.center = center
				guard let indexPath = indexPath else { return }
				if indexPath != Path.initialIndexPath {
					tableView(self.tableView, moveRowAt: Path.initialIndexPath!, to: indexPath)
					Path.initialIndexPath = indexPath
				}
			default:
				guard let cell = self.tableView.cellForRow(at: Path.initialIndexPath!) else { return }
				cell.isHidden = false
				cell.alpha = 0.0
				UIView.animate(
					withDuration: 0.25,
					animations: {
						My.cellSnapshot!.center = cell.center
						My.cellSnapshot!.transform = CGAffineTransform.identity
						My.cellSnapshot!.alpha = 0.0
						cell.alpha = 1.0
					},
					completion: { finished in
						if finished {
							Path.initialIndexPath = nil
							My.cellSnapshot!.removeFromSuperview()
							My.cellSnapshot = nil
						}
					})
		}
	}
}
