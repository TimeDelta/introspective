//
//  CoachMarkSkipViewConstraint.swift
//  Introspective
//
//  Created by Bryan Nova on 2/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public protocol CoachMarkSkipViewConstraint {
	func constraint(skipView: UIView, parentView: UIView) -> NSLayoutConstraint
}

public final class GenericCoachMarkSkipViewConstraint: CoachMarkSkipViewConstraint {
	private final let skipViewAttribute: NSLayoutConstraint.Attribute
	private final let relatedBy: NSLayoutConstraint.Relation
	private final let parentViewAttribute: NSLayoutConstraint.Attribute
	private final let multiplier: CGFloat
	private final let constant: CGFloat

	public init(
		skipViewAttribute: NSLayoutConstraint.Attribute,
		relatedBy: NSLayoutConstraint.Relation,
		parentViewAttribute: NSLayoutConstraint.Attribute,
		multiplier: CGFloat = 1.0,
		constant: CGFloat = 0.0
	) {
		self.skipViewAttribute = skipViewAttribute
		self.relatedBy = relatedBy
		self.parentViewAttribute = parentViewAttribute
		self.multiplier = multiplier
		self.constant = constant
	}

	public final func constraint(skipView: UIView, parentView: UIView) -> NSLayoutConstraint {
		NSLayoutConstraint(
			item: skipView,
			attribute: skipViewAttribute,
			relatedBy: relatedBy,
			toItem: parentView,
			attribute: parentViewAttribute,
			multiplier: multiplier,
			constant: constant
		)
	}
}

public final class HorizontallyCenteredCoachMarkSkipViewConstraint: CoachMarkSkipViewConstraint {
	public final func constraint(skipView: UIView, parentView: UIView) -> NSLayoutConstraint {
		NSLayoutConstraint(
			item: skipView,
			attribute: .centerX,
			relatedBy: .equal,
			toItem: parentView,
			attribute: .centerX,
			multiplier: 1.0,
			constant: 0.0
		)
	}
}
