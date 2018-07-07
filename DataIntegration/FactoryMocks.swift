// MARK: - Mocks generated from file: DataIntegration/DataTypes/DataTypesFactory.swift
//
//  DataTypesFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation

class MockDataTypesFactory: DataTypesFactory, Cuckoo.ClassMock {
    typealias MocksType = DataTypesFactory
    typealias Stubbing = __StubbingProxy_DataTypesFactory
    typealias Verification = __VerificationProxy_DataTypesFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "activity", "returnSignature": " -> Activity", "fullyQualifiedName": "activity() -> Activity", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Activity", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func activity()  -> Activity {
        
            return cuckoo_manager.call("activity() -> Activity",
                parameters: (),
                superclassCall:
                    
                    super.activity()
                    )
        
    }
    
    // ["name": "activityInstance", "returnSignature": " -> ActivityInstance", "fullyQualifiedName": "activityInstance(activity: Activity) -> ActivityInstance", "parameterSignature": "activity: Activity", "parameterSignatureWithoutNames": "activity: Activity", "inputTypes": "Activity", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "activity", "call": "activity: activity", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("activity"), name: "activity", type: "Activity", range: CountableRange(283..<301), nameRange: CountableRange(283..<291))], "returnType": "ActivityInstance", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func activityInstance(activity: Activity)  -> ActivityInstance {
        
            return cuckoo_manager.call("activityInstance(activity: Activity) -> ActivityInstance",
                parameters: (activity),
                superclassCall:
                    
                    super.activityInstance(activity: activity)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(value: Double) -> HeartRate", "parameterSignature": "value: Double", "parameterSignatureWithoutNames": "value: Double", "inputTypes": "Double", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "value", "call": "value: value", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("value"), name: "value", type: "Double", range: CountableRange(391..<404), nameRange: CountableRange(391..<396))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func heartRate(value: Double)  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(value: Double) -> HeartRate",
                parameters: (value),
                superclassCall:
                    
                    super.heartRate(value: value)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(value: Double, timestamp: Date) -> HeartRate", "parameterSignature": "value: Double, timestamp: Date", "parameterSignatureWithoutNames": "value: Double, timestamp: Date", "inputTypes": "Double, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "value, timestamp", "call": "value: value, timestamp: timestamp", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("value"), name: "value", type: "Double", range: CountableRange(474..<487), nameRange: CountableRange(474..<479)), CuckooGeneratorFramework.MethodParameter(label: Optional("timestamp"), name: "timestamp", type: "Date", range: CountableRange(489..<504), nameRange: CountableRange(489..<498))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func heartRate(value: Double, timestamp: Date)  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(value: Double, timestamp: Date) -> HeartRate",
                parameters: (value, timestamp),
                superclassCall:
                    
                    super.heartRate(value: value, timestamp: timestamp)
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood() -> Mood", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func mood()  -> Mood {
        
            return cuckoo_manager.call("mood() -> Mood",
                parameters: (),
                superclassCall:
                    
                    super.mood()
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood(rating: Double) -> Mood", "parameterSignature": "rating: Double", "parameterSignatureWithoutNames": "rating: Double", "inputTypes": "Double", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "rating", "call": "rating: rating", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("rating"), name: "rating", type: "Double", range: CountableRange(634..<648), nameRange: CountableRange(634..<640))], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func mood(rating: Double)  -> Mood {
        
            return cuckoo_manager.call("mood(rating: Double) -> Mood",
                parameters: (rating),
                superclassCall:
                    
                    super.mood(rating: rating)
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood(timestamp: Date) -> Mood", "parameterSignature": "timestamp: Date", "parameterSignatureWithoutNames": "timestamp: Date", "inputTypes": "Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "timestamp", "call": "timestamp: timestamp", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("timestamp"), name: "timestamp", type: "Date", range: CountableRange(705..<720), nameRange: CountableRange(705..<714))], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func mood(timestamp: Date)  -> Mood {
        
            return cuckoo_manager.call("mood(timestamp: Date) -> Mood",
                parameters: (timestamp),
                superclassCall:
                    
                    super.mood(timestamp: timestamp)
                    )
        
    }
    

	struct __StubbingProxy_DataTypesFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func activity() -> Cuckoo.ClassStubFunction<(), Activity> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "activity() -> Activity", parameterMatchers: matchers))
	    }
	    
	    func activityInstance<M1: Cuckoo.Matchable>(activity: M1) -> Cuckoo.ClassStubFunction<(Activity), ActivityInstance> where M1.MatchedType == Activity {
	        let matchers: [Cuckoo.ParameterMatcher<(Activity)>] = [wrap(matchable: activity) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "activityInstance(activity: Activity) -> ActivityInstance", parameterMatchers: matchers))
	    }
	    
	    func heartRate<M1: Cuckoo.Matchable>(value: M1) -> Cuckoo.ClassStubFunction<(Double), HeartRate> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: value) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "heartRate(value: Double) -> HeartRate", parameterMatchers: matchers))
	    }
	    
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(value: M1, timestamp: M2) -> Cuckoo.ClassStubFunction<(Double, Date), HeartRate> where M1.MatchedType == Double, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, Date)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: timestamp) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "heartRate(value: Double, timestamp: Date) -> HeartRate", parameterMatchers: matchers))
	    }
	    
	    func mood() -> Cuckoo.ClassStubFunction<(), Mood> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "mood() -> Mood", parameterMatchers: matchers))
	    }
	    
	    func mood<M1: Cuckoo.Matchable>(rating: M1) -> Cuckoo.ClassStubFunction<(Double), Mood> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: rating) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "mood(rating: Double) -> Mood", parameterMatchers: matchers))
	    }
	    
	    func mood<M1: Cuckoo.Matchable>(timestamp: M1) -> Cuckoo.ClassStubFunction<(Date), Mood> where M1.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: timestamp) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "mood(timestamp: Date) -> Mood", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_DataTypesFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func activity() -> Cuckoo.__DoNotUse<Activity> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("activity() -> Activity", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func activityInstance<M1: Cuckoo.Matchable>(activity: M1) -> Cuckoo.__DoNotUse<ActivityInstance> where M1.MatchedType == Activity {
	        let matchers: [Cuckoo.ParameterMatcher<(Activity)>] = [wrap(matchable: activity) { $0 }]
	        return cuckoo_manager.verify("activityInstance(activity: Activity) -> ActivityInstance", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func heartRate<M1: Cuckoo.Matchable>(value: M1) -> Cuckoo.__DoNotUse<HeartRate> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: value) { $0 }]
	        return cuckoo_manager.verify("heartRate(value: Double) -> HeartRate", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(value: M1, timestamp: M2) -> Cuckoo.__DoNotUse<HeartRate> where M1.MatchedType == Double, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, Date)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: timestamp) { $0.1 }]
	        return cuckoo_manager.verify("heartRate(value: Double, timestamp: Date) -> HeartRate", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func mood() -> Cuckoo.__DoNotUse<Mood> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("mood() -> Mood", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func mood<M1: Cuckoo.Matchable>(rating: M1) -> Cuckoo.__DoNotUse<Mood> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: rating) { $0 }]
	        return cuckoo_manager.verify("mood(rating: Double) -> Mood", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func mood<M1: Cuckoo.Matchable>(timestamp: M1) -> Cuckoo.__DoNotUse<Mood> where M1.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: timestamp) { $0 }]
	        return cuckoo_manager.verify("mood(timestamp: Date) -> Mood", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class DataTypesFactoryStub: DataTypesFactory {
    

    

    
     override func activity()  -> Activity {
        return DefaultValueRegistry.defaultValue(for: Activity.self)
    }
    
     override func activityInstance(activity: Activity)  -> ActivityInstance {
        return DefaultValueRegistry.defaultValue(for: ActivityInstance.self)
    }
    
     override func heartRate(value: Double)  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
     override func heartRate(value: Double, timestamp: Date)  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
     override func mood()  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
     override func mood(rating: Double)  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
     override func mood(timestamp: Date)  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Queriers/QuerierFactory.swift
//
//  QuerierFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

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


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QueryFactory.swift
//
//  QueryFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

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


// MARK: - Mocks generated from file: DataIntegration/Questions/QuestionFactory.swift
//
//  QuestionFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

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


// MARK: - Mocks generated from file: DataIntegration/Questions/RestrictionParsers/RestrictionParserFactory.swift
//
//  RestrictionParserFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation

class MockRestrictionParserFactory: RestrictionParserFactory, Cuckoo.ClassMock {
    typealias MocksType = RestrictionParserFactory
    typealias Stubbing = __StubbingProxy_RestrictionParserFactory
    typealias Verification = __VerificationProxy_RestrictionParserFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "dayOfWeekRestrictionParser", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "DayOfWeekRestrictionParser", "isReadOnly": true, "accessibility": "public"]
    public override var dayOfWeekRestrictionParser: DayOfWeekRestrictionParser {
        get {
            
            return cuckoo_manager.getter("dayOfWeekRestrictionParser", superclassCall: super.dayOfWeekRestrictionParser)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_RestrictionParserFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var dayOfWeekRestrictionParser: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockRestrictionParserFactory, DayOfWeekRestrictionParser> {
	        return .init(manager: cuckoo_manager, name: "dayOfWeekRestrictionParser")
	    }
	    
	    
	}

	struct __VerificationProxy_RestrictionParserFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var dayOfWeekRestrictionParser: Cuckoo.VerifyReadOnlyProperty<DayOfWeekRestrictionParser> {
	        return .init(manager: cuckoo_manager, name: "dayOfWeekRestrictionParser", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class RestrictionParserFactoryStub: RestrictionParserFactory {
    
    public override var dayOfWeekRestrictionParser: DayOfWeekRestrictionParser {
        get {
            return DefaultValueRegistry.defaultValue(for: (DayOfWeekRestrictionParser).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Util/UtilFactory.swift
//
//  UtilFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

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
    
    // ["name": "textNormalizationUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "TextNormalizationUtil", "isReadOnly": true, "accessibility": "public"]
    public override var textNormalizationUtil: TextNormalizationUtil {
        get {
            
            return cuckoo_manager.getter("textNormalizationUtil", superclassCall: super.textNormalizationUtil)
            
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
	    
	    var textNormalizationUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, TextNormalizationUtil> {
	        return .init(manager: cuckoo_manager, name: "textNormalizationUtil")
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
	    
	    var textNormalizationUtil: Cuckoo.VerifyReadOnlyProperty<TextNormalizationUtil> {
	        return .init(manager: cuckoo_manager, name: "textNormalizationUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
    
    public override var textNormalizationUtil: TextNormalizationUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (TextNormalizationUtil).self)
        }
        
    }
    

    

    
}

