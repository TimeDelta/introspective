//
//  IntentHandler.swift
//  Introspective
//
//  Created by Bryan Nova on 7/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public class IntentHandler: NSObject {

	public final func errorDescription(_ error: DisplayableError) -> String {
		var result = error.displayableTitle
		if let description = error.displayableDescription {
			result += ": " + description
		}
		return result
	}
}
