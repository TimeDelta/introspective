//
//  DeleteCoreDataTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CoreData

public final class DeleteCoreDataTableViewCell: UITableViewCell {

	@IBAction final func deleteCoreDataButtonPressed() {
		try! DependencyInjector.db.deleteAll(SettingsImpl.self)
		// doing a delete all for Activity.self or ActivityDefinition.self causes app to crash
		// also, ActivityDefinition delete rule for relationship to Activity is cascade
		let definitions = try! DependencyInjector.db.query(ActivityDefinition.fetchRequest())
		try! DependencyInjector.db.deleteAll(definitions)
		try! DependencyInjector.db.deleteAll(MoodImpl.self)
		try! DependencyInjector.db.deleteAll(Medication.self)
		try! DependencyInjector.db.deleteAll(MedicationDose.self)
		try! DependencyInjector.db.deleteAll(Tag.self)
		try! DependencyInjector.db.deleteAll(WellnessMoodImporterImpl.self)
	}
}
