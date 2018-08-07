//
//  ExtraInformationFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class ExtraInformationFactory {

	fileprivate typealias Me = ExtraInformationFactory

	public static let numericInformationTypes: [ExtraInformation.Type] = [
		AverageInformation.self,
		CountInformation.self,
		MaximumInformation<Double>.self,
		MinimumInformation<Double>.self,
		SumInformation.self,
	]

	public static let dateInformationTypes: [ExtraInformation.Type] = [
		OldestDateInformation.self,
		MostRecentDateInformation.self,
	]

	public func getApplicableInformationTypes(forAttribute attribute: Attribute) -> [ExtraInformation.Type] {
		if attribute is DoubleAttribute {
			return Me.numericInformationTypes
		}
		if attribute is DateAttribute {
			return Me.dateInformationTypes
		}
		// TODO - additional attribute types
		return []
	}
}
