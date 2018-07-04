// MARK: - Mocks generated from file: DataIntegration/Questions/QuestionFactory.swift
//
//  QuestionFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQuestionFactory: QuestionFactory, Cuckoo.ClassMock {
    typealias MocksType = QuestionFactory
    typealias Stubbing = __StubbingProxy_QuestionFactory
    typealias Verification = __VerificationProxy_QuestionFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "question", "returnSignature": " -> Question", "fullyQualifiedName": "question(text: String) -> Question", "parameterSignature": "text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "text", "call": "text: text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("text"), name: "text", type: "String", range: CountableRange(225..<237), nameRange: CountableRange(225..<229))], "returnType": "Question", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func question(text: String)  -> Question {
        
            return cuckoo_manager.call("question(text: String) -> Question",
                parameters: (text),
                superclassCall:
                    
                    super.question(text: text)
                    )
        
    }
    
    // ["name": "answer", "returnSignature": " -> Answer", "fullyQualifiedName": "answer() -> Answer", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Answer", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func answer()  -> Answer {
        
            return cuckoo_manager.call("answer() -> Answer",
                parameters: (),
                superclassCall:
                    
                    super.answer()
                    )
        
    }
    
    // ["name": "labels", "returnSignature": " -> Labels", "fullyQualifiedName": "labels() -> Labels", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Labels", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func labels()  -> Labels {
        
            return cuckoo_manager.call("labels() -> Labels",
                parameters: (),
                superclassCall:
                    
                    super.labels()
                    )
        
    }
    

	struct __StubbingProxy_QuestionFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func question<M1: Cuckoo.Matchable>(text: M1) -> Cuckoo.ClassStubFunction<(String), Question> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestionFactory.self, method: "question(text: String) -> Question", parameterMatchers: matchers))
	    }
	    
	    func answer() -> Cuckoo.ClassStubFunction<(), Answer> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestionFactory.self, method: "answer() -> Answer", parameterMatchers: matchers))
	    }
	    
	    func labels() -> Cuckoo.ClassStubFunction<(), Labels> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestionFactory.self, method: "labels() -> Labels", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_QuestionFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func question<M1: Cuckoo.Matchable>(text: M1) -> Cuckoo.__DoNotUse<Question> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("question(text: String) -> Question", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func answer() -> Cuckoo.__DoNotUse<Answer> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("answer() -> Answer", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labels() -> Cuckoo.__DoNotUse<Labels> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("labels() -> Labels", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QuestionFactoryStub: QuestionFactory {
    

    

    
     override func question(text: String)  -> Question {
        return DefaultValueRegistry.defaultValue(for: Question.self)
    }
    
     override func answer()  -> Answer {
        return DefaultValueRegistry.defaultValue(for: Answer.self)
    }
    
     override func labels()  -> Labels {
        return DefaultValueRegistry.defaultValue(for: Labels.self)
    }
    
}

