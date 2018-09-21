//
//  ResultOperationTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ExtraInformationTableViewCell: UITableViewCell {

	public final var extraInformation: ExtraInformation! { didSet { updateText() } }

	public final var value: String! { didSet { updateText() } }

	@IBOutlet weak final var keyValueLabel: UILabel!

	private final func updateText() {
		if value == nil || extraInformation == nil { return }
		keyValueLabel.text = extraInformation.description.localizedCapitalized + ": " + value
	}
}
