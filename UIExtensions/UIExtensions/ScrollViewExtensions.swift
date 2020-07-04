//
//  ScrollViewExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public extension UIScrollView {
	enum ScrollDirection {
		case top
		case right
		case bottom
		case left

		func contentOffsetWith(_ scrollView: UIScrollView, startOfVisibleAreaY: CGFloat? = nil) -> CGPoint {
			var contentOffset = CGPoint.zero
			switch self {
			case .top:
				contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
			case .right:
				contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
			case .bottom:
				contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
			case .left:
				contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
			}
			if let startOfVisibleAreaY = startOfVisibleAreaY {
				return CGPoint(x: contentOffset.x, y: contentOffset.y - startOfVisibleAreaY)
			}
			return contentOffset
		}
	}

	func scrollTo(direction: ScrollDirection, startOfVisibleAreaY: CGFloat? = nil, animated: Bool = true) {
		setContentOffset(
			direction.contentOffsetWith(self, startOfVisibleAreaY: startOfVisibleAreaY),
			animated: animated
		)
	}

	/// Scroll to a specific view so that it's top is at the top of the scrollview
	func scrollToView(view: UIView, startOfVisibleAreaY: CGFloat? = nil, animated: Bool) {
		if let origin = view.superview {
			// Get the Y position of your child view
			let childStartPoint = origin.convert(view.frame.origin, to: self)
			var y = childStartPoint.y
			if let startOfVisibleAreaY = startOfVisibleAreaY {
				y -= startOfVisibleAreaY
			}
			// Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
			scrollRectToVisible(
				CGRect(
					x: 0,
					y: y,
					width: 1,
					height: frame.height
				),
				animated: animated
			)
		}
	}
}
