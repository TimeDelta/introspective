//
//  CoachMarkInfo.swift
//  Introspective
//
//  Created by Bryan Nova on 2/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public final class CoachMarkInfo {
	public final var hintText: String
	public final var nextText: String
	public final var useArrow: Bool
	public final var view: UIView? { viewMethod() }
	public final var setup: (() -> Void)?

	private final var viewMethod: () -> UIView?

	public init(
		hint: String,
		next: String = "Next",
		useArrow: Bool,
		view: @escaping () -> UIView? = { nil },
		setup: (() -> Void)? = nil
	) {
		hintText = hint
		nextText = next
		self.useArrow = useArrow
		viewMethod = view
		self.setup = setup
	}
}
