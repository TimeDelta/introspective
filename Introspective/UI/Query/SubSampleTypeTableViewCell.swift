//
//  SubSampleTypeTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class SubSampleTypeTableViewCell: UITableViewCell {

	public final var matcher: SubQueryMatcher! {
		didSet {
			guard let matcher = matcher else { return }
			subQueryMatcherDescriptionLabel.text = matcher.description
		}
	}

	public final var sampleType: Sample.Type! {
		didSet {
			guard let sampleType = sampleType else { return }
			dataTypeLabel.text = sampleType.name
		}
	}

	@IBOutlet weak final var dataTypeLabel: UILabel!
	@IBOutlet weak final var subQueryMatcherDescriptionLabel: UILabel!
}
