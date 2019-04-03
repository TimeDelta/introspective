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

	private static var realDatabase: DatabaseImpl!
	private static let realCodableStorage = CodableStorageImpl()
	private static var realSettings: SettingsImpl!
	private static let realQueryFactory = QueryFactoryImpl()
	private static let realAttributeRestrictionFactory = AttributeRestrictionFactoryImpl()
	private static let realSampleFactory = SampleFactoryImpl()
	private static let realUtilFactory = UtilFactory()
	private static let realSubQueryMatcherFactory = SubQueryMatcherFactoryImpl()
	private static let realExtraInformationFactory = ExtraInformationFactoryImpl()
	private static let realSampleGrouperFactory = SampleGrouperFactoryImpl()
	private static let realImporterFactory = ImporterFactoryImpl()

	public final func database() -> Database {
		if Me.realDatabase == nil {
			Me.realDatabase = DatabaseImpl()
			if uiTesting {
				try! Me.realDatabase.deleteEverything()
				Me.realDatabase = DatabaseImpl()
			}
		}
		return Me.realDatabase
	}
	public final func codableStorage() -> CodableStorage { return Me.realCodableStorage }
	public final func settings() -> Settings {
		if Me.realSettings == nil {
			do {
				let existingSettings = try database().query(SettingsImpl.fetchRequest())
				if existingSettings.count == 0 {
					do {
						let transaction = database().transaction()
						let settings = try retryOnFail({ try transaction.new(SettingsImpl.self) }, maxRetries: 2)
						try retryOnFail({ try transaction.commit() }, maxRetries: 2)
						Me.realSettings = try database().pull(savedObject: settings)
					} catch {
						fatalError(String(format: "Failed to create or save default settings: %@", errorInfo(error)))
					}
				} else {
					Me.realSettings = existingSettings[0]
				}
			} catch {
				fatalError(String(format: "Failed to load settings: %@", errorInfo(error)))
			}
		}
		return Me.realSettings
	}
	public final func queryFactory() -> QueryFactory { return Me.realQueryFactory }
	public final func attributeRestrictionFactory() -> AttributeRestrictionFactory { return Me.realAttributeRestrictionFactory }
	public final func sampleFactory() -> SampleFactory { return Me.realSampleFactory }
	public final func utilFactory() -> UtilFactory { return Me.realUtilFactory }
	public final func subQueryMatcherFactory() -> SubQueryMatcherFactory { return Me.realSubQueryMatcherFactory }
	public final func extraInformationFactory() -> ExtraInformationFactory { return Me.realExtraInformationFactory }
	public final func sampleGrouperFactory() -> SampleGrouperFactory { return Me.realSampleGrouperFactory }
	public final func importerFactory() -> ImporterFactory { return Me.realImporterFactory }
}
