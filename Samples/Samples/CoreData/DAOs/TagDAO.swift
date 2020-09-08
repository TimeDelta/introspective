//
//  TagDAO.swift
//  Samples
//
//  Created by Bryan Nova on 7/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence

// sourcery: AutoMockable
public protocol TagDAO {
	func getTag(named name: String, using transaction: Transaction?) throws -> Tag?
	func getOrCreateTag(named name: String) throws -> Tag
	func getAllTags() throws -> [Tag]
}

extension TagDAO {
	public func getTag(named name: String, using transaction: Transaction? = nil) throws -> Tag? {
		try getTag(named: name, using: transaction)
	}
}

public final class TagDAOImpl: TagDAO {
	private typealias Me = TagDAOImpl

	private static let log = Log()

	public final func getTag(named name: String, using transaction: Transaction?) throws -> Tag? {
		let transaction = transaction ?? injected(Database.self).transaction()
		let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let matchingTags = try transaction.query(fetchRequest)
		if matchingTags.isEmpty {
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
		let transaction = injected(Database.self).transaction()
		let tag = try transaction.new(Tag.self)
		tag.name = name
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return tag
	}

	public final func getAllTags() throws -> [Tag] {
		try injected(Database.self).query(Tag.fetchRequest())
	}
}
