//
//  AttributeRestrictionTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class AttributeRestrictionTableViewCell: UITableViewCell {

	@IBOutlet weak final var label: UILabel!

	public final var attributeRestriction: AttributeRestriction! {
		didSet {
			guard let attributeRestriction = attributeRestriction else { return }
			label.text = attributeRestriction.description
		}
	}
}
