//
//  MoodExporter.swift
//  Introspective
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import DataExport

public protocol MoodExporter: Exporter {}

public final class MoodExporterImpl: RecordCSVExporter<MoodImpl>, MoodExporter {}
