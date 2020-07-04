//
//  SubSampleTypeTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Queries
import Samples

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

	@IBOutlet final var dataTypeLabel: UILabel!
	@IBOutlet final var subQueryMatcherDescriptionLabel: UILabel!

	override public final var accessibilityLabel: String? {
		get { "Data Type" }
		set {}
	}

	override public final var accessibilityValue: String? {
		get {
			guard let matcher = matcher, let sampleType = sampleType else { return nil }
			return matcher.description + " " + sampleType.name
		}
		set {}
	}
}
