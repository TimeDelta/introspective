//
//  MoodQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class MoodQuery: CoreDataQuery<MoodImpl> {

	public init() {
		super.init(dataType: .mood)
	}
}
