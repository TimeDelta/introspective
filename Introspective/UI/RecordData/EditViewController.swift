//
//  EditViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/3/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

public protocol EditViewController: UIViewController {
	/// If nil, no notification will be sent
	var notificationToSendOnAccept: Notification.Name? { get set }
	var indexPath: IndexPath? { get set }
}
