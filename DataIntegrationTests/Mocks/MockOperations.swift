// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Operations.swift
//
//  Operations.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockOperations: Operations, Cuckoo.ClassMock {
    typealias MocksType = Operations
    typealias Stubbing = __StubbingProxy_Operations
    typealias Verification = __VerificationProxy_Operations
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "stringRepresenation", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": ""]
     override var stringRepresenation: String {
        get {
            
            return cuckoo_manager.getter("stringRepresenation", superclassCall: super.stringRepresenation)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Operations: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var stringRepresenation: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockOperations, String> {
	        return .init(manager: cuckoo_manager, name: "stringRepresenation")
	    }
	    
	    
	}

	struct __VerificationProxy_Operations: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var stringRepresenation: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "stringRepresenation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class OperationsStub: Operations {
    
     override var stringRepresenation: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    

    

    
}

