// MARK: - Mocks generated from file: DataIntegration/Util/UtilFactory.swift
//
//  UtilFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockUtilFactory: UtilFactory, Cuckoo.ClassMock {
    typealias MocksType = UtilFactory
    typealias Stubbing = __StubbingProxy_UtilFactory
    typealias Verification = __VerificationProxy_UtilFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "calendarUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "CalendarUtil", "isReadOnly": true, "accessibility": "public"]
    public override var calendarUtil: CalendarUtil {
        get {
            
            return cuckoo_manager.getter("calendarUtil", superclassCall: super.calendarUtil)
            
        }
        
    }
    
    // ["name": "hkQuantitySampleUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "HKQuantitySampleUtil", "isReadOnly": true, "accessibility": "public"]
    public override var hkQuantitySampleUtil: HKQuantitySampleUtil {
        get {
            
            return cuckoo_manager.getter("hkQuantitySampleUtil", superclassCall: super.hkQuantitySampleUtil)
            
        }
        
    }
    
    // ["name": "hkSampleUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "HKSampleUtil", "isReadOnly": true, "accessibility": "public"]
    public override var hkSampleUtil: HKSampleUtil {
        get {
            
            return cuckoo_manager.getter("hkSampleUtil", superclassCall: super.hkSampleUtil)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_UtilFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var calendarUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, CalendarUtil> {
	        return .init(manager: cuckoo_manager, name: "calendarUtil")
	    }
	    
	    var hkQuantitySampleUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, HKQuantitySampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkQuantitySampleUtil")
	    }
	    
	    var hkSampleUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, HKSampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkSampleUtil")
	    }
	    
	    
	}

	struct __VerificationProxy_UtilFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var calendarUtil: Cuckoo.VerifyReadOnlyProperty<CalendarUtil> {
	        return .init(manager: cuckoo_manager, name: "calendarUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var hkQuantitySampleUtil: Cuckoo.VerifyReadOnlyProperty<HKQuantitySampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkQuantitySampleUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var hkSampleUtil: Cuckoo.VerifyReadOnlyProperty<HKSampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkSampleUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class UtilFactoryStub: UtilFactory {
    
    public override var calendarUtil: CalendarUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (CalendarUtil).self)
        }
        
    }
    
    public override var hkQuantitySampleUtil: HKQuantitySampleUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (HKQuantitySampleUtil).self)
        }
        
    }
    
    public override var hkSampleUtil: HKSampleUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (HKSampleUtil).self)
        }
        
    }
    

    

    
}

