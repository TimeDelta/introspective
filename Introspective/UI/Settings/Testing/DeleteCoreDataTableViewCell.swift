//
//  DeleteCoreDataTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CoreData

import DependencyInjection
import Persistence

public final class DeleteCoreDataTableViewCell: UITableViewCell {

	@IBAction final func deleteCoreDataButtonPressed() {
		try! DependencyInjector.get(Database.self).deleteEverything()
	}
}
