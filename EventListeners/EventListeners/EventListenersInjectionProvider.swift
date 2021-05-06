//
//  EventListenersInjectionProvider.swift
//  EventListeners
//
//  Created by Bryan Nova on 5/6/21.
//

import Foundation

import Common
import DependencyInjection

public class EventListenersInjectionProvider: InjectionProvider {
	private typealias Me = EventListenersInjectionProvider
	private static let eventListenerInitializer = EventListenerInitializerImpl()

	public let types: [Any.Type] = [
		EventListenerInitializer.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is EventListenerInitializer.Protocol:
			return Me.eventListenerInitializer as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
