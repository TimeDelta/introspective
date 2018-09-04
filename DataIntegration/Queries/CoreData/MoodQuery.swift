//
//  MoodQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol MoodQuery: Query {

	static var updatingMoodsInBackground: Bool { get set }
}

public final class MoodQueryImpl: CoreDataQuery<MoodImpl>, MoodQuery {

	public static var updatingMoodsInBackground: Bool = false
}
