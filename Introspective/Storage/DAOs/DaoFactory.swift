//
//  DaoFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 8/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol DaoFactory {

	func activityDao() -> ActivityDao
}

public class DaoFactoryImpl: DaoFactory {

	public final func activityDao() -> ActivityDao {
		return ActivityDaoImpl()
	}
}
