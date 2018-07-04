// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Queriers/QuerierFactory.swift
//
//  QuerierFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQuerierFactory: QuerierFactory, Cuckoo.ClassMock {
    typealias MocksType = QuerierFactory
    typealias Stubbing = __StubbingProxy_QuerierFactory
    typealias Verification = __VerificationProxy_QuerierFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "heartRateQuerier", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "HeartRateQuerier", "isReadOnly": true, "accessibility": "public"]
    public override var heartRateQuerier: HeartRateQuerier {
        get {
            
            return cuckoo_manager.getter("heartRateQuerier", superclassCall: super.heartRateQuerier)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QuerierFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var heartRateQuerier: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuerierFactory, HeartRateQuerier> {
	        return .init(manager: cuckoo_manager, name: "heartRateQuerier")
	    }
	    
	    
	}

	struct __VerificationProxy_QuerierFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var heartRateQuerier: Cuckoo.VerifyReadOnlyProperty<HeartRateQuerier> {
	        return .init(manager: cuckoo_manager, name: "heartRateQuerier", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QuerierFactoryStub: QuerierFactory {
    
    public override var heartRateQuerier: HeartRateQuerier {
        get {
            return DefaultValueRegistry.defaultValue(for: (HeartRateQuerier).self)
        }
        
    }
    

    

    
}

