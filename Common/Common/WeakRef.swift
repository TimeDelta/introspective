//
//  WeakRef.swift
//  Common
//
//  Created by Bryan Nova on 7/29/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

public class WeakRef<T: AnyObject> {
	public weak private(set) var value: T?

	public init(_ value: T?) {
		self.value = value
	}
}
