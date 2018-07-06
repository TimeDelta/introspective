//
//  CalendarComponentMatchables.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import Cuckoo

class Matchers {

	public static func any<Class>() -> ParameterMatcher<Class> {
		return ParameterMatcher { tested in
			return true
		}
	}
}
