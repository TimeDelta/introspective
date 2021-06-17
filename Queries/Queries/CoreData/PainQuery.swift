//
//  PainQuery.swift
//  Queries
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

// sourcery: AutoMockable
public protocol PainQuery: Query {}

public final class PainQueryImpl: CoreDataQuery<PainImpl>, PainQuery {}
