//
//  SearchableSample.swift
//  Samples
//
//  Created by Bryan Nova on 6/14/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SearchableSample: Sample {
	func matchesSearchString(_ searchString: String) -> Bool
}
