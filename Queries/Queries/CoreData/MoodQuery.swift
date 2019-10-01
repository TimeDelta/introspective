//
//  MoodQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

//sourcery: AutoMockable
public protocol MoodQuery: Query {
}

public final class MoodQueryImpl: CoreDataQuery<MoodImpl>, MoodQuery {
}
