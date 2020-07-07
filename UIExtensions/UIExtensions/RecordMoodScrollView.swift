//
//  RecordMoodScrollView.swift
//  Introspective
//
//  Created by Bryan Nova on 3/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public final class RecordMoodScrollView: UIScrollView {
	public override func touchesShouldCancel(in view: UIView) -> Bool {
		if view is UIButton {
			return false
		}
		return super.touchesShouldCancel(in: view)
	}
}
