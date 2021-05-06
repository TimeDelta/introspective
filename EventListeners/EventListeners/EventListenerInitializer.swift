//
//  EventListenerInitializer.swift
//  EventListeners
//
//  Created by Bryan Nova on 5/6/21.
//

import Foundation

// sourcery: AutoMockable
/// For handling event listeners that don't have a natural home (i.e. in a view controller)
public protocol EventListenerInitializer {
	/// Performs setup for all event listeners
	func setUpListeners()
}

class EventListenerInitializerImpl: EventListenerInitializer {
	private final let eventListeners: [EventListener] = [
		SuicidalMoodNoteListener(),
	]

	func setUpListeners() {
		for listener in eventListeners {
			listener.observe()
		}
	}
}
