//
//  MoodQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol MoodQuery: Query {}

public class MoodQueryImpl: CoreDataQuery<MoodImpl>, MoodQuery {

	public init() {
		super.init(dataType: .mood)
	}
}
