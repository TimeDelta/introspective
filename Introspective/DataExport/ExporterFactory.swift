//
//  ExporterFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol ExporterFactory {

	func activityExporter() throws -> ActivityExporter
	func medicationExporter() throws -> MedicationExporter
	func moodExporter() throws -> MoodExporter
}

public final class ExporterFactoryImpl: ExporterFactory {

	public final func activityExporter() throws -> ActivityExporter {
		return try ActivityExporterImpl()
	}

	public final func medicationExporter() throws -> MedicationExporter {
		return try MedicationExporterImpl()
	}

	public final func moodExporter() throws -> MoodExporter {
		return try MoodExporterImpl()
	}
}
