//
//  ActiveExportTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DataExport
import DependencyInjection

public final class ActiveExportTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var cancelButton: UIButton!
	@IBOutlet final var descriptionLabel: UILabel!
	@IBOutlet final var progressView: UIProgressView!
	@IBOutlet final var percentLabel: UILabel!
	@IBOutlet final var toolbar: UIToolbar!

	// MARK: - Instance Variables

	public final var backgroundTaskId: UIBackgroundTaskIdentifier!
	public final var exporter: Exporter! {
		didSet {
			guard let exporter = exporter else { return }
			descriptionLabel.text = exporter.dataTypePluralName
			updateProgress()
			setTimer()
			observe(selector: #selector(exportFinished), name: .backgroundExportFinished, object: exporter)
		}
	}

	private final var timer: Timer!
	private final let log = Log()

	// MARK: - UITableViewCell Overrides

	public final override func prepareForReuse() {
		DependencyInjector.get(UiUtil.self).setButton(cancelButton, enabled: true, hidden: false)
		toolbar.isHidden = true
		if let exporter = exporter {
			DependencyInjector.get(UiUtil.self).stopObserving(self, name: .backgroundExportFinished, object: exporter)
		}
	}

	// MARK: - Actions

	@IBAction final func cancelExport(_: Any) {
		DependencyInjector.get(UiUtil.self).setButton(cancelButton, enabled: false, hidden: false)
		let alert = UIAlertController(
			title: "Cancel \(descriptionLabel.text!) export?",
			message: nil,
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			self.timer?.invalidate()
			self.post(.cancelBackgroundTask, userInfo: [.backgroundTaskId: String(self.backgroundTaskId.rawValue)])
		})
		alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
			DependencyInjector.get(UiUtil.self).setButton(self.cancelButton, enabled: true, hidden: false)
		})
		post(.presentView, userInfo: [.controller: alert])
	}

	@IBAction final func share(_: Any) {
		post(.shareExportFile, userInfo: [.backgroundTaskId: backgroundTaskId])
	}

	// MARK: - Received Notifications

	@objc private final func exportFinished(notification _: Notification) {
		DependencyInjector.get(UiUtil.self).setButton(cancelButton, enabled: false, hidden: false)
		toolbar.isHidden = false
	}

	// MARK: - Helper Functions

	@objc private final func updateProgress() {
		let percentComplete = exporter.percentComplete()
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
			repeats: true
		)
	}
}
