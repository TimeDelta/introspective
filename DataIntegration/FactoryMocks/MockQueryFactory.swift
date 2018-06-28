// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QueryFactory.swift
//
//  QueryFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQueryFactory: QueryFactory, Cuckoo.ClassMock {
    typealias MocksType = QueryFactory
    typealias Stubbing = __StubbingProxy_QueryFactory
    typealias Verification = __VerificationProxy_QueryFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "heartRateQuery", "returnSignature": " -> HeartRateQuery", "fullyQualifiedName": "heartRateQuery() -> HeartRateQuery", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "HeartRateQuery", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func heartRateQuery()  -> HeartRateQuery {
        
            return cuckoo_manager.call("heartRateQuery() -> HeartRateQuery",
                parameters: (),
                superclassCall:
                    
                    super.heartRateQuery()
                    )
        
    }
    

	struct __StubbingProxy_QueryFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func heartRateQuery() -> Cuckoo.ClassStubFunction<(), HeartRateQuery> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockQueryFactory.self, method: "heartRateQuery() -> HeartRateQuery", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_QueryFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func heartRateQuery() -> Cuckoo.__DoNotUse<HeartRateQuery> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("heartRateQuery() -> HeartRateQuery", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QueryFactoryStub: QueryFactory {
    

    

    
    public override func heartRateQuery()  -> HeartRateQuery {
        return DefaultValueRegistry.defaultValue(for: HeartRateQuery.self)
    }
    
}

