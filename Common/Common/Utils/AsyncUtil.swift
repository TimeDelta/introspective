//
//  AsyncUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 8/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol AsyncUtil {

	func run(qos: DispatchQoS.QoSClass, code: @escaping () -> Void)
}

public final class AsyncUtilImpl: AsyncUtil {

	public final func run(qos: DispatchQoS.QoSClass, code: @escaping () -> Void) {
		DispatchQueue.global(qos: qos).async { code() }
	}
}
