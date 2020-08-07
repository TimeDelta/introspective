//
//  TagDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

public final class TagDataTestUtil {

	@discardableResult
	public static func createTag(name: String = "") -> Tag {
		let transaction = injected(Database.self).transaction()
		let tag = try! transaction.new(Tag.self)
		tag.name = name
		try! transaction.commit()
		return try! injected(Database.self).pull(savedObject: tag)
	}

	@discardableResult
	public static func createTags(names: [String]) -> [Tag] {
		var tags = [Tag]()
		for name in names {
			tags.append(createTag(name: name))
		}
		return tags
	}
}
