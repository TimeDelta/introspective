//
//  ExtraInformationFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

//sourcery: AutoMockable
public protocol ExtraInformationFactory {

	func getApplicableInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type]
	func getApplicableNumericInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type]
	func initInformation(
		_ informationType: ExtraInformation.Type,
		_ attribute: Attribute)
	-> ExtraInformation
}

public final class ExtraInformationFactoryImpl: ExtraInformationFactory {

	private typealias Me = ExtraInformationFactoryImpl

	private static let genericInformationTypes: [ExtraInformation.Type] = [
		ModeInformation.self,
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
		var applicableInformationTypes = [ExtraInformation.Type]()
		if attribute is DoubleAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Double>.self)
			applicableInformationTypes.append(MinimumInformation<Double>.self)
			applicableInformationTypes.append(MedianInformation<Double>.self)
		} else if attribute is IntegerAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Int>.self)
			applicableInformationTypes.append(MinimumInformation<Int>.self)
			applicableInformationTypes.append(MedianInformation<Int>.self)
		} else if attribute is DateAttribute {
			applicableInformationTypes.append(contentsOf: Me.dateInformationTypes)
		} else if attribute is DosageAttribute {
			applicableInformationTypes.append(MaximumInformation<Dosage>.self)
			applicableInformationTypes.append(MinimumInformation<Dosage>.self)
			applicableInformationTypes.append(MedianInformation<Dosage>.self)
			applicableInformationTypes.append(SumInformation.self)
			applicableInformationTypes.append(AverageInformation.self)
		} else if attribute is FrequencyAttribute {
			applicableInformationTypes.append(MaximumInformation<Frequency>.self)
			applicableInformationTypes.append(MinimumInformation<Frequency>.self)
			applicableInformationTypes.append(MedianInformation<Frequency>.self)
		} else if attribute is DurationAttribute {
			applicableInformationTypes.append(SumInformation.self)
			applicableInformationTypes.append(AverageInformation.self)
			applicableInformationTypes.append(MaximumInformation<Duration>.self)
			applicableInformationTypes.append(MinimumInformation<Duration>.self)
			applicableInformationTypes.append(MedianInformation<Duration>.self)
		}
		// TODO - additional attribute types
		applicableInformationTypes.append(contentsOf: Me.genericInformationTypes)
		return applicableInformationTypes
	}

	public final func getApplicableNumericInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type] {
		var applicableInformationTypes = [ExtraInformation.Type]()
		if attribute is DoubleAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Double>.self)
			applicableInformationTypes.append(MinimumInformation<Double>.self)
			applicableInformationTypes.append(MedianInformation<Double>.self)
			applicableInformationTypes.append(ModeInformation.self)
		} else if attribute is IntegerAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Int>.self)
			applicableInformationTypes.append(MinimumInformation<Int>.self)
			applicableInformationTypes.append(MedianInformation<Int>.self)
			applicableInformationTypes.append(ModeInformation.self)
		} else if attribute is DurationAttribute {
			applicableInformationTypes.append(contentsOf: Me.numericInformationTypes)
			applicableInformationTypes.append(MaximumInformation<Duration>.self)
			applicableInformationTypes.append(MinimumInformation<Duration>.self)
			applicableInformationTypes.append(MedianInformation<Duration>.self)
			applicableInformationTypes.append(ModeInformation.self)
		}
		applicableInformationTypes.append(CountInformation.self)
		return applicableInformationTypes
	}

	public final func initInformation(
		_ informationType: ExtraInformation.Type,
		_ attribute: Attribute)
	-> ExtraInformation {
		return informationType.init(attribute)
	}
}