//
//  ResultOperationTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import SampleGroupInformation

final class SampleGroupInformationTableViewCell: UITableViewCell {

	public final var sampleGroupInformation: SampleGroupInformation! { didSet { updateText() } }

	public final var value: String! { didSet { updateText() } }

	@IBOutlet weak final var keyValueLabel: UILabel!

	private final func updateText() {
		if value == nil || sampleGroupInformation == nil { return }
		keyValueLabel.text = sampleGroupInformation.description.localizedCapitalized + ": " + value
	}
}
