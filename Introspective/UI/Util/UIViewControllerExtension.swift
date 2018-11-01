//
//  UIViewControllerExtension.swift
//  Introspective
//
//  Created by Bryan Nova on 11/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

extension UIViewController {

	final func showError(title: String, message: String? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		present(alert, animated: false, completion: nil)
	}
}
