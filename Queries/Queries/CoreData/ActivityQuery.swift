//
//  ActivityQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

//sourcery: AutoMockable
public protocol ActivityQuery: Query {
}

public final class ActivityQueryImpl: CoreDataQuery<Activity>, ActivityQuery {
}
