//
//  SampleTypeClassifierFactory.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/29/21.
//

import Foundation

internal protocol SampleTypeClassifierFactory {

	func getModel() -> SampleTypeClassifier
}

internal class SampleTypeClassifierFactoryImpl: SampleTypeClassifierFactory {

	func getModel() -> SampleTypeClassifier {

	}
}
