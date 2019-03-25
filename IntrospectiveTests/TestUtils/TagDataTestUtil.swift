//
//  TagDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective

public final class TagDataTestUtil {

	@discardableResult
	public static func createTag(name: String = "") -> Tag {
		let transaction = DependencyInjector.db.transaction()
		let tag = try! transaction.new(Tag.self)
		tag.name = name
		try! transaction.commit()
		return try! DependencyInjector.db.pull(savedObject: tag)
	}
}
