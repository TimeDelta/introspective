// MARK: - Mocks generated from file: DataIntegration/DataTypes/Activity.swift
//
//  Activity.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivity: Activity, Cuckoo.ClassMock {
    typealias MocksType = Activity
    typealias Stubbing = __StubbingProxy_Activity
    typealias Verification = __VerificationProxy_Activity
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": ""]
     override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "tags", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "NSArray", "isReadOnly": false, "accessibility": ""]
     override var tags: NSArray {
        get {
            
            return cuckoo_manager.getter("tags", superclassCall: super.tags)
            
        }
        
        set {
            
            cuckoo_manager.setter("tags", value: newValue, superclassCall: super.tags = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Activity: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockActivity, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var tags: Cuckoo.ClassToBeStubbedProperty<MockActivity, NSArray> {
	        return .init(manager: cuckoo_manager, name: "tags")
	    }
	    
	    
	}

	struct __VerificationProxy_Activity: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var tags: Cuckoo.VerifyProperty<NSArray> {
	        return .init(manager: cuckoo_manager, name: "tags", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class ActivityStub: Activity {
    
     override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
     override var tags: NSArray {
        get {
            return DefaultValueRegistry.defaultValue(for: (NSArray).self)
        }
        
        set { }
        
    }
    

    

    
}

