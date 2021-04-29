//
//  SampleTypeClassifier.swift
//  Speech2Query
//
//  Created by Bryan Nova on 4/29/21.
//

import Foundation

/// This will have to be retrained every time a new sample type is added but it makes the
/// outer logic much simpler than using a separate binary classifier for each sample type.
internal protocol SampleTypeClassifier {

	func classify(_ tokens: [String]) -> [Sample.Type?]
}
