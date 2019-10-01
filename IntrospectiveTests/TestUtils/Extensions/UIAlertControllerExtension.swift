//
//  UIAlertControllerExtension.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public extension UIAlertController {
	typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

	enum Errors: Error {
		case actionTitleNotFound
	}

	func tapButton(atIndex index: Int) {
		guard let block = actions[index].value(forKey: "handler") else { return }
		let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
		handler(actions[index])
	}

	func tapButton(withTitle title: String) throws {
		guard let index = actions.firstIndex(where: { $0.title == title }) else {
			throw Errors.actionTitleNotFound
		}
		tapButton(atIndex: index)
	}
}
