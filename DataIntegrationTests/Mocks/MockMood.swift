// MARK: - Mocks generated from file: DataIntegration/DataTypes/Mood.swift
//
//  Mood.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockMood: Mood, Cuckoo.ClassMock {
    typealias MocksType = Mood
    typealias Stubbing = __StubbingProxy_Mood
    typealias Verification = __VerificationProxy_Mood
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "timestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var timestamp: Date {
        get {
            
            return cuckoo_manager.getter("timestamp", superclassCall: super.timestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("timestamp", value: newValue, superclassCall: super.timestamp = newValue)
            
        }
        
    }
    
    // ["name": "rating", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": ""]
     override var rating: Double {
        get {
            
            return cuckoo_manager.getter("rating", superclassCall: super.rating)
            
        }
        
        set {
            
            cuckoo_manager.setter("rating", value: newValue, superclassCall: super.rating = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Mood: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var timestamp: Cuckoo.ClassToBeStubbedProperty<MockMood, Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp")
	    }
	    
	    var rating: Cuckoo.ClassToBeStubbedProperty<MockMood, Double> {
	        return .init(manager: cuckoo_manager, name: "rating")
	    }
	    
	    
	}

	struct __VerificationProxy_Mood: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var timestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var rating: Cuckoo.VerifyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "rating", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class MoodStub: Mood {
    
     override var timestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    
     override var rating: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    

    

    
}

