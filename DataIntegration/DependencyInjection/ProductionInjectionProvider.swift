//
//  ProductionInjectionProvider.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public final class ProductionInjectionProvider: InjectionProvider {

	private typealias Me = ProductionInjectionProvider

	private static let realDatabase = DatabaseImpl()
	private static let realCodableStorage = CodableStorageImpl()
	private static var realSettings: SettingsImpl!
	private static let realQueryFactory = QueryFactoryImpl()
	private static let realSampleFactory = SampleFactoryImpl()
	private static let realUtilFactory = UtilFactory()
	private static let realSubQueryMatcherFactory = SubQueryMatcherFactoryImpl()
	private static let realExtraInformationFactory = ExtraInformationFactoryImpl()
	private static let realSampleGrouperFactory = SampleGrouperFactoryImpl()
	private static let realSampleGroupCombinerFactory = SampleGroupCombinerFactoryImpl()
	private static let realImporterFactory = ImporterFactoryImpl()

	public final func database() -> Database { return Me.realDatabase }
	public final func codableStorage() -> CodableStorage { return Me.realCodableStorage }
	public final func settings() -> Settings {
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
	public final func queryFactory() -> QueryFactory { return Me.realQueryFactory }
	public final func sampleFactory() -> SampleFactory { return Me.realSampleFactory }
	public final func utilFactory() -> UtilFactory { return Me.realUtilFactory }
	public final func subQueryMatcherFactory() -> SubQueryMatcherFactory { return Me.realSubQueryMatcherFactory }
	public final func extraInformationFactory() -> ExtraInformationFactory { return Me.realExtraInformationFactory }
	public final func sampleGrouperFactory() -> SampleGrouperFactory { return Me.realSampleGrouperFactory }
	public final func sampleGroupCombinerFactory() -> SampleGroupCombinerFactory { return Me.realSampleGroupCombinerFactory }
	public final func importerFactory() -> ImporterFactory { return Me.realImporterFactory }
}
