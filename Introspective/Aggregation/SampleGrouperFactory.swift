//
//  SampleGrouperFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
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
	]

	private static let tagTypes: [SampleGrouper.Type] = [
		PerTagSampleGrouper.self,
	]

	private static let genericTypes: [SampleGrouper.Type] = [
		SameValueSampleGrouper.self,
		AdvancedSampleGrouper.self,
	]

	private final let log = Log()

	public final func typesFor(sampleType: Sample.Type) -> [SampleGrouper.Type] {
		return typesFor(attributes: sampleType.attributes)
	}

	public final func typesFor(attributes: [Attribute]) -> [SampleGrouper.Type] {
		var types = [SampleGrouper.Type]()
		var typeNames = Set<String>()
		for attribute in attributes {
			switch (attribute) {
				case is DateAttribute:
					if !typeNames.contains(attribute.typeName) {
						types.append(contentsOf: Me.dateTypes)
						typeNames.insert(attribute.typeName)
					}
					break
				case is TagAttribute, is TagsAttribute:
					if !typeNames.contains(attribute.typeName) {
						types.append(contentsOf: Me.tagTypes)
						typeNames.insert(attribute.typeName)
					}
					break
				default: log.error("Missing attribute type: %@", attribute.typeName)
			}
		}
		types.append(contentsOf: Me.genericTypes)
		return types
	}

	public final func groupersFor(sampleType: Sample.Type) -> [SampleGrouper] {
		return typesFor(sampleType: sampleType).map{ $0.init(sampleType: sampleType) }
	}

	public final func groupersFor(attributes: [Attribute]) -> [SampleGrouper] {
		return typesFor(attributes: attributes).map{ $0.init(attributes: attributes) }
	}

	public final func groupDefinition(_ sampleType: Sample.Type) -> GroupDefinition {
		return GroupDefinitionImpl(sampleType)
	}
}
