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

	func wellnessMoodImporter() -> WellnessMoodImporter
}

public final class ImporterFactoryImpl: ImporterFactory {

	public final func wellnessMoodImporter() -> WellnessMoodImporter {
		return WellnessMoodImporterImpl()
	}
}
