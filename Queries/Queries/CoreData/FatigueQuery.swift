//
//  FatigueQuery.swift
//  Queries
//
//  Created by Bryan Nova on 12/9/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

// sourcery: AutoMockable
public protocol FatigueQuery: Query {}

public final class FatigueQueryImpl: CoreDataQuery<FatigueImpl>, FatigueQuery {}
