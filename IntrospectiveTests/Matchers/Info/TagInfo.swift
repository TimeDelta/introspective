//
//  TagInfo.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/4/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

@testable import Samples

public final class TagInfo: Info {

	var name: String

	public init(_ name: String) {
		self.name = name
	}

	public func getPredicates() -> [String : NSPredicate] {
		var predicates = [String : NSPredicate]()
		predicates["name"] = NSPredicate(format: "name ==[cd] %@", name)
		return predicates
	}
}
