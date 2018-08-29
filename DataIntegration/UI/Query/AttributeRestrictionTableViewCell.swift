//
//  AttributeRestrictionTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AttributeRestrictionTableViewCell: UITableViewCell {

	@IBOutlet weak var label: UILabel!

	public var attributeRestriction: AttributeRestriction! {
		didSet {
			guard let attributeRestriction = attributeRestriction else { return }
			label.text = attributeRestriction.description
		}
	}
}
