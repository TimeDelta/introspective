// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QuantityRestriction.swift
//
//  QuantityRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQuantityRestriction: QuantityRestriction, Cuckoo.ClassMock {
    typealias MocksType = QuantityRestriction
    typealias Stubbing = __StubbingProxy_QuantityRestriction
    typealias Verification = __VerificationProxy_QuantityRestriction
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "attribute", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var attribute: String {
        get {
            
            return cuckoo_manager.getter("attribute", superclassCall: super.attribute)
            
        }
        
    }
    
    // ["name": "comparison", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "NSComparisonPredicate.Operator", "isReadOnly": true, "accessibility": "public"]
    public override var comparison: NSComparisonPredicate.Operator {
        get {
            
            return cuckoo_manager.getter("comparison", superclassCall: super.comparison)
            
        }
        
    }
    
    // ["name": "value", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "ValueType", "isReadOnly": true, "accessibility": "public"]
    public override var value: ValueType {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QuantityRestriction: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var attribute: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, String> {
	        return .init(manager: cuckoo_manager, name: "attribute")
	    }
	    
	    var comparison: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, NSComparisonPredicate.Operator> {
	        return .init(manager: cuckoo_manager, name: "comparison")
	    }
	    
	    var value: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, ValueType> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    
	}

	struct __VerificationProxy_QuantityRestriction: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var attribute: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "attribute", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var comparison: Cuckoo.VerifyReadOnlyProperty<NSComparisonPredicate.Operator> {
	        return .init(manager: cuckoo_manager, name: "comparison", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var value: Cuckoo.VerifyReadOnlyProperty<ValueType> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QuantityRestrictionStub: QuantityRestriction {
    
    public override var attribute: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var comparison: NSComparisonPredicate.Operator {
        get {
            return DefaultValueRegistry.defaultValue(for: (NSComparisonPredicate.Operator).self)
        }
        
    }
    
    public override var value: ValueType {
        get {
            return DefaultValueRegistry.defaultValue(for: (ValueType).self)
        }
        
    }
    

    

    
}

