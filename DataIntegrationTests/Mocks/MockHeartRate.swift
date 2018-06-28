// MARK: - Mocks generated from file: DataIntegration/DataTypes/HeartRate.swift
//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockHeartRate: HeartRate, Cuckoo.ClassMock {
    typealias MocksType = HeartRate
    typealias Stubbing = __StubbingProxy_HeartRate
    typealias Verification = __VerificationProxy_HeartRate
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "value", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": ""]
     override var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
        set {
            
            cuckoo_manager.setter("value", value: newValue, superclassCall: super.value = newValue)
            
        }
        
    }
    
    // ["name": "timestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var timestamp: Date {
        get {
            
            return cuckoo_manager.getter("timestamp", superclassCall: super.timestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("timestamp", value: newValue, superclassCall: super.timestamp = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_HeartRate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var value: Cuckoo.ClassToBeStubbedProperty<MockHeartRate, Double> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    var timestamp: Cuckoo.ClassToBeStubbedProperty<MockHeartRate, Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp")
	    }
	    
	    
	}

	struct __VerificationProxy_HeartRate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var value: Cuckoo.VerifyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var timestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class HeartRateStub: HeartRate {
    
     override var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    
     override var timestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    

    

    
}

