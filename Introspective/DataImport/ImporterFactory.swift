//
//  ImporterFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol ImporterFactory {

	func wellnessMoodImporter() throws -> WellnessMoodImporter
}

public final class ImporterFactoryImpl: ImporterFactory {

	public final func wellnessMoodImporter() throws -> WellnessMoodImporter {
		let importers = try DependencyInjector.db.query(WellnessMoodImporterImpl.fetchRequest())
		if importers.count > 0 {
			return importers[0]
		}
		return try DependencyInjector.db.new(objectType: WellnessMoodImporterImpl.self)
	}
}
