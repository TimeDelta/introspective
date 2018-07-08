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

	var attributeRestriction: AttributeRestriction! {
		didSet {
			label.text = attributeRestriction.description
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
