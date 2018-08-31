//
//  ProductionInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public class ProductionInjectionProvider: InjectionProvider {

	fileprivate typealias Me = ProductionInjectionProvider

	fileprivate static let realDatabase = DatabaseImpl()
	fileprivate static let realCodableStorage = CodableStorageImpl()
	fileprivate static var realSettings: SettingsImpl!
	fileprivate static let realQueryFactory = QueryFactoryImpl()
	fileprivate static let realDataTypeFactory = DataTypeFactoryImpl()
	fileprivate static let realUtilFactory = UtilFactory()
	fileprivate static let realSubQueryMatcherFactory = SubQueryMatcherFactoryImpl()
	fileprivate static let realExtraInformationFactory = ExtraInformationFactoryImpl()
	fileprivate static let realSampleGrouperFactory = SampleGrouperFactoryImpl()
	fileprivate static let realSampleGroupCombinerFactory = SampleGroupCombinerFactoryImpl()

	public func database() -> Database { return Me.realDatabase }
	public func codableStorage() -> CodableStorage { return Me.realCodableStorage }
	public func settings() -> Settings {
		if Me.realSettings == nil {
			let fetchRequest = NSFetchRequest<SettingsImpl>(entityName: SettingsImpl.entityName)
			let existingSettings = try! Me.realDatabase.query(fetchRequest)
			if existingSettings.count == 0 {
				Me.realSettings = try! Me.realDatabase.new(objectType: SettingsImpl.self)
			} else {
				Me.realSettings = existingSettings[0]
			}
		}
		return Me.realSettings
	}
	public func queryFactory() -> QueryFactory { return Me.realQueryFactory }
	public func dataTypeFactory() -> DataTypeFactory { return Me.realDataTypeFactory }
	public func utilFactory() -> UtilFactory { return Me.realUtilFactory }
	public func subQueryMatcherFactory() -> SubQueryMatcherFactory { return Me.realSubQueryMatcherFactory }
	public func extraInformationFactory() -> ExtraInformationFactory { return Me.realExtraInformationFactory }
	public func sampleGrouperFactory() -> SampleGrouperFactory { return Me.realSampleGrouperFactory }
	public func sampleGroupCombinerFactory() -> SampleGroupCombinerFactory { return Me.realSampleGroupCombinerFactory }
}
