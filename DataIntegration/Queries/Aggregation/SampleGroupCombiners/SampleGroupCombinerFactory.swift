//
//  SampleGroupCombinerFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol SampleGroupCombinerFactory {
	func typesFor(attribute: Attribute) -> [SampleGroupCombiner.Type]
	func initialize(type: SampleGroupCombiner.Type) -> SampleGroupCombiner
}

public class SampleGroupCombinerFactoryImpl: SampleGroupCombinerFactory {

	fileprivate typealias Me = SampleGroupCombinerFactoryImpl

	public static let genericTypes: [SampleGroupCombiner.Type] = [
		CountSampleGroupCombiner.self,
	]

	public static let numericTypes: [SampleGroupCombiner.Type] = [
		AverageSampleGroupCombiner.self,
		SumSampleGroupCombiner.self,
	]

	public static let comparableTypes: [SampleGroupCombiner.Type] = [
		MaximumSampleGroupCombiner.self,
		MinimumSampleGroupCombiner.self,
	]

	public func typesFor(attribute: Attribute) -> [SampleGroupCombiner.Type] {
		var types = Me.genericTypes
		if attribute is NumericAttribute {
			types.append(contentsOf: Me.numericTypes)
			types.append(contentsOf: Me.comparableTypes)
		} else if attribute is DateAttribute {
			types.append(contentsOf: Me.comparableTypes)
		}
		return types
	}

	public func initialize(type: SampleGroupCombiner.Type) -> SampleGroupCombiner {
		return type.init()
	}
}
