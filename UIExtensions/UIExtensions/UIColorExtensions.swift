//
//  UIColorExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 3/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public extension UIColor {

	final func inverse() -> UIColor {
		var r: CGFloat = 0.0
		var g: CGFloat = 0.0
		var b: CGFloat = 0.0
		var a: CGFloat = 0.0
		if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
			return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
		}
		Log().error("Unable to get inverse of color (r: %f, g: %f, b: %f, a: %f)", r, g, b, a)
		return .black
	}

	final func highContrast() -> UIColor {
		var r: CGFloat = 0.0
		var g: CGFloat = 0.0
		var b: CGFloat = 0.0
		var a: CGFloat = 0.0
		if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
			if (r + g + b) / 3 > 0.5 {
				return .black
			}
			return .white
		}
		Log().error("Unable to get high contrast for color (r: %f, g: %f, b: %f, a: %f)", r, g, b, a)
		return .black
	}
}
