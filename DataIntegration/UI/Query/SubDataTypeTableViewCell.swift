//
//  SubDataTypeTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class SubDataTypeTableViewCell: UITableViewCell {

	public final var matcher: SubQueryMatcher! {
		didSet {
			guard let matcher = matcher else { return }
			subQueryMatcherDescriptionLabel.text = matcher.description
		}
	}

	public final var dataType: DataTypes! {
		didSet {
			guard let dataType = dataType else { return }
			dataTypeLabel.text = dataType.description
		}
	}

	@IBOutlet weak final var dataTypeLabel: UILabel!
	@IBOutlet weak final var subQueryMatcherDescriptionLabel: UILabel!
}
