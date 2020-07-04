//
//  ExporterUtil.swift
//  DataExport
//
//  Created by Bryan Nova on 9/30/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Common
import DependencyInjection
import Foundation

// sourcery: AutoMockable
public protocol ExporterUtil {
	func urlOfExportFile(for sampleType: Exportable.Type, in directory: URL) -> URL
}

public final class ExporterUtilImpl: ExporterUtil {
	public final func urlOfExportFile(for type: Exportable.Type, in directory: URL) -> URL {
		let now = DependencyInjector.get(CalendarUtil.self).string(for: Date(), inFormat: "yyyy-MM-dd_HH:mm")
		let fileName = "\(type.exportFileDescription.localizedCapitalized) " + now + ".csv"
		return URL(fileURLWithPath: fileName, relativeTo: directory)
	}
}
