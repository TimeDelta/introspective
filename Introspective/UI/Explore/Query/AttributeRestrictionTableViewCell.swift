//
//  AttributeRestrictionTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 7/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import AttributeRestrictions

final class AttributeRestrictionTableViewCell: UITableViewCell {
	public final var attributeRestriction: AttributeRestriction! {
		didSet {
			guard let attributeRestriction = attributeRestriction else { return }
			textLabel?.text = attributeRestriction.description
		}
	}

	public final override var accessibilityLabel: String? {
		get { attributeRestriction?.attributedName }
		set {}
	}

	public final override var accessibilityValue: String? {
		get { attributeRestriction?.description }
		set {}
	}
}
