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

	public static func createTag(name: String = "") -> Tag {
		let tag = try! DependencyInjector.db.new(Tag.self)
		tag.name = name
		DependencyInjector.db.save()
		return tag
	}
}
