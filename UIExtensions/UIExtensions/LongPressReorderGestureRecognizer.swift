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

	private weak final var tableViewController: UITableViewController?
	private final let allowReorder: ((IndexPath, IndexPath?) -> Bool)?

	private final var initialIndexPath: IndexPath?
	private weak final var draggedCell: UITableViewCell?
	private final var originalCellAlpha: CGFloat = 1
	private final var originalCellHidden = false
	private final var cellSnapshot: UIView?

	// MARK: - Initializers

	public init(
		_ tableViewController: UITableViewController,
		allowReorder: ((IndexPath, IndexPath?) -> Bool)? = nil
	) {
		self.tableViewController = tableViewController
		self.allowReorder = allowReorder

		super.init(target: nil, action: nil)
		addTarget(self, action: #selector(longPressGestureRecognized))
	}

	// MARK: - Actions

	@objc private final func longPressGestureRecognized(gestureRecognizer _: UIGestureRecognizer) {
		guard let tableView = tableViewController?.tableView else { return }
		let point = location(in: tableView)
		switch state {
		case .began: beginDragging(at: point)
		case .changed: updateDrag(at: point)
		case .ended: finishDragging(at: point)
		case .cancelled, .failed: cancelDragging()
		default: break
		}
	}

	public override func reset() {
		cancelDragging()
		super.reset()
	}

	// Keep all terminal paths responsible for restoring the original cell. A long
	// press can begin on a search field/header, leave the table, or be cancelled.
	final func beginDragging(at point: CGPoint) {
		cancelDragging()
		guard let tableView = tableViewController?.tableView,
			let indexPath = tableView.indexPathForRow(at: point),
			allowReorder?(indexPath, indexPath) != false,
			let cell = tableView.cellForRow(at: indexPath),
			cell.bounds.width > 0, cell.bounds.height > 0 else { return }
		let snapshot = snapshotOfCell(inputView: cell)
		initialIndexPath = indexPath
		draggedCell = cell
		originalCellAlpha = cell.alpha
		originalCellHidden = cell.isHidden
		cellSnapshot = snapshot
		snapshot.center = cell.center
		snapshot.alpha = 0
		tableView.addSubview(snapshot)
		UIView.animate(withDuration: 0.25, animations: {
			snapshot.center.y = point.y
			snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
			snapshot.alpha = 0.5
			cell.alpha = 0
		}, completion: { [weak self] finished in
			if finished && self?.cellSnapshot === snapshot { cell.isHidden = true }
		})
	}

	final func updateDrag(at point: CGPoint) {
		guard let snapshot = cellSnapshot else { return }
		snapshot.center.y = point.y
	}

	final func finishDragging(at point: CGPoint) {
		let source = initialIndexPath
		// Restore before the delegate reloads/reuses cells, including on rejection.
		cancelDragging()
		guard let controller = tableViewController, let source = source,
			let destination = controller.tableView.indexPathForRow(at: point),
			source != destination,
			allowReorder?(source, destination) != false else { return }
		controller.tableView(controller.tableView, moveRowAt: source, to: destination)
	}

	final func cancelDragging() {
		initialIndexPath = nil
		let snapshot = cellSnapshot
		cellSnapshot = nil
		draggedCell?.alpha = originalCellAlpha
		draggedCell?.isHidden = originalCellHidden
		draggedCell = nil
		snapshot?.removeFromSuperview()
	}

	// MARK: - Helper Functions

	private final func snapshotOfCell(inputView: UIView) -> UIView {
		let image = UIGraphicsImageRenderer(bounds: inputView.bounds).image { context in
			inputView.layer.render(in: context.cgContext)
		}
		let snapshot = UIImageView(image: image)
		snapshot.layer.masksToBounds = false
		snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
		snapshot.layer.shadowRadius = 5
		snapshot.layer.shadowOpacity = 0.4
		return snapshot
	}
}
