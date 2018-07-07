//
//  RestrictionParserFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class RestrictionParserFactory {

	fileprivate typealias Me = RestrictionParserFactory

	fileprivate static let realDayOfWeekRestrictionParser = DayOfWeekRestrictionParser()

	public var dayOfWeekRestrictionParser: DayOfWeekRestrictionParser { get { return Me.realDayOfWeekRestrictionParser } }
}
