//
//  TagDAO.swift
//  Samples
//
//  Created by Bryan Nova on 7/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

import Common
import DependencyInjection
import Persistence

//sourcery: AutoMockable
public protocol TagDAO {

	func getTag(named name: String) throws -> Tag?
	func getOrCreateTag(named name: String) throws -> Tag
}

public final class TagDAOImpl: TagDAO {

	private typealias Me = TagDAOImpl

	private static let log = Log()

	public final func getTag(named name: String) throws -> Tag? {
		let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let matchingTags = try DependencyInjector.get(Database.self).query(fetchRequest)
		if matchingTags.count == 0 {
			return nil
		}
		if matchingTags.count == 1 {
			return matchingTags[0]
		}
		Me.log.error("Found more than one tag with specific name: using arbitrary version")
		return matchingTags[0]
	}

	public final func getOrCreateTag(named name: String) throws -> Tag {
		if let existingTag = try getTag(named: name) {
			return existingTag
		}
		let transaction = DependencyInjector.get(Database.self).transaction()
		let tag = try transaction.new(Tag.self)
		tag.name = name
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return tag
	}
}
