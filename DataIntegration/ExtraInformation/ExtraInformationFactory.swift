//
//  ExtraInformationFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol ExtraInformationFactory {

	func getApplicableInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type]
	func getApplicableNumericInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type]
}

public final class ExtraInformationFactoryImpl: ExtraInformationFactory {

	private typealias Me = ExtraInformationFactoryImpl

	private static let genericInformationTypes: [ExtraInformation.Type] = [
		CountInformation.self,
	]

	private static let numericInformationTypes: [ExtraInformation.Type] = [
		AverageInformation.self,
		SumInformation.self,
	]

	private static let dateInformationTypes: [ExtraInformation.Type] = [
		OldestDateInformation.self,
		MostRecentDateInformation.self,
	]

	public final func getApplicableInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type] {
		var applicableInformationTypes = Me.genericInformationTypes
		if attribute is DoubleAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Double>.self)
			applicableInformationTypes.append(MinimumInformation<Double>.self)
		} else if attribute is IntegerAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Int>.self)
			applicableInformationTypes.append(MinimumInformation<Int>.self)
		} else if attribute is DateAttribute {
			applicableInformationTypes.append(contentsOf: Me.dateInformationTypes)
		}
		// TODO - additional attribute types
		return applicableInformationTypes
	}

	public final func getApplicableNumericInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type] {
		var applicableInformationTypes: [ExtraInformation.Type] = [CountInformation.self]
		if attribute is DoubleAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Double>.self)
			applicableInformationTypes.append(MinimumInformation<Double>.self)
		} else if attribute is IntegerAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Int>.self)
			applicableInformationTypes.append(MinimumInformation<Int>.self)
		}
		return applicableInformationTypes
	}
}
