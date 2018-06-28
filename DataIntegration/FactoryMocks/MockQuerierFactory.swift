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

    

    

    
    // ["name": "heartRateQuerier", "returnSignature": " -> HeartRateQuerier", "fullyQualifiedName": "heartRateQuerier() -> HeartRateQuerier", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "HeartRateQuerier", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func heartRateQuerier()  -> HeartRateQuerier {
        
            return cuckoo_manager.call("heartRateQuerier() -> HeartRateQuerier",
                parameters: (),
                superclassCall:
                    
                    super.heartRateQuerier()
                    )
        
    }
    

	struct __StubbingProxy_QuerierFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func heartRateQuerier() -> Cuckoo.ClassStubFunction<(), HeartRateQuerier> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockQuerierFactory.self, method: "heartRateQuerier() -> HeartRateQuerier", parameterMatchers: matchers))
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
	
	    
	
	    
	    @discardableResult
	    func heartRateQuerier() -> Cuckoo.__DoNotUse<HeartRateQuerier> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("heartRateQuerier() -> HeartRateQuerier", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QuerierFactoryStub: QuerierFactory {
    

    

    
     override func heartRateQuerier()  -> HeartRateQuerier {
        return DefaultValueRegistry.defaultValue(for: HeartRateQuerier.self)
    }
    
}

