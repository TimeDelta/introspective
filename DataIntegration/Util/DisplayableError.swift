//
//  DisplayableError.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol DisplayableError: Error {

	var displayableDescription: String { get }
}
