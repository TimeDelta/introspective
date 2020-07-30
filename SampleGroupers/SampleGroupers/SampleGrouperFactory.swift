//
//  SampleGrouperFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

// sourcery: AutoMockable
public protocol SampleGrouperFactory {
	func typesFor(sampleType: Sample.Type) -> [SampleGrouper.Type]
	func typesFor(attributes: [Attribute]) -> [SampleGrouper.Type]
	func groupersFor(sampleType: Sample.Type) -> [SampleGrouper]
	func groupersFor(attributes: [Attribute]) -> [SampleGrouper]
	func groupDefinition(_ sampleType: Sample.Type) -> GroupDefinition
}

public final class SampleGrouperFactoryImpl: SampleGrouperFactory {
	private typealias Me = SampleGrouperFactoryImpl

	private static let dateTypes: [SampleGrouper.Type] = [
		SameTimeUnitSampleGrouper.self,
		DayOfWeekSampleGrouper.self,
	]

	private static let dayOfWeekTypes: [SampleGrouper.Type] = [
		DayOfWeekSampleGrouper.self,
	]

	private static let tagTypes: [SampleGrouper.Type] = [
		PerTagSampleGrouper.self,
	]

	private static let genericTypes: [SampleGrouper.Type] = [
		SameValueSampleGrouper.self,
		AdvancedSampleGrouper.self,
	]

	private static let textTypes: [SampleGrouper.Type] = [
		SplitByListElementSampleGrouper.self,
	]

	private static let log = Log()

	public final func typesFor(sampleType: Sample.Type) -> [SampleGrouper.Type] {
		typesFor(attributes: sampleType.attributes)
	}

	public final func typesFor(attributes: [Attribute]) -> [SampleGrouper.Type] {
		var types = [SampleGrouper.Type]()
		var addedSoFar = Set<String>()
		for attribute in attributes {
			switch attribute {
			case is DateAttribute:
				addEverythingNotAdded(to: &types, from: Me.dateTypes, addedSoFar: &addedSoFar)
				break
			case is DayOfWeekAttribute:
				addEverythingNotAdded(to: &types, from: Me.dayOfWeekTypes, addedSoFar: &addedSoFar)
				break
			case is TagAttribute, is TagsAttribute:
				addEverythingNotAdded(to: &types, from: Me.tagTypes, addedSoFar: &addedSoFar)
				break
			case is TextAttribute:
				addEverythingNotAdded(to: &types, from: Me.textTypes, addedSoFar: &addedSoFar)
				break
			default: Me.log.error("Missing attribute type: %@", attribute.typeName)
			}
		}
		addEverythingNotAdded(to: &types, from: Me.genericTypes, addedSoFar: &addedSoFar)
		return types
	}

	public final func groupersFor(sampleType: Sample.Type) -> [SampleGrouper] {
		typesFor(sampleType: sampleType).map { $0.init(sampleType: sampleType) }
	}

	public final func groupersFor(attributes: [Attribute]) -> [SampleGrouper] {
		typesFor(attributes: attributes).map { $0.init(attributes: attributes) }
	}

	public final func groupDefinition(_ sampleType: Sample.Type) -> GroupDefinition {
		GroupDefinitionImpl(sampleType)
	}

	private final func addEverythingNotAdded(
		to types: inout [SampleGrouper.Type],
		from toAdd: [SampleGrouper.Type],
		addedSoFar: inout Set<String>
	) {
		for type in toAdd {
			if !addedSoFar.contains(type.userVisibleDescription) {
				types.append(type)
				addedSoFar.insert(type.userVisibleDescription)
			}
		}
	}
}
