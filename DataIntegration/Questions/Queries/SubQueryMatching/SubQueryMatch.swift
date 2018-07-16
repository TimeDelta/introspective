//
//  SubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SubQueryMatch: CustomStringConvertible {

	func getSamples<SampleType: Sample>(from: [SampleType], matching: [SampleType]) -> [SampleType]
}
