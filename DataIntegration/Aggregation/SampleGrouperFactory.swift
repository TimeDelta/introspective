//
//  SampleGrouperFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SampleGrouperFactory {
	func typesFor(attribute: Attribute) -> [SampleGrouper.Type]
	func groupersFor(attribute: Attribute) -> [SampleGrouper]
	func initialize(type: SampleGrouper.Type) -> SampleGrouper
}

public final class SampleGrouperFactoryImpl: SampleGrouperFactory {

	private typealias Me = SampleGrouperFactoryImpl

	private static let dateTypes: [SampleGrouper.Type] = [
		SameTimeUnitSampleGrouper.self,
	]

	public final func typesFor(attribute: Attribute) -> [SampleGrouper.Type] {
		var types = [SampleGrouper.Type]()
		if attribute is DateAttribute {
			types.append(contentsOf: Me.dateTypes)
		}
		return types
	}

	public final func groupersFor(attribute: Attribute) -> [SampleGrouper] {
		return typesFor(attribute: attribute).map() { type in return type.init() }
	}

	public final func initialize(type: SampleGrouper.Type) -> SampleGrouper {
		return type.init()
	}
}
