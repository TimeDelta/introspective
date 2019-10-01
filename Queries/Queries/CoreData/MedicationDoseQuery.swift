//
//  MedicationDoseQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

//sourcery: AutoMockable
public protocol MedicationDoseQuery: Query {
}

public final class MedicationDoseQueryImpl: CoreDataQuery<MedicationDose>, MedicationDoseQuery {
}
