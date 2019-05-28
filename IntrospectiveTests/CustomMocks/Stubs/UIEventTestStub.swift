//
//  UIEventTestStub.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import UIKit

public final class UIEventTestStub: UIEvent {

	public final var touches: Set<UITouch>?
	public final override var allTouches: Set<UITouch>? {
		get { return touches }
	}
}
