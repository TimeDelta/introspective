// MARK: - Mocks generated from file: DataIntegration/Questions/Question.swift
//
//  Question.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage
import os

class MockQuestion: Question, Cuckoo.ClassMock {
    typealias MocksType = Question
    typealias Stubbing = __StubbingProxy_Question
    typealias Verification = __VerificationProxy_Question
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "questionText", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": ""]
     override var questionText: String {
        get {
            
            return cuckoo_manager.getter("questionText", superclassCall: super.questionText)
            
        }
        
    }
    

    

    
    // ["name": "parse", "returnSignature": "", "fullyQualifiedName": "parse(callback: (Error?) -> ())", "parameterSignature": "callback: (Error?) -> ()", "parameterSignatureWithoutNames": "callback: (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "(Error?) -> ()", range: CountableRange(791..<815), nameRange: CountableRange(791..<799))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func parse(callback: (Error?) -> ())  {
        	return withoutActuallyEscaping(callback, do: { (callback) in

            return cuckoo_manager.call("parse(callback: (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.parse(callback: callback)
                    )
        	})

    }
    
    // ["name": "answer", "returnSignature": "", "fullyQualifiedName": "answer(callback: @escaping (Answer?, Error?) -> ())", "parameterSignature": "callback: @escaping (Answer?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Answer?, Error?) -> ()", "inputTypes": "(Answer?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Answer?, Error?) -> ()", range: CountableRange(3081..<3124), nameRange: CountableRange(3081..<3089))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func answer(callback: @escaping (Answer?, Error?) -> ())  {
        
            return cuckoo_manager.call("answer(callback: @escaping (Answer?, Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.answer(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_Question: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var questionText: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuestion, String> {
	        return .init(manager: cuckoo_manager, name: "questionText")
	    }
	    
	    
	    func parse<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Error?) -> ())> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestion.self, method: "parse(callback: (Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func answer<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Answer?, Error?) -> ())> where M1.MatchedType == (Answer?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Answer?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestion.self, method: "answer(callback: @escaping (Answer?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Question: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var questionText: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "questionText", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func parse<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("parse(callback: (Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func answer<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (Answer?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Answer?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("answer(callback: @escaping (Answer?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QuestionStub: Question {
    
     override var questionText: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    

    

    
    public override func parse(callback: (Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func answer(callback: @escaping (Answer?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

