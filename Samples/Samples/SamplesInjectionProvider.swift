//
//  SamplesInjectionProvider.swift
//  Samples
//
//  Created by Bryan Nova on 10/1/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection

public class SamplesInjectionProvider: InjectionProvider {

	private typealias Me = SamplesInjectionProvider
	private static let activityDao = ActivityDaoImpl()
	private static let coreDataSampleUtil = CoreDataSampleUtilImpl()
	private static let healthKitUtil = HealthKitUtilImpl()
	private static let moodUtil = MoodUtilImpl()
	private static let numericSampleUtil = NumericSampleUtilImpl()
	private static let sampleFactory = SampleFactoryImpl()
	private static let sampleUtil = SampleUtilImpl()

	public final let types: [Any.Type] = [
		ActivityDao.self,
		ActivityExporter.self,
		CoreDataSampleUtil.self,
		HealthKitUtil.self,
		MedicationExporter.self,
		MoodExporter.self,
		MoodUtil.self,
		NumericSampleUtil.self,
		SampleFactory.self,
		SampleUtil.self,
	]

	public init() {
	}

	public final func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
			case is ActivityDao.Protocol:
				return Me.activityDao as! Type
			case is ActivityExporter.Protocol:
				return try ActivityExporterImpl() as! Type
			case is CoreDataSampleUtil.Protocol:
				return Me.coreDataSampleUtil as! Type
			case is HealthKitUtil.Protocol:
				return Me.healthKitUtil as! Type
			case is MedicationExporter.Protocol:
				return try MedicationExporterImpl() as! Type
			case is MoodExporter.Protocol:
				return try MoodExporterImpl() as! Type
			case is MoodUtil.Protocol:
				return Me.moodUtil as! Type
			case is NumericSampleUtil.Protocol:
				return Me.numericSampleUtil as! Type
			case is SampleFactory.Protocol:
				return Me.sampleFactory as! Type
			case is SampleUtil.Protocol:
				return Me.sampleUtil as! Type
			default:
				throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}