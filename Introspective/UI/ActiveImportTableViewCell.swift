//
//  ActiveImportTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/13/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DataImport
import DependencyInjection

public final class ActiveImportTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var cancelButton: UIButton!
	@IBOutlet weak final var descriptionLabel: UILabel!
	@IBOutlet weak final var progressView: UIProgressView!
	@IBOutlet weak final var percentLabel: UILabel!

	// MARK: - Instance Variables

	public final var backgroundTaskId: UIBackgroundTaskIdentifier!
	public final var importer: Importer! {
		didSet {
			guard let importer = importer else { return }
			descriptionLabel.text = importer.sourceName + " " + importer.dataTypePluralName
			updateProgress()
			setTimer()
		}
	}

	private final var timer: Timer!
	private final let log = Log()

	// MARK: - UITableViewCell Overrides

	public final override func prepareForReuse() {
		DependencyInjector.get(UiUtil.self).setButton(self.cancelButton, enabled: true, hidden: false)
	}

	// MARK: - Actions

	@IBAction final func cancelImport(_ sender: Any) {
		DependencyInjector.get(UiUtil.self).setButton(cancelButton, enabled: false, hidden: false)
		let alert = UIAlertController(
			title: "Cancel \(descriptionLabel.text!) import?",
			message: nil,
			preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			self.timer?.invalidate()
			self.post(.cancelBackgroundTask, userInfo: [.backgroundTaskId: String(self.backgroundTaskId.rawValue)])
		})
		alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
			DependencyInjector.get(UiUtil.self).setButton(self.cancelButton, enabled: true, hidden: false)
		})
		post(.presentView, object: importer, userInfo: [.controller: alert])
	}

	// MARK: - Helper Functions

	@objc private final func updateProgress() {
		let percentComplete = importer.percentComplete()
		progressView.progress = Float(percentComplete)
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .percent
		numberFormatter.formatWidth = 3
		if let percentString = numberFormatter.string(from: NSNumber(value: percentComplete)) {
			percentLabel.text = percentString
		} else {
			log.error("Unable to convert %f to string", percentComplete * 100)
		}
		if progressView.progress == 1 {
			timer?.invalidate()
		}
	}

	private final func setTimer() {
		timer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: #selector(updateProgress),
			userInfo: nil,
			repeats: true)
	}
}
