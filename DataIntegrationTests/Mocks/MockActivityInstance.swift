// MARK: - Mocks generated from file: DataIntegration/DataTypes/ActivityInstance.swift
//
//  ActivityInstance.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivityInstance: ActivityInstance, Cuckoo.ClassMock {
    typealias MocksType = ActivityInstance
    typealias Stubbing = __StubbingProxy_ActivityInstance
    typealias Verification = __VerificationProxy_ActivityInstance
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "activity", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Activity", "isReadOnly": false, "accessibility": ""]
     override var activity: Activity {
        get {
            
            return cuckoo_manager.getter("activity", superclassCall: super.activity)
            
        }
        
        set {
            
            cuckoo_manager.setter("activity", value: newValue, superclassCall: super.activity = newValue)
            
        }
        
    }
    
    // ["name": "startTimestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var startTimestamp: Date {
        get {
            
            return cuckoo_manager.getter("startTimestamp", superclassCall: super.startTimestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("startTimestamp", value: newValue, superclassCall: super.startTimestamp = newValue)
            
        }
        
    }
    
    // ["name": "endTimestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var endTimestamp: Date {
        get {
            
            return cuckoo_manager.getter("endTimestamp", superclassCall: super.endTimestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("endTimestamp", value: newValue, superclassCall: super.endTimestamp = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_ActivityInstance: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var activity: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Activity> {
	        return .init(manager: cuckoo_manager, name: "activity")
	    }
	    
	    var startTimestamp: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Date> {
	        return .init(manager: cuckoo_manager, name: "startTimestamp")
	    }
	    
	    var endTimestamp: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Date> {
	        return .init(manager: cuckoo_manager, name: "endTimestamp")
	    }
	    
	    
	}

	struct __VerificationProxy_ActivityInstance: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var activity: Cuckoo.VerifyProperty<Activity> {
	        return .init(manager: cuckoo_manager, name: "activity", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startTimestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "startTimestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endTimestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "endTimestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class ActivityInstanceStub: ActivityInstance {
    
     override var activity: Activity {
        get {
            return DefaultValueRegistry.defaultValue(for: (Activity).self)
        }
        
        set { }
        
    }
    
     override var startTimestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    
     override var endTimestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    

    

    
}

