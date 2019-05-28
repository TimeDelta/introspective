//
//  GenericUIMatchers.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Hamcrest

func isEnabled<Type: UIControl>() -> Matcher<Type> {
	return Matcher("is enabled") { (control: Type) -> Bool in
		return control.isEnabled
	}
}

func isHidden<Type: UIView>() -> Matcher<Type> {
	return Matcher("is hidden") { (view: Type) -> Bool in
		return view.isHidden
	}
}
