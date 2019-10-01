//
//  GroupDefinitionTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import SampleGroupers

public final class GroupDefinitionTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var nameLabel: UILabel!
	@IBOutlet weak final var descriptionLabel: UILabel!

	// MARK: - Instance Variables

	public final var groupDefinition: GroupDefinition! {
		didSet {
			guard let groupDefinition = groupDefinition else { return }
			nameLabel.text = groupDefinition.name
			descriptionLabel.text = groupDefinition.description
		}
	}
}
