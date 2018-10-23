//
//  DeleteCoreDataTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class DeleteCoreDataTableViewCell: UITableViewCell {

	@IBAction final func deleteCoreDataButtonPressed() {
		try! DependencyInjector.db.deleteAll(SettingsImpl.self)
		try! DependencyInjector.db.deleteAll(MoodImpl.self)
		try! DependencyInjector.db.deleteAll(Medication.self)
		try! DependencyInjector.db.deleteAll(MedicationDose.self)
		try! DependencyInjector.db.deleteAll(WellnessMoodImporterImpl.self)
	}
}
