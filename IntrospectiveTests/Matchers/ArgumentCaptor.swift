////
////  ArgumentCaptor.swift
////  IntrospectiveTests
////
////  Created by Bryan Nova on 4/15/19.
////  Copyright © 2019 Bryan Nova. All rights reserved.
////
//
//import Foundation
//import SwiftyMocky
//
//public class ArgumentCaptor<Type> {
//	/// Defines which values will be captured
//	public enum CaptureBehavior {
//		/// Always record passed value
//		case allValues
//		/// Only record passed value when captured parameter matches
//		case onlyMatchedValues
//		/// Only record passed value when captured parameter matches AND all parameters to the left of it matched
//		case onlyMatchedValuesIfPreviousParametersMatch
//	}
//
//	/// Last captured value (if any)
//	public var value: Type? {
//		return allValues.last
//	}
//	/// All captured values
//	public private(set) var allValues = [Type]()
//
//	private var behavior: Behavior
//
//	public convenience init() {
//		self.init(.onlyMatchedValues)
//	}
//
//	public init(_ behavior: Behavior) {
//		self.behavior = behavior
//	}
//
//	/// Return parameter matcher which captures the argument.
//	public func capture(where matchFunction: ((Type) -> Bool)? = nil) -> Parameter<Type> {
//		return .matching({ (value: Type, allPreviousMatch: Bool) -> Bool in
//			if let matchFunction = matchFunction {
//				let matches = matchFunction(value)
//				self.appendValueAccordingToBehavior(value, matches: matches, allPreviousMatch: allPreviousMatch)
//				return matches
//			}
//			self.appendValueAccordingToBehavior(value, matches: matches, allPreviousMatch: allPreviousMatch)
//			return true
//		})
//	}
//
//	private func appendValueAccordingToBehavior(_ value: Type, matches: Bool, allPreviousMatch: Bool) {
//		switch behavior {
//		case .allValues:
//			allValues.append(value)
//			break
//		case .onlyMatchedValues:
//			if matches {
//				allValues.append(value)
//			}
//			break
//		case .onlyMatchedValuesIfPreviousParametersMatch:
//			if matches && allPreviousMatch {
//				allValues.append(value)
//			}
//			break
//		}
//	}
//}
