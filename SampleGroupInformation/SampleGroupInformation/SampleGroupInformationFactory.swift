//
//  SampleGroupInformationFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

// sourcery: AutoMockable
public protocol SampleGroupInformationFactory {
	func getApplicableInformationTypes(forAttribute attribute: Attribute) -> [SampleGroupInformation.Type]
	func getApplicableNumericInformationTypes(forAttribute attribute: Attribute) -> [SampleGroupInformation.Type]
	func initInformation(
		_ informationType: SampleGroupInformation.Type,
		_ attribute: Attribute
	) -> SampleGroupInformation
}

public final class SampleGroupInformationFactoryImpl: SampleGroupInformationFactory {
	private typealias Me = SampleGroupInformationFactoryImpl

	private static let genericInformationTypes: [SampleGroupInformation.Type] = [
		ModeInformation.self,
		CountInformation.self,
	]

	private static let numericInformationTypes: [SampleGroupInformation.Type] = [
		AverageInformation.self,
		SumInformation.self,
	]

	private static let dateInformationTypes: [SampleGroupInformation.Type] = [
		OldestDateInformation.self,
		MostRecentDateInformation.self,
	]

	public final func getApplicableInformationTypes(
		forAttribute attribute: Attribute
	) -> [SampleGroupInformation.Type] {
		var applicableInformationTypes = [SampleGroupInformation.Type]()
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
			applicableInformationTypes.append(MaximumInformation<TimeDuration>.self)
			applicableInformationTypes.append(MinimumInformation<TimeDuration>.self)
			applicableInformationTypes.append(MedianInformation<TimeDuration>.self)
		}
		// TODO: - additional attribute types
		applicableInformationTypes.append(contentsOf: Me.genericInformationTypes)
		return applicableInformationTypes
	}

	public final func getApplicableNumericInformationTypes(
		forAttribute attribute: Attribute
	) -> [SampleGroupInformation.Type] {
		var applicableInformationTypes = [SampleGroupInformation.Type]()
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
			applicableInformationTypes.append(MaximumInformation<TimeDuration>.self)
			applicableInformationTypes.append(MinimumInformation<TimeDuration>.self)
			applicableInformationTypes.append(MedianInformation<TimeDuration>.self)
			applicableInformationTypes.append(ModeInformation.self)
		}
		applicableInformationTypes.append(CountInformation.self)
		return applicableInformationTypes
	}

	public final func initInformation(
		_ informationType: SampleGroupInformation.Type,
		_ attribute: Attribute
	) -> SampleGroupInformation {
		informationType.init(attribute)
	}
}
