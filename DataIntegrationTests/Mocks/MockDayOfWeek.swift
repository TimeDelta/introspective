// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/DayOfWeek.swift
//
//  DayOfWeek.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockDayOfWeek: DayOfWeek, Cuckoo.ClassMock {
    typealias MocksType = DayOfWeek
    typealias Stubbing = __StubbingProxy_DayOfWeek
    typealias Verification = __VerificationProxy_DayOfWeek
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "fullDayName", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var fullDayName: String {
        get {
            
            return cuckoo_manager.getter("fullDayName", superclassCall: super.fullDayName)
            
        }
        
    }
    
    // ["name": "intValue", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Int", "isReadOnly": true, "accessibility": "public"]
    public override var intValue: Int {
        get {
            
            return cuckoo_manager.getter("intValue", superclassCall: super.intValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_DayOfWeek: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var fullDayName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockDayOfWeek, String> {
	        return .init(manager: cuckoo_manager, name: "fullDayName")
	    }
	    
	    var intValue: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockDayOfWeek, Int> {
	        return .init(manager: cuckoo_manager, name: "intValue")
	    }
	    
	    
	}

	struct __VerificationProxy_DayOfWeek: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var fullDayName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "fullDayName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var intValue: Cuckoo.VerifyReadOnlyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "intValue", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class DayOfWeekStub: DayOfWeek {
    
    public override var fullDayName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var intValue: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
    }
    

    

    
}

