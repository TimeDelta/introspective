//
//  Importable.swift
//  Introspective
//
//  Created by Bryan Nova on 12/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Importable {

	var partOfCurrentImport: Bool { get set }
}
