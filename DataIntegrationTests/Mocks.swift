// MARK: - Mocks generated from file: DataIntegration/DataTypes/Activity.swift
//
//  Activity.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivity: Activity, Cuckoo.ClassMock {
    typealias MocksType = Activity
    typealias Stubbing = __StubbingProxy_Activity
    typealias Verification = __VerificationProxy_Activity
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": ""]
     override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "tags", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "NSArray", "isReadOnly": false, "accessibility": ""]
     override var tags: NSArray {
        get {
            
            return cuckoo_manager.getter("tags", superclassCall: super.tags)
            
        }
        
        set {
            
            cuckoo_manager.setter("tags", value: newValue, superclassCall: super.tags = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Activity: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockActivity, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var tags: Cuckoo.ClassToBeStubbedProperty<MockActivity, NSArray> {
	        return .init(manager: cuckoo_manager, name: "tags")
	    }
	    
	    
	}

	struct __VerificationProxy_Activity: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var tags: Cuckoo.VerifyProperty<NSArray> {
	        return .init(manager: cuckoo_manager, name: "tags", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class ActivityStub: Activity {
    
     override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
     override var tags: NSArray {
        get {
            return DefaultValueRegistry.defaultValue(for: (NSArray).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/ActivityInstance.swift
//
//  ActivityInstance.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivityInstance: ActivityInstance, Cuckoo.ClassMock {
    typealias MocksType = ActivityInstance
    typealias Stubbing = __StubbingProxy_ActivityInstance
    typealias Verification = __VerificationProxy_ActivityInstance
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "activity", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Activity", "isReadOnly": false, "accessibility": ""]
     override var activity: Activity {
        get {
            
            return cuckoo_manager.getter("activity", superclassCall: super.activity)
            
        }
        
        set {
            
            cuckoo_manager.setter("activity", value: newValue, superclassCall: super.activity = newValue)
            
        }
        
    }
    
    // ["name": "startTimestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var startTimestamp: Date {
        get {
            
            return cuckoo_manager.getter("startTimestamp", superclassCall: super.startTimestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("startTimestamp", value: newValue, superclassCall: super.startTimestamp = newValue)
            
        }
        
    }
    
    // ["name": "endTimestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var endTimestamp: Date {
        get {
            
            return cuckoo_manager.getter("endTimestamp", superclassCall: super.endTimestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("endTimestamp", value: newValue, superclassCall: super.endTimestamp = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_ActivityInstance: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var activity: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Activity> {
	        return .init(manager: cuckoo_manager, name: "activity")
	    }
	    
	    var startTimestamp: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Date> {
	        return .init(manager: cuckoo_manager, name: "startTimestamp")
	    }
	    
	    var endTimestamp: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Date> {
	        return .init(manager: cuckoo_manager, name: "endTimestamp")
	    }
	    
	    
	}

	struct __VerificationProxy_ActivityInstance: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var activity: Cuckoo.VerifyProperty<Activity> {
	        return .init(manager: cuckoo_manager, name: "activity", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startTimestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "startTimestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endTimestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "endTimestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class ActivityInstanceStub: ActivityInstance {
    
     override var activity: Activity {
        get {
            return DefaultValueRegistry.defaultValue(for: (Activity).self)
        }
        
        set { }
        
    }
    
     override var startTimestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    
     override var endTimestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/HeartRate.swift
//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockHeartRate: HeartRate, Cuckoo.ClassMock {
    typealias MocksType = HeartRate
    typealias Stubbing = __StubbingProxy_HeartRate
    typealias Verification = __VerificationProxy_HeartRate
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "value", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": ""]
     override var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
        set {
            
            cuckoo_manager.setter("value", value: newValue, superclassCall: super.value = newValue)
            
        }
        
    }
    
    // ["name": "timestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var timestamp: Date {
        get {
            
            return cuckoo_manager.getter("timestamp", superclassCall: super.timestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("timestamp", value: newValue, superclassCall: super.timestamp = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_HeartRate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var value: Cuckoo.ClassToBeStubbedProperty<MockHeartRate, Double> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    var timestamp: Cuckoo.ClassToBeStubbedProperty<MockHeartRate, Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp")
	    }
	    
	    
	}

	struct __VerificationProxy_HeartRate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var value: Cuckoo.VerifyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var timestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class HeartRateStub: HeartRate {
    
     override var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    
     override var timestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/Mood.swift
//
//  Mood.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockMood: Mood, Cuckoo.ClassMock {
    typealias MocksType = Mood
    typealias Stubbing = __StubbingProxy_Mood
    typealias Verification = __VerificationProxy_Mood
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "timestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var timestamp: Date {
        get {
            
            return cuckoo_manager.getter("timestamp", superclassCall: super.timestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("timestamp", value: newValue, superclassCall: super.timestamp = newValue)
            
        }
        
    }
    
    // ["name": "rating", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": ""]
     override var rating: Double {
        get {
            
            return cuckoo_manager.getter("rating", superclassCall: super.rating)
            
        }
        
        set {
            
            cuckoo_manager.setter("rating", value: newValue, superclassCall: super.rating = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Mood: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var timestamp: Cuckoo.ClassToBeStubbedProperty<MockMood, Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp")
	    }
	    
	    var rating: Cuckoo.ClassToBeStubbedProperty<MockMood, Double> {
	        return .init(manager: cuckoo_manager, name: "rating")
	    }
	    
	    
	}

	struct __VerificationProxy_Mood: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var timestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var rating: Cuckoo.VerifyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "rating", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class MoodStub: Mood {
    
     override var timestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    
     override var rating: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Answer.swift
//
//  Answer.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockAnswer: Answer, Cuckoo.ClassMock {
    typealias MocksType = Answer
    typealias Stubbing = __StubbingProxy_Answer
    typealias Verification = __VerificationProxy_Answer
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "finalAnswer", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var finalAnswer: String {
        get {
            
            return cuckoo_manager.getter("finalAnswer", superclassCall: super.finalAnswer)
            
        }
        
        set {
            
            cuckoo_manager.setter("finalAnswer", value: newValue, superclassCall: super.finalAnswer = newValue)
            
        }
        
    }
    
    // ["name": "otherRelevantInformation", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: [NSObject]]", "isReadOnly": false, "accessibility": "public"]
    public override var otherRelevantInformation: [String: [NSObject]] {
        get {
            
            return cuckoo_manager.getter("otherRelevantInformation", superclassCall: super.otherRelevantInformation)
            
        }
        
        set {
            
            cuckoo_manager.setter("otherRelevantInformation", value: newValue, superclassCall: super.otherRelevantInformation = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Answer: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalAnswer: Cuckoo.ClassToBeStubbedProperty<MockAnswer, String> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer")
	    }
	    
	    var otherRelevantInformation: Cuckoo.ClassToBeStubbedProperty<MockAnswer, [String: [NSObject]]> {
	        return .init(manager: cuckoo_manager, name: "otherRelevantInformation")
	    }
	    
	    
	}

	struct __VerificationProxy_Answer: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalAnswer: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var otherRelevantInformation: Cuckoo.VerifyProperty<[String: [NSObject]]> {
	        return .init(manager: cuckoo_manager, name: "otherRelevantInformation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class AnswerStub: Answer {
    
    public override var finalAnswer: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var otherRelevantInformation: [String: [NSObject]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: [NSObject]]).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Labels.swift
//
//  Labels.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockLabels: Labels, Cuckoo.ClassMock {
    typealias MocksType = Labels
    typealias Stubbing = __StubbingProxy_Labels
    typealias Verification = __VerificationProxy_Labels
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "description", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var description: String {
        get {
            
            return cuckoo_manager.getter("description", superclassCall: super.description)
            
        }
        
    }
    
    // ["name": "count", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Int", "isReadOnly": true, "accessibility": "public"]
    public override var count: Int {
        get {
            
            return cuckoo_manager.getter("count", superclassCall: super.count)
            
        }
        
    }
    
    // ["name": "isEmpty", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Bool", "isReadOnly": true, "accessibility": "public"]
    public override var isEmpty: Bool {
        get {
            
            return cuckoo_manager.getter("isEmpty", superclassCall: super.isEmpty)
            
        }
        
    }
    
    // ["name": "byTag", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[NLTag: [Label]]", "isReadOnly": true, "accessibility": "public"]
    public override var byTag: [NLTag: [Label]] {
        get {
            
            return cuckoo_manager.getter("byTag", superclassCall: super.byTag)
            
        }
        
    }
    
    // ["name": "byIndex", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[Label]", "isReadOnly": true, "accessibility": "public"]
    public override var byIndex: [Label] {
        get {
            
            return cuckoo_manager.getter("byIndex", superclassCall: super.byIndex)
            
        }
        
    }
    

    

    
    // ["name": "addLabel", "returnSignature": "", "fullyQualifiedName": "addLabel(_: Label)", "parameterSignature": "_ label: Label", "parameterSignatureWithoutNames": "label: Label", "inputTypes": "Label", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "label", "call": "label", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "label", type: "Label", range: CountableRange(2105..<2119), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func addLabel(_ label: Label)  {
        
            return cuckoo_manager.call("addLabel(_: Label)",
                parameters: (label),
                superclassCall:
                    
                    super.addLabel(label)
                    )
        
    }
    
    // ["name": "hasLabelFor", "returnSignature": " -> Bool", "fullyQualifiedName": "hasLabelFor(_: NLTag) -> Bool", "parameterSignature": "_ tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "tag", type: "NLTag", range: CountableRange(2900..<2912), nameRange: CountableRange(0..<0))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func hasLabelFor(_ tag: NLTag)  -> Bool {
        
            return cuckoo_manager.call("hasLabelFor(_: NLTag) -> Bool",
                parameters: (tag),
                superclassCall:
                    
                    super.hasLabelFor(tag)
                    )
        
    }
    
    // ["name": "hasLabels", "returnSignature": " -> Bool", "fullyQualifiedName": "hasLabels() -> Bool", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func hasLabels()  -> Bool {
        
            return cuckoo_manager.call("hasLabels() -> Bool",
                parameters: (),
                superclassCall:
                    
                    super.hasLabels()
                    )
        
    }
    
    // ["name": "indexOf", "returnSignature": " -> Int", "fullyQualifiedName": "indexOf(label: Label) -> Int", "parameterSignature": "label: Label", "parameterSignatureWithoutNames": "label: Label", "inputTypes": "Label", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "label", "call": "label: label", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("label"), name: "label", type: "Label", range: CountableRange(3214..<3226), nameRange: CountableRange(3214..<3219))], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func indexOf(label: Label)  -> Int {
        
            return cuckoo_manager.call("indexOf(label: Label) -> Int",
                parameters: (label),
                superclassCall:
                    
                    super.indexOf(label: label)
                    )
        
    }
    
    // ["name": "labelsInAnyOrderFor", "returnSignature": " -> [Label]", "fullyQualifiedName": "labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(3462..<3478), nameRange: CountableRange(3462..<3466))], "returnType": "[Label]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func labelsInAnyOrderFor(tags: Set<NLTag>)  -> [Label] {
        
            return cuckoo_manager.call("labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]",
                parameters: (tags),
                superclassCall:
                    
                    super.labelsInAnyOrderFor(tags: tags)
                    )
        
    }
    
    // ["name": "labelsFor", "returnSignature": " -> [Label]", "fullyQualifiedName": "labelsFor(tags: Set<NLTag>) -> [Label]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(3857..<3873), nameRange: CountableRange(3857..<3861))], "returnType": "[Label]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func labelsFor(tags: Set<NLTag>)  -> [Label] {
        
            return cuckoo_manager.call("labelsFor(tags: Set<NLTag>) -> [Label]",
                parameters: (tags),
                superclassCall:
                    
                    super.labelsFor(tags: tags)
                    )
        
    }
    
    // ["name": "splitBefore", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitBefore(tag: NLTag) -> [Labels]", "parameterSignature": "tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(4379..<4389), nameRange: CountableRange(4379..<4382))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitBefore(tag: NLTag)  -> [Labels] {
        
            return cuckoo_manager.call("splitBefore(tag: NLTag) -> [Labels]",
                parameters: (tag),
                superclassCall:
                    
                    super.splitBefore(tag: tag)
                    )
        
    }
    
    // ["name": "splitBefore", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitBefore(tags: Set<NLTag>) -> [Labels]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(5169..<5185), nameRange: CountableRange(5169..<5173))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitBefore(tags: Set<NLTag>)  -> [Labels] {
        
            return cuckoo_manager.call("splitBefore(tags: Set<NLTag>) -> [Labels]",
                parameters: (tags),
                superclassCall:
                    
                    super.splitBefore(tags: tags)
                    )
        
    }
    
    // ["name": "splitAfter", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitAfter(tag: NLTag) -> [Labels]", "parameterSignature": "tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(6053..<6063), nameRange: CountableRange(6053..<6056))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitAfter(tag: NLTag)  -> [Labels] {
        
            return cuckoo_manager.call("splitAfter(tag: NLTag) -> [Labels]",
                parameters: (tag),
                superclassCall:
                    
                    super.splitAfter(tag: tag)
                    )
        
    }
    
    // ["name": "splitAfter", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitAfter(tags: Set<NLTag>) -> [Labels]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(6895..<6911), nameRange: CountableRange(6895..<6899))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitAfter(tags: Set<NLTag>)  -> [Labels] {
        
            return cuckoo_manager.call("splitAfter(tags: Set<NLTag>) -> [Labels]",
                parameters: (tags),
                superclassCall:
                    
                    super.splitAfter(tags: tags)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> [Label]?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", "parameterSignature": "tag: NLTag, to index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, to: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(7882..<7892), nameRange: CountableRange(7882..<7885)), CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "index", type: "Int", range: CountableRange(7894..<7907), nameRange: CountableRange(7894..<7896))], "returnType": "Optional<[Label]>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, to index: Int)  throws -> [Label]? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, to: index)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> Label?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", "parameterSignature": "tag: NLTag, before index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, before: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(9149..<9159), nameRange: CountableRange(9149..<9152)), CuckooGeneratorFramework.MethodParameter(label: Optional("before"), name: "index", type: "Int", range: CountableRange(9161..<9178), nameRange: CountableRange(9161..<9167))], "returnType": "Optional<Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, before index: Int)  throws -> Label? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, before: index)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> Label?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", "parameterSignature": "tag: NLTag, after index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, after: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(9804..<9814), nameRange: CountableRange(9804..<9807)), CuckooGeneratorFramework.MethodParameter(label: Optional("after"), name: "index", type: "Int", range: CountableRange(9816..<9832), nameRange: CountableRange(9816..<9821))], "returnType": "Optional<Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, after index: Int)  throws -> Label? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, after: index)
                    )
        
    }
    
    // ["name": "ifNotTaggedTagLabelAt", "returnSignature": "", "fullyQualifiedName": "ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)", "parameterSignature": "range: Range<String.Index>, asTag: NLTag", "parameterSignatureWithoutNames": "range: Range<String.Index>, asTag: NLTag", "inputTypes": "Range<String.Index>, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "range, asTag", "call": "range: range, asTag: asTag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("range"), name: "range", type: "Range<String.Index>", range: CountableRange(10457..<10483), nameRange: CountableRange(10457..<10462)), CuckooGeneratorFramework.MethodParameter(label: Optional("asTag"), name: "asTag", type: "NLTag", range: CountableRange(10485..<10497), nameRange: CountableRange(10485..<10490))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)  {
        
            return cuckoo_manager.call("ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)",
                parameters: (range, asTag),
                superclassCall:
                    
                    super.ifNotTaggedTagLabelAt(range: range, asTag: asTag)
                    )
        
    }
    
    // ["name": "shortestDistance", "returnSignature": " -> Int", "fullyQualifiedName": "shortestDistance(between: NLTag, and: NLTag) -> Int", "parameterSignature": "between tag1: NLTag, and tag2: NLTag", "parameterSignatureWithoutNames": "tag1: NLTag, tag2: NLTag", "inputTypes": "NLTag, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag1, tag2", "call": "between: tag1, and: tag2", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("between"), name: "tag1", type: "NLTag", range: CountableRange(11198..<11217), nameRange: CountableRange(11198..<11205)), CuckooGeneratorFramework.MethodParameter(label: Optional("and"), name: "tag2", type: "NLTag", range: CountableRange(11219..<11234), nameRange: CountableRange(11219..<11222))], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func shortestDistance(between tag1: NLTag, and tag2: NLTag)  -> Int {
        
            return cuckoo_manager.call("shortestDistance(between: NLTag, and: NLTag) -> Int",
                parameters: (tag1, tag2),
                superclassCall:
                    
                    super.shortestDistance(between: tag1, and: tag2)
                    )
        
    }
    
    // ["name": "shortestDistance", "returnSignature": " -> Int?", "fullyQualifiedName": "shortestDistance(from: Label, toLabelWith: NLTag) -> Int?", "parameterSignature": "from: Label, toLabelWith tag: NLTag", "parameterSignatureWithoutNames": "from: Label, tag: NLTag", "inputTypes": "Label, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "from, tag", "call": "from: from, toLabelWith: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("from"), name: "from", type: "Label", range: CountableRange(12210..<12221), nameRange: CountableRange(12210..<12214)), CuckooGeneratorFramework.MethodParameter(label: Optional("toLabelWith"), name: "tag", type: "NLTag", range: CountableRange(12223..<12245), nameRange: CountableRange(12223..<12234))], "returnType": "Optional<Int>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func shortestDistance(from: Label, toLabelWith tag: NLTag)  -> Int? {
        
            return cuckoo_manager.call("shortestDistance(from: Label, toLabelWith: NLTag) -> Int?",
                parameters: (from, tag),
                superclassCall:
                    
                    super.shortestDistance(from: from, toLabelWith: tag)
                    )
        
    }
    
    // ["name": "shortestDistance", "returnSignature": " -> Int?", "fullyQualifiedName": "shortestDistance(from: Label, toPreceedingLabelWith: NLTag) -> Int?", "parameterSignature": "from: Label, toPreceedingLabelWith tag: NLTag", "parameterSignatureWithoutNames": "from: Label, tag: NLTag", "inputTypes": "Label, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "from, tag", "call": "from: from, toPreceedingLabelWith: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("from"), name: "from", type: "Label", range: CountableRange(13200..<13211), nameRange: CountableRange(13200..<13204)), CuckooGeneratorFramework.MethodParameter(label: Optional("toPreceedingLabelWith"), name: "tag", type: "NLTag", range: CountableRange(13213..<13245), nameRange: CountableRange(13213..<13234))], "returnType": "Optional<Int>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func shortestDistance(from: Label, toPreceedingLabelWith tag: NLTag)  -> Int? {
        
            return cuckoo_manager.call("shortestDistance(from: Label, toPreceedingLabelWith: NLTag) -> Int?",
                parameters: (from, tag),
                superclassCall:
                    
                    super.shortestDistance(from: from, toPreceedingLabelWith: tag)
                    )
        
    }
    
    // ["name": "shortestDistance", "returnSignature": " -> Int?", "fullyQualifiedName": "shortestDistance(from: Label, toSuccessiveLabelWith: NLTag) -> Int?", "parameterSignature": "from: Label, toSuccessiveLabelWith tag: NLTag", "parameterSignatureWithoutNames": "from: Label, tag: NLTag", "inputTypes": "Label, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "from, tag", "call": "from: from, toSuccessiveLabelWith: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("from"), name: "from", type: "Label", range: CountableRange(13838..<13849), nameRange: CountableRange(13838..<13842)), CuckooGeneratorFramework.MethodParameter(label: Optional("toSuccessiveLabelWith"), name: "tag", type: "NLTag", range: CountableRange(13851..<13883), nameRange: CountableRange(13851..<13872))], "returnType": "Optional<Int>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func shortestDistance(from: Label, toSuccessiveLabelWith tag: NLTag)  -> Int? {
        
            return cuckoo_manager.call("shortestDistance(from: Label, toSuccessiveLabelWith: NLTag) -> Int?",
                parameters: (from, tag),
                superclassCall:
                    
                    super.shortestDistance(from: from, toSuccessiveLabelWith: tag)
                    )
        
    }
    
    // ["name": "next", "returnSignature": " -> Labels.Label?", "fullyQualifiedName": "next() -> Labels.Label?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<Labels.Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func next()  -> Labels.Label? {
        
            return cuckoo_manager.call("next() -> Labels.Label?",
                parameters: (),
                superclassCall:
                    
                    super.next()
                    )
        
    }
    

	struct __StubbingProxy_Labels: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var description: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, String> {
	        return .init(manager: cuckoo_manager, name: "description")
	    }
	    
	    var count: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, Int> {
	        return .init(manager: cuckoo_manager, name: "count")
	    }
	    
	    var isEmpty: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, Bool> {
	        return .init(manager: cuckoo_manager, name: "isEmpty")
	    }
	    
	    var byTag: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, [NLTag: [Label]]> {
	        return .init(manager: cuckoo_manager, name: "byTag")
	    }
	    
	    var byIndex: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, [Label]> {
	        return .init(manager: cuckoo_manager, name: "byIndex")
	    }
	    
	    
	    func addLabel<M1: Cuckoo.Matchable>(_ label: M1) -> Cuckoo.ClassStubNoReturnFunction<(Label)> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "addLabel(_: Label)", parameterMatchers: matchers))
	    }
	    
	    func hasLabelFor<M1: Cuckoo.Matchable>(_ tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), Bool> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "hasLabelFor(_: NLTag) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func hasLabels() -> Cuckoo.ClassStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "hasLabels() -> Bool", parameterMatchers: matchers))
	    }
	    
	    func indexOf<M1: Cuckoo.Matchable>(label: M1) -> Cuckoo.ClassStubFunction<(Label), Int> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "indexOf(label: Label) -> Int", parameterMatchers: matchers))
	    }
	    
	    func labelsInAnyOrderFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", parameterMatchers: matchers))
	    }
	    
	    func labelsFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "labelsFor(tags: Set<NLTag>) -> [Label]", parameterMatchers: matchers))
	    }
	    
	    func splitBefore<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), [Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitBefore(tag: NLTag) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitBefore<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitBefore(tags: Set<NLTag>) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitAfter<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), [Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitAfter(tag: NLTag) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitAfter<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitAfter(tags: Set<NLTag>) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, to index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<[Label]>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, before index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, after index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", parameterMatchers: matchers))
	    }
	    
	    func ifNotTaggedTagLabelAt<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(range: M1, asTag: M2) -> Cuckoo.ClassStubNoReturnFunction<(Range<String.Index>, NLTag)> where M1.MatchedType == Range<String.Index>, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Range<String.Index>, NLTag)>] = [wrap(matchable: range) { $0.0 }, wrap(matchable: asTag) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)", parameterMatchers: matchers))
	    }
	    
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(between tag1: M1, and tag2: M2) -> Cuckoo.ClassStubFunction<(NLTag, NLTag), Int> where M1.MatchedType == NLTag, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, NLTag)>] = [wrap(matchable: tag1) { $0.0 }, wrap(matchable: tag2) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "shortestDistance(between: NLTag, and: NLTag) -> Int", parameterMatchers: matchers))
	    }
	    
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toLabelWith tag: M2) -> Cuckoo.ClassStubFunction<(Label, NLTag), Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "shortestDistance(from: Label, toLabelWith: NLTag) -> Int?", parameterMatchers: matchers))
	    }
	    
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toPreceedingLabelWith tag: M2) -> Cuckoo.ClassStubFunction<(Label, NLTag), Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "shortestDistance(from: Label, toPreceedingLabelWith: NLTag) -> Int?", parameterMatchers: matchers))
	    }
	    
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toSuccessiveLabelWith tag: M2) -> Cuckoo.ClassStubFunction<(Label, NLTag), Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "shortestDistance(from: Label, toSuccessiveLabelWith: NLTag) -> Int?", parameterMatchers: matchers))
	    }
	    
	    func next() -> Cuckoo.ClassStubFunction<(), Optional<Labels.Label>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "next() -> Labels.Label?", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Labels: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var description: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "description", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var count: Cuckoo.VerifyReadOnlyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "count", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var isEmpty: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isEmpty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var byTag: Cuckoo.VerifyReadOnlyProperty<[NLTag: [Label]]> {
	        return .init(manager: cuckoo_manager, name: "byTag", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var byIndex: Cuckoo.VerifyReadOnlyProperty<[Label]> {
	        return .init(manager: cuckoo_manager, name: "byIndex", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func addLabel<M1: Cuckoo.Matchable>(_ label: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return cuckoo_manager.verify("addLabel(_: Label)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hasLabelFor<M1: Cuckoo.Matchable>(_ tag: M1) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("hasLabelFor(_: NLTag) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hasLabels() -> Cuckoo.__DoNotUse<Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("hasLabels() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func indexOf<M1: Cuckoo.Matchable>(label: M1) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return cuckoo_manager.verify("indexOf(label: Label) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labelsInAnyOrderFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labelsFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("labelsFor(tags: Set<NLTag>) -> [Label]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitBefore<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("splitBefore(tag: NLTag) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitBefore<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("splitBefore(tags: Set<NLTag>) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitAfter<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("splitAfter(tag: NLTag) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitAfter<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("splitAfter(tags: Set<NLTag>) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, to index: M2) -> Cuckoo.__DoNotUse<Optional<[Label]>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, before index: M2) -> Cuckoo.__DoNotUse<Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, after index: M2) -> Cuckoo.__DoNotUse<Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func ifNotTaggedTagLabelAt<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(range: M1, asTag: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Range<String.Index>, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Range<String.Index>, NLTag)>] = [wrap(matchable: range) { $0.0 }, wrap(matchable: asTag) { $0.1 }]
	        return cuckoo_manager.verify("ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(between tag1: M1, and tag2: M2) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == NLTag, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, NLTag)>] = [wrap(matchable: tag1) { $0.0 }, wrap(matchable: tag2) { $0.1 }]
	        return cuckoo_manager.verify("shortestDistance(between: NLTag, and: NLTag) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toLabelWith tag: M2) -> Cuckoo.__DoNotUse<Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return cuckoo_manager.verify("shortestDistance(from: Label, toLabelWith: NLTag) -> Int?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toPreceedingLabelWith tag: M2) -> Cuckoo.__DoNotUse<Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return cuckoo_manager.verify("shortestDistance(from: Label, toPreceedingLabelWith: NLTag) -> Int?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toSuccessiveLabelWith tag: M2) -> Cuckoo.__DoNotUse<Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return cuckoo_manager.verify("shortestDistance(from: Label, toSuccessiveLabelWith: NLTag) -> Int?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func next() -> Cuckoo.__DoNotUse<Optional<Labels.Label>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("next() -> Labels.Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class LabelsStub: Labels {
    
    public override var description: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var count: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
    }
    
    public override var isEmpty: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    public override var byTag: [NLTag: [Label]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([NLTag: [Label]]).self)
        }
        
    }
    
    public override var byIndex: [Label] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Label]).self)
        }
        
    }
    

    

    
    public override func addLabel(_ label: Label)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func hasLabelFor(_ tag: NLTag)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
    public override func hasLabels()  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
    public override func indexOf(label: Label)  -> Int {
        return DefaultValueRegistry.defaultValue(for: Int.self)
    }
    
    public override func labelsInAnyOrderFor(tags: Set<NLTag>)  -> [Label] {
        return DefaultValueRegistry.defaultValue(for: [Label].self)
    }
    
    public override func labelsFor(tags: Set<NLTag>)  -> [Label] {
        return DefaultValueRegistry.defaultValue(for: [Label].self)
    }
    
    public override func splitBefore(tag: NLTag)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitBefore(tags: Set<NLTag>)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitAfter(tag: NLTag)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitAfter(tags: Set<NLTag>)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, to index: Int)  throws -> [Label]? {
        return DefaultValueRegistry.defaultValue(for: Optional<[Label]>.self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, before index: Int)  throws -> Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Label>.self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, after index: Int)  throws -> Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Label>.self)
    }
    
    public override func ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func shortestDistance(between tag1: NLTag, and tag2: NLTag)  -> Int {
        return DefaultValueRegistry.defaultValue(for: Int.self)
    }
    
    public override func shortestDistance(from: Label, toLabelWith tag: NLTag)  -> Int? {
        return DefaultValueRegistry.defaultValue(for: Optional<Int>.self)
    }
    
    public override func shortestDistance(from: Label, toPreceedingLabelWith tag: NLTag)  -> Int? {
        return DefaultValueRegistry.defaultValue(for: Optional<Int>.self)
    }
    
    public override func shortestDistance(from: Label, toSuccessiveLabelWith tag: NLTag)  -> Int? {
        return DefaultValueRegistry.defaultValue(for: Optional<Int>.self)
    }
    
    public override func next()  -> Labels.Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Labels.Label>.self)
    }
    
}


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


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/HeartRateQuery.swift
//
//  HeartRateQuery.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit

class MockHeartRateQuery: HeartRateQuery, Cuckoo.ClassMock {
    typealias MocksType = HeartRateQuery
    typealias Stubbing = __StubbingProxy_HeartRateQuery
    typealias Verification = __VerificationProxy_HeartRateQuery
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "finalOperation", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "QueryOperation?", "isReadOnly": false, "accessibility": "public"]
    public override var finalOperation: QueryOperation? {
        get {
            
            return cuckoo_manager.getter("finalOperation", superclassCall: super.finalOperation)
            
        }
        
        set {
            
            cuckoo_manager.setter("finalOperation", value: newValue, superclassCall: super.finalOperation = newValue)
            
        }
        
    }
    
    // ["name": "startDate", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": "public"]
    public override var startDate: Date? {
        get {
            
            return cuckoo_manager.getter("startDate", superclassCall: super.startDate)
            
        }
        
        set {
            
            cuckoo_manager.setter("startDate", value: newValue, superclassCall: super.startDate = newValue)
            
        }
        
    }
    
    // ["name": "endDate", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": "public"]
    public override var endDate: Date? {
        get {
            
            return cuckoo_manager.getter("endDate", superclassCall: super.endDate)
            
        }
        
        set {
            
            cuckoo_manager.setter("endDate", value: newValue, superclassCall: super.endDate = newValue)
            
        }
        
    }
    
    // ["name": "daysOfWeek", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Set<DayOfWeek>", "isReadOnly": false, "accessibility": "public"]
    public override var daysOfWeek: Set<DayOfWeek> {
        get {
            
            return cuckoo_manager.getter("daysOfWeek", superclassCall: super.daysOfWeek)
            
        }
        
        set {
            
            cuckoo_manager.setter("daysOfWeek", value: newValue, superclassCall: super.daysOfWeek = newValue)
            
        }
        
    }
    
    // ["name": "quantityRestrictions", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[QuantityRestriction]", "isReadOnly": false, "accessibility": "public"]
    public override var quantityRestrictions: [QuantityRestriction] {
        get {
            
            return cuckoo_manager.getter("quantityRestrictions", superclassCall: super.quantityRestrictions)
            
        }
        
        set {
            
            cuckoo_manager.setter("quantityRestrictions", value: newValue, superclassCall: super.quantityRestrictions = newValue)
            
        }
        
    }
    
    // ["name": "returnType", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "ReturnType?", "isReadOnly": false, "accessibility": "public"]
    public override var returnType: ReturnType? {
        get {
            
            return cuckoo_manager.getter("returnType", superclassCall: super.returnType)
            
        }
        
        set {
            
            cuckoo_manager.setter("returnType", value: newValue, superclassCall: super.returnType = newValue)
            
        }
        
    }
    
    // ["name": "mostRecentEntryOnly", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Bool", "isReadOnly": false, "accessibility": "public"]
    public override var mostRecentEntryOnly: Bool {
        get {
            
            return cuckoo_manager.getter("mostRecentEntryOnly", superclassCall: super.mostRecentEntryOnly)
            
        }
        
        set {
            
            cuckoo_manager.setter("mostRecentEntryOnly", value: newValue, superclassCall: super.mostRecentEntryOnly = newValue)
            
        }
        
    }
    

    

    
    // ["name": "runQuery", "returnSignature": "", "fullyQualifiedName": "runQuery(callback: @escaping (QueryResult?, Error?) -> ())", "parameterSignature": "callback: @escaping (QueryResult?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (QueryResult?, Error?) -> ()", "inputTypes": "(QueryResult?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (QueryResult?, Error?) -> ()", range: CountableRange(899..<947), nameRange: CountableRange(899..<907))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  {
        
            return cuckoo_manager.call("runQuery(callback: @escaping (QueryResult?, Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.runQuery(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_HeartRateQuery: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalOperation: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation")
	    }
	    
	    var startDate: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate")
	    }
	    
	    var endDate: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate")
	    }
	    
	    var daysOfWeek: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek")
	    }
	    
	    var quantityRestrictions: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, [QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions")
	    }
	    
	    var returnType: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType")
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly")
	    }
	    
	    
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((QueryResult?, Error?) -> ())> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuery.self, method: "runQuery(callback: @escaping (QueryResult?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HeartRateQuery: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalOperation: Cuckoo.VerifyProperty<QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var daysOfWeek: Cuckoo.VerifyProperty<Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var quantityRestrictions: Cuckoo.VerifyProperty<[QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var returnType: Cuckoo.VerifyProperty<ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("runQuery(callback: @escaping (QueryResult?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateQueryStub: HeartRateQuery {
    
    public override var finalOperation: QueryOperation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (QueryOperation?).self)
        }
        
        set { }
        
    }
    
    public override var startDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
    public override var endDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
    public override var daysOfWeek: Set<DayOfWeek> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<DayOfWeek>).self)
        }
        
        set { }
        
    }
    
    public override var quantityRestrictions: [QuantityRestriction] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([QuantityRestriction]).self)
        }
        
        set { }
        
    }
    
    public override var returnType: ReturnType? {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReturnType?).self)
        }
        
        set { }
        
    }
    
    public override var mostRecentEntryOnly: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    

    

    
    public override func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


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
import NaturalLanguage

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
    
    // ["name": "comparison", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "ComparisonType", "isReadOnly": true, "accessibility": "public"]
    public override var comparison: ComparisonType {
        get {
            
            return cuckoo_manager.getter("comparison", superclassCall: super.comparison)
            
        }
        
    }
    
    // ["name": "value", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": true, "accessibility": "public"]
    public override var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
    }
    
    // ["name": "aggregationUnit", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Calendar.Component?", "isReadOnly": true, "accessibility": "public"]
    public override var aggregationUnit: Calendar.Component? {
        get {
            
            return cuckoo_manager.getter("aggregationUnit", superclassCall: super.aggregationUnit)
            
        }
        
    }
    
    // ["name": "operation", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "QueryOperation?", "isReadOnly": true, "accessibility": "public"]
    public override var operation: QueryOperation? {
        get {
            
            return cuckoo_manager.getter("operation", superclassCall: super.operation)
            
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
	    
	    var comparison: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, ComparisonType> {
	        return .init(manager: cuckoo_manager, name: "comparison")
	    }
	    
	    var value: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, Double> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    var aggregationUnit: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit")
	    }
	    
	    var operation: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "operation")
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
	    
	    var comparison: Cuckoo.VerifyReadOnlyProperty<ComparisonType> {
	        return .init(manager: cuckoo_manager, name: "comparison", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var value: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var aggregationUnit: Cuckoo.VerifyReadOnlyProperty<Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var operation: Cuckoo.VerifyReadOnlyProperty<QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "operation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QuantityRestrictionStub: QuantityRestriction {
    
    public override var attribute: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var comparison: ComparisonType {
        get {
            return DefaultValueRegistry.defaultValue(for: (ComparisonType).self)
        }
        
    }
    
    public override var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    public override var aggregationUnit: Calendar.Component? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Calendar.Component?).self)
        }
        
    }
    
    public override var operation: QueryOperation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (QueryOperation?).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Queriers/HeartRateQuerier.swift
//
//  HeartRateQuerier.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit
import os

class MockHeartRateQuerier: HeartRateQuerier, Cuckoo.ClassMock {
    typealias MocksType = HeartRateQuerier
    typealias Stubbing = __StubbingProxy_HeartRateQuerier
    typealias Verification = __VerificationProxy_HeartRateQuerier
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "getHeartRates", "returnSignature": "", "fullyQualifiedName": "getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", "parameterSignature": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "inputTypes": "NSPredicate, (Array<HKQuantitySample>?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, callback", "call": "predicate: predicate, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(627..<649), nameRange: CountableRange(627..<636)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Array<HKQuantitySample>?, Error?)->()", range: CountableRange(651..<708), nameRange: CountableRange(651..<659))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())  {
        
            return cuckoo_manager.call("getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())",
                parameters: (predicate, callback),
                superclassCall:
                    
                    super.getHeartRates(predicate: predicate, callback: callback)
                    )
        
    }
    
    // ["name": "getStatisticsFromHeartRates", "returnSignature": "", "fullyQualifiedName": "getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", "parameterSignature": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "inputTypes": "NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, statsOptions, callback", "call": "predicate: predicate, statsOptions: statsOptions, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(1011..<1033), nameRange: CountableRange(1011..<1020)), CuckooGeneratorFramework.MethodParameter(label: Optional("statsOptions"), name: "statsOptions", type: "HKStatisticsOptions", range: CountableRange(1035..<1068), nameRange: CountableRange(1035..<1047)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (HKStatistics?, Error?)->()", range: CountableRange(1070..<1116), nameRange: CountableRange(1070..<1078))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())  {
        
            return cuckoo_manager.call("getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())",
                parameters: (predicate, statsOptions, callback),
                superclassCall:
                    
                    super.getStatisticsFromHeartRates(predicate: predicate, statsOptions: statsOptions, callback: callback)
                    )
        
    }
    
    // ["name": "getAuthorization", "returnSignature": "", "fullyQualifiedName": "getAuthorization(callback: @escaping (Error?) -> ())", "parameterSignature": "callback: @escaping (Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Error?) -> ()", range: CountableRange(1428..<1462), nameRange: CountableRange(1428..<1436))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getAuthorization(callback: @escaping (Error?) -> ())  {
        
            return cuckoo_manager.call("getAuthorization(callback: @escaping (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.getAuthorization(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_HeartRateQuerier: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(predicate: M1, callback: M2) -> Cuckoo.ClassStubNoReturnFunction<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())> where M1.MatchedType == NSPredicate, M2.MatchedType == (Array<HKQuantitySample>?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", parameterMatchers: matchers))
	    }
	    
	    func getStatisticsFromHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(predicate: M1, statsOptions: M2, callback: M3) -> Cuckoo.ClassStubNoReturnFunction<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())> where M1.MatchedType == NSPredicate, M2.MatchedType == HKStatisticsOptions, M3.MatchedType == (HKStatistics?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: statsOptions) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", parameterMatchers: matchers))
	    }
	    
	    func getAuthorization<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Error?) -> ())> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getAuthorization(callback: @escaping (Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HeartRateQuerier: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(predicate: M1, callback: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == NSPredicate, M2.MatchedType == (Array<HKQuantitySample>?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getStatisticsFromHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(predicate: M1, statsOptions: M2, callback: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == NSPredicate, M2.MatchedType == HKStatisticsOptions, M3.MatchedType == (HKStatistics?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: statsOptions) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getAuthorization<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("getAuthorization(callback: @escaping (Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateQuerierStub: HeartRateQuerier {
    

    

    
    public override func getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func getAuthorization(callback: @escaping (Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Query.swift
//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQuery: Query, Cuckoo.ProtocolMock {
    typealias MocksType = Query
    typealias Stubbing = __StubbingProxy_Query
    typealias Verification = __VerificationProxy_Query
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "finalOperation", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "QueryOperation?", "isReadOnly": false, "accessibility": ""]
     var finalOperation: QueryOperation? {
        get {
            
            return cuckoo_manager.getter("finalOperation", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("finalOperation", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "startDate", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": ""]
     var startDate: Date? {
        get {
            
            return cuckoo_manager.getter("startDate", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("startDate", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "endDate", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": ""]
     var endDate: Date? {
        get {
            
            return cuckoo_manager.getter("endDate", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("endDate", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "daysOfWeek", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Set<DayOfWeek>", "isReadOnly": false, "accessibility": ""]
     var daysOfWeek: Set<DayOfWeek> {
        get {
            
            return cuckoo_manager.getter("daysOfWeek", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("daysOfWeek", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "quantityRestrictions", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "[QuantityRestriction]", "isReadOnly": false, "accessibility": ""]
     var quantityRestrictions: [QuantityRestriction] {
        get {
            
            return cuckoo_manager.getter("quantityRestrictions", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("quantityRestrictions", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "returnType", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "ReturnType?", "isReadOnly": false, "accessibility": ""]
     var returnType: ReturnType? {
        get {
            
            return cuckoo_manager.getter("returnType", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("returnType", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "mostRecentEntryOnly", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Bool", "isReadOnly": false, "accessibility": ""]
     var mostRecentEntryOnly: Bool {
        get {
            
            return cuckoo_manager.getter("mostRecentEntryOnly", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("mostRecentEntryOnly", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    
    // ["name": "runQuery", "returnSignature": " throws", "fullyQualifiedName": "runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws", "parameterSignature": "callback: @escaping (QueryResult?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (QueryResult?, Error?) -> ()", "inputTypes": "(QueryResult?, Error?) -> ()", "isThrowing": true, "isInit": false, "isOverriding": false, "hasClosureParams": true, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (QueryResult?, Error?) -> ()", range: CountableRange(766..<814), nameRange: CountableRange(766..<774))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnThrowingFunction"]
     func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  throws {
        
            return try cuckoo_manager.callThrows("runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws",
                parameters: (callback),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_Query: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalOperation: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation")
	    }
	    
	    var startDate: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate")
	    }
	    
	    var endDate: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate")
	    }
	    
	    var daysOfWeek: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek")
	    }
	    
	    var quantityRestrictions: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, [QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions")
	    }
	    
	    var returnType: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType")
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly")
	    }
	    
	    
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<((QueryResult?, Error?) -> ())> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuery.self, method: "runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Query: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalOperation: Cuckoo.VerifyProperty<QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var daysOfWeek: Cuckoo.VerifyProperty<Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var quantityRestrictions: Cuckoo.VerifyProperty<[QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var returnType: Cuckoo.VerifyProperty<ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QueryStub: Query {
    
     var finalOperation: QueryOperation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (QueryOperation?).self)
        }
        
        set { }
        
    }
    
     var startDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
     var endDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
     var daysOfWeek: Set<DayOfWeek> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<DayOfWeek>).self)
        }
        
        set { }
        
    }
    
     var quantityRestrictions: [QuantityRestriction] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([QuantityRestriction]).self)
        }
        
        set { }
        
    }
    
     var returnType: ReturnType? {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReturnType?).self)
        }
        
        set { }
        
    }
    
     var mostRecentEntryOnly: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    

    

    
     func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  throws {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QueryOperation.swift
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

class MockQueryOperation: QueryOperation, Cuckoo.ClassMock {
    typealias MocksType = QueryOperation
    typealias Stubbing = __StubbingProxy_QueryOperation
    typealias Verification = __VerificationProxy_QueryOperation
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "kind", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Kind", "isReadOnly": true, "accessibility": "public"]
    public override var kind: Kind {
        get {
            
            return cuckoo_manager.getter("kind", superclassCall: super.kind)
            
        }
        
    }
    
    // ["name": "aggregationUnit", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Calendar.Component?", "isReadOnly": false, "accessibility": "public"]
    public override var aggregationUnit: Calendar.Component? {
        get {
            
            return cuckoo_manager.getter("aggregationUnit", superclassCall: super.aggregationUnit)
            
        }
        
        set {
            
            cuckoo_manager.setter("aggregationUnit", value: newValue, superclassCall: super.aggregationUnit = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QueryOperation: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var kind: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQueryOperation, Kind> {
	        return .init(manager: cuckoo_manager, name: "kind")
	    }
	    
	    var aggregationUnit: Cuckoo.ClassToBeStubbedProperty<MockQueryOperation, Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit")
	    }
	    
	    
	}

	struct __VerificationProxy_QueryOperation: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var kind: Cuckoo.VerifyReadOnlyProperty<Kind> {
	        return .init(manager: cuckoo_manager, name: "kind", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var aggregationUnit: Cuckoo.VerifyProperty<Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QueryOperationStub: QueryOperation {
    
    public override var kind: Kind {
        get {
            return DefaultValueRegistry.defaultValue(for: (Kind).self)
        }
        
    }
    
    public override var aggregationUnit: Calendar.Component? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Calendar.Component?).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QueryResult.swift
//
//  Result.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQueryResult: QueryResult, Cuckoo.ClassMock {
    typealias MocksType = QueryResult
    typealias Stubbing = __StubbingProxy_QueryResult
    typealias Verification = __VerificationProxy_QueryResult
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "finalAnswer", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Any", "isReadOnly": true, "accessibility": "public"]
    public override var finalAnswer: Any {
        get {
            
            return cuckoo_manager.getter("finalAnswer", superclassCall: super.finalAnswer)
            
        }
        
    }
    
    // ["name": "returnType", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "ReturnType", "isReadOnly": true, "accessibility": "public"]
    public override var returnType: ReturnType {
        get {
            
            return cuckoo_manager.getter("returnType", superclassCall: super.returnType)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QueryResult: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalAnswer: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQueryResult, Any> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer")
	    }
	    
	    var returnType: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQueryResult, ReturnType> {
	        return .init(manager: cuckoo_manager, name: "returnType")
	    }
	    
	    
	}

	struct __VerificationProxy_QueryResult: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalAnswer: Cuckoo.VerifyReadOnlyProperty<Any> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var returnType: Cuckoo.VerifyReadOnlyProperty<ReturnType> {
	        return .init(manager: cuckoo_manager, name: "returnType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QueryResultStub: QueryResult {
    
    public override var finalAnswer: Any {
        get {
            return DefaultValueRegistry.defaultValue(for: (Any).self)
        }
        
    }
    
    public override var returnType: ReturnType {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReturnType).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/ReturnType.swift
//
//  ReturnType.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

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
    

    

    
    // ["name": "parse", "returnSignature": "", "fullyQualifiedName": "parse(callback: (Error?) -> ())", "parameterSignature": "callback: (Error?) -> ()", "parameterSignatureWithoutNames": "callback: (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "(Error?) -> ()", range: CountableRange(819..<843), nameRange: CountableRange(819..<827))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func parse(callback: (Error?) -> ())  {
        	return withoutActuallyEscaping(callback, do: { (callback) in

            return cuckoo_manager.call("parse(callback: (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.parse(callback: callback)
                    )
        	})

    }
    
    // ["name": "answer", "returnSignature": "", "fullyQualifiedName": "answer(callback: @escaping (Answer?, Error?) -> ())", "parameterSignature": "callback: @escaping (Answer?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Answer?, Error?) -> ()", "inputTypes": "(Answer?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Answer?, Error?) -> ()", range: CountableRange(3285..<3328), nameRange: CountableRange(3285..<3293))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
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


// MARK: - Mocks generated from file: DataIntegration/Questions/RestrictionParsers/DayOfWeekRestrictionParser.swift
//
//  DayOfWeekRestrictionParser.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import os

class MockDayOfWeekRestrictionParser: DayOfWeekRestrictionParser, Cuckoo.ClassMock {
    typealias MocksType = DayOfWeekRestrictionParser
    typealias Stubbing = __StubbingProxy_DayOfWeekRestrictionParser
    typealias Verification = __VerificationProxy_DayOfWeekRestrictionParser
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "resolveDayOfWeekRestrictions", "returnSignature": " throws -> (date: Date?, dayOfWeek: DayOfWeek?)", "fullyQualifiedName": "resolveDayOfWeekRestrictions(_: Labels) throws -> (date: Date?, dayOfWeek: DayOfWeek?)", "parameterSignature": "_ questionPart: Labels", "parameterSignatureWithoutNames": "questionPart: Labels", "inputTypes": "Labels", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "questionPart", "call": "questionPart", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "questionPart", type: "Labels", range: CountableRange(374..<396), nameRange: CountableRange(0..<0))], "returnType": "(date: Date?, dayOfWeek: DayOfWeek?)", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func resolveDayOfWeekRestrictions(_ questionPart: Labels)  throws -> (date: Date?, dayOfWeek: DayOfWeek?) {
        
            return try cuckoo_manager.callThrows("resolveDayOfWeekRestrictions(_: Labels) throws -> (date: Date?, dayOfWeek: DayOfWeek?)",
                parameters: (questionPart),
                superclassCall:
                    
                    super.resolveDayOfWeekRestrictions(questionPart)
                    )
        
    }
    

	struct __StubbingProxy_DayOfWeekRestrictionParser: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func resolveDayOfWeekRestrictions<M1: Cuckoo.Matchable>(_ questionPart: M1) -> Cuckoo.ClassStubThrowingFunction<(Labels), (date: Date?, dayOfWeek: DayOfWeek?)> where M1.MatchedType == Labels {
	        let matchers: [Cuckoo.ParameterMatcher<(Labels)>] = [wrap(matchable: questionPart) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDayOfWeekRestrictionParser.self, method: "resolveDayOfWeekRestrictions(_: Labels) throws -> (date: Date?, dayOfWeek: DayOfWeek?)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_DayOfWeekRestrictionParser: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func resolveDayOfWeekRestrictions<M1: Cuckoo.Matchable>(_ questionPart: M1) -> Cuckoo.__DoNotUse<(date: Date?, dayOfWeek: DayOfWeek?)> where M1.MatchedType == Labels {
	        let matchers: [Cuckoo.ParameterMatcher<(Labels)>] = [wrap(matchable: questionPart) { $0 }]
	        return cuckoo_manager.verify("resolveDayOfWeekRestrictions(_: Labels) throws -> (date: Date?, dayOfWeek: DayOfWeek?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class DayOfWeekRestrictionParserStub: DayOfWeekRestrictionParser {
    

    

    
    public override func resolveDayOfWeekRestrictions(_ questionPart: Labels)  throws -> (date: Date?, dayOfWeek: DayOfWeek?) {
        return DefaultValueRegistry.defaultValue(for: (date: Date?, dayOfWeek: DayOfWeek?).self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Tags.swift
//
//  Tags.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockTags: Tags, Cuckoo.ClassMock {
    typealias MocksType = Tags
    typealias Stubbing = __StubbingProxy_Tags
    typealias Verification = __VerificationProxy_Tags
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

	struct __StubbingProxy_Tags: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	}

	struct __VerificationProxy_Tags: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	}

}

 class TagsStub: Tags {
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/ActivitySource.swift
//
//  ActivitySource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivitySource: ActivitySource, Cuckoo.ClassMock {
    typealias MocksType = ActivitySource
    typealias Stubbing = __StubbingProxy_ActivitySource
    typealias Verification = __VerificationProxy_ActivitySource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_ActivitySource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockActivitySource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_ActivitySource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class ActivitySourceStub: ActivitySource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/HeartRateSource.swift
//
//  HeartRateSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockHeartRateSource: HeartRateSource, Cuckoo.ClassMock {
    typealias MocksType = HeartRateSource
    typealias Stubbing = __StubbingProxy_HeartRateSource
    typealias Verification = __VerificationProxy_HeartRateSource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_HeartRateSource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HeartRateSource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateSourceStub: HeartRateSource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/MedicationSource.swift
//
//  MedicationsSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockMedicationSource: MedicationSource, Cuckoo.ClassMock {
    typealias MocksType = MedicationSource
    typealias Stubbing = __StubbingProxy_MedicationSource
    typealias Verification = __VerificationProxy_MedicationSource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_MedicationSource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMedicationSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_MedicationSource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class MedicationSourceStub: MedicationSource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/MoodSource.swift
//
//  MoodSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockMoodSource: MoodSource, Cuckoo.ClassMock {
    typealias MocksType = MoodSource
    typealias Stubbing = __StubbingProxy_MoodSource
    typealias Verification = __VerificationProxy_MoodSource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_MoodSource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMoodSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_MoodSource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class MoodSourceStub: MoodSource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/Source.swift
//
//  Source.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import os

class MockSource: Source, Cuckoo.ClassMock {
    typealias MocksType = Source
    typealias Stubbing = __StubbingProxy_Source
    typealias Verification = __VerificationProxy_Source
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_Source: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Source: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SourceStub: Source {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/SourceField.swift
//
//  SourceField.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import os

class MockSourceField: SourceField, Cuckoo.ClassMock {
    typealias MocksType = SourceField
    typealias Stubbing = __StubbingProxy_SourceField
    typealias Verification = __VerificationProxy_SourceField
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "fieldName", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var fieldName: String {
        get {
            
            return cuckoo_manager.getter("fieldName", superclassCall: super.fieldName)
            
        }
        
    }
    
    // ["name": "fieldType", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "FieldType", "isReadOnly": true, "accessibility": "public"]
    public override var fieldType: FieldType {
        get {
            
            return cuckoo_manager.getter("fieldType", superclassCall: super.fieldType)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1108..<1127), nameRange: CountableRange(1108..<1110))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_SourceField: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var fieldName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSourceField, String> {
	        return .init(manager: cuckoo_manager, name: "fieldName")
	    }
	    
	    var fieldType: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSourceField, FieldType> {
	        return .init(manager: cuckoo_manager, name: "fieldType")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSourceField.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_SourceField: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var fieldName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "fieldName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var fieldType: Cuckoo.VerifyReadOnlyProperty<FieldType> {
	        return .init(manager: cuckoo_manager, name: "fieldType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SourceFieldStub: SourceField {
    
    public override var fieldName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var fieldType: FieldType {
        get {
            return DefaultValueRegistry.defaultValue(for: (FieldType).self)
        }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Storage/CodableStorage.swift
//
//  CodableStorage.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockCodableStorage: CodableStorage, Cuckoo.ClassMock {
    typealias MocksType = CodableStorage
    typealias Stubbing = __StubbingProxy_CodableStorage
    typealias Verification = __VerificationProxy_CodableStorage
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

	struct __StubbingProxy_CodableStorage: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	}

	struct __VerificationProxy_CodableStorage: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	}

}

 class CodableStorageStub: CodableStorage {
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Storage/DatabaseConnector.swift
//
//  DatabaseConnector.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import SQLite

class MockDatabaseConnector: DatabaseConnector, Cuckoo.ClassMock {
    typealias MocksType = DatabaseConnector
    typealias Stubbing = __StubbingProxy_DatabaseConnector
    typealias Verification = __VerificationProxy_DatabaseConnector
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "db", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Connection?", "isReadOnly": false, "accessibility": ""]
     override var db: Connection? {
        get {
            
            return cuckoo_manager.getter("db", superclassCall: super.db)
            
        }
        
        set {
            
            cuckoo_manager.setter("db", value: newValue, superclassCall: super.db = newValue)
            
        }
        
    }
    

    

    
    // ["name": "connect", "returnSignature": " throws", "fullyQualifiedName": "connect() throws", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnThrowingFunction"]
    public override func connect()  throws {
        
            return try cuckoo_manager.callThrows("connect() throws",
                parameters: (),
                superclassCall:
                    
                    super.connect()
                    )
        
    }
    

	struct __StubbingProxy_DatabaseConnector: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var db: Cuckoo.ClassToBeStubbedProperty<MockDatabaseConnector, Connection?> {
	        return .init(manager: cuckoo_manager, name: "db")
	    }
	    
	    
	    func connect() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDatabaseConnector.self, method: "connect() throws", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_DatabaseConnector: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var db: Cuckoo.VerifyProperty<Connection?> {
	        return .init(manager: cuckoo_manager, name: "db", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func connect() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("connect() throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class DatabaseConnectorStub: DatabaseConnector {
    
     override var db: Connection? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Connection?).self)
        }
        
        set { }
        
    }
    

    

    
    public override func connect()  throws {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/CalendarUtil.swift
//
//  CalendarUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import SwiftDate

class MockCalendarUtil: CalendarUtil, Cuckoo.ClassMock {
    typealias MocksType = CalendarUtil
    typealias Stubbing = __StubbingProxy_CalendarUtil
    typealias Verification = __VerificationProxy_CalendarUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "start", "returnSignature": " -> Date", "fullyQualifiedName": "start(of: Calendar.Component, in: Date) -> Date", "parameterSignature": "of component: Calendar.Component, in date: Date", "parameterSignatureWithoutNames": "component: Calendar.Component, date: Date", "inputTypes": "Calendar.Component, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "component, date", "call": "of: component, in: date", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("of"), name: "component", type: "Calendar.Component", range: CountableRange(516..<548), nameRange: CountableRange(516..<518)), CuckooGeneratorFramework.MethodParameter(label: Optional("in"), name: "date", type: "Date", range: CountableRange(550..<563), nameRange: CountableRange(550..<552))], "returnType": "Date", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func start(of component: Calendar.Component, in date: Date)  -> Date {
        
            return cuckoo_manager.call("start(of: Calendar.Component, in: Date) -> Date",
                parameters: (component, date),
                superclassCall:
                    
                    super.start(of: component, in: date)
                    )
        
    }
    
    // ["name": "end", "returnSignature": " -> Date", "fullyQualifiedName": "end(of: Calendar.Component, in: Date) -> Date", "parameterSignature": "of component: Calendar.Component, in date: Date", "parameterSignatureWithoutNames": "component: Calendar.Component, date: Date", "inputTypes": "Calendar.Component, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "component, date", "call": "of: component, in: date", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("of"), name: "component", type: "Calendar.Component", range: CountableRange(1092..<1124), nameRange: CountableRange(1092..<1094)), CuckooGeneratorFramework.MethodParameter(label: Optional("in"), name: "date", type: "Date", range: CountableRange(1126..<1139), nameRange: CountableRange(1126..<1128))], "returnType": "Date", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func end(of component: Calendar.Component, in date: Date)  -> Date {
        
            return cuckoo_manager.call("end(of: Calendar.Component, in: Date) -> Date",
                parameters: (component, date),
                superclassCall:
                    
                    super.end(of: component, in: date)
                    )
        
    }
    

	struct __StubbingProxy_CalendarUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func start<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(of component: M1, in date: M2) -> Cuckoo.ClassStubFunction<(Calendar.Component, Date), Date> where M1.MatchedType == Calendar.Component, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Calendar.Component, Date)>] = [wrap(matchable: component) { $0.0 }, wrap(matchable: date) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCalendarUtil.self, method: "start(of: Calendar.Component, in: Date) -> Date", parameterMatchers: matchers))
	    }
	    
	    func end<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(of component: M1, in date: M2) -> Cuckoo.ClassStubFunction<(Calendar.Component, Date), Date> where M1.MatchedType == Calendar.Component, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Calendar.Component, Date)>] = [wrap(matchable: component) { $0.0 }, wrap(matchable: date) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCalendarUtil.self, method: "end(of: Calendar.Component, in: Date) -> Date", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_CalendarUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func start<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(of component: M1, in date: M2) -> Cuckoo.__DoNotUse<Date> where M1.MatchedType == Calendar.Component, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Calendar.Component, Date)>] = [wrap(matchable: component) { $0.0 }, wrap(matchable: date) { $0.1 }]
	        return cuckoo_manager.verify("start(of: Calendar.Component, in: Date) -> Date", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func end<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(of component: M1, in date: M2) -> Cuckoo.__DoNotUse<Date> where M1.MatchedType == Calendar.Component, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Calendar.Component, Date)>] = [wrap(matchable: component) { $0.0 }, wrap(matchable: date) { $0.1 }]
	        return cuckoo_manager.verify("end(of: Calendar.Component, in: Date) -> Date", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class CalendarUtilStub: CalendarUtil {
    

    

    
    public override func start(of component: Calendar.Component, in date: Date)  -> Date {
        return DefaultValueRegistry.defaultValue(for: Date.self)
    }
    
    public override func end(of component: Calendar.Component, in date: Date)  -> Date {
        return DefaultValueRegistry.defaultValue(for: Date.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/HKQuantitySampleUtil.swift
//
//  HKQuantitySampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit

class MockHKQuantitySampleUtil: HKQuantitySampleUtil, Cuckoo.ClassMock {
    typealias MocksType = HKQuantitySampleUtil
    typealias Stubbing = __StubbingProxy_HKQuantitySampleUtil
    typealias Verification = __VerificationProxy_HKQuantitySampleUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "compute", "returnSignature": " -> [(date: Date?, value: Double)]", "fullyQualifiedName": "compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [(date: Date?, value: Double)]", "parameterSignature": "operation: QueryOperation, over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "operation: QueryOperation, samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "QueryOperation, [HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "operation, samples, unit", "call": "operation: operation, over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("operation"), name: "operation", type: "QueryOperation", range: CountableRange(309..<334), nameRange: CountableRange(309..<318)), CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(336..<368), nameRange: CountableRange(336..<340)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(370..<391), nameRange: CountableRange(370..<378))], "returnType": "[(date: Date?, value: Double)]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func compute(operation: QueryOperation, over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        
            return cuckoo_manager.call("compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [(date: Date?, value: Double)]",
                parameters: (operation, samples, unit),
                superclassCall:
                    
                    super.compute(operation: operation, over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "average", "returnSignature": " -> [(date: Date?, value: Double)]", "fullyQualifiedName": "average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(1115..<1147), nameRange: CountableRange(1115..<1119)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(1149..<1189), nameRange: CountableRange(1149..<1152)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(1191..<1212), nameRange: CountableRange(1191..<1199))], "returnType": "[(date: Date?, value: Double)]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func average(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        
            return cuckoo_manager.call("average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.average(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "average", "returnSignature": " -> Double", "fullyQualifiedName": "average(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(1858..<1890), nameRange: CountableRange(1858..<1862)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(1892..<1913), nameRange: CountableRange(1892..<1900))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func average(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("average(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.average(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "count", "returnSignature": " -> [(date: Date?, value: Double)]", "fullyQualifiedName": "count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(2249..<2281), nameRange: CountableRange(2249..<2253)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(2283..<2323), nameRange: CountableRange(2283..<2286)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(2325..<2346), nameRange: CountableRange(2325..<2333))], "returnType": "[(date: Date?, value: Double)]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func count(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        
            return cuckoo_manager.call("count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.count(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "max", "returnSignature": " -> [(date: Date?, value: Double)]", "fullyQualifiedName": "max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(2948..<2980), nameRange: CountableRange(2948..<2952)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(2982..<3022), nameRange: CountableRange(2982..<2985)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(3024..<3045), nameRange: CountableRange(3024..<3032))], "returnType": "[(date: Date?, value: Double)]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func max(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        
            return cuckoo_manager.call("max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.max(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "max", "returnSignature": " -> Double", "fullyQualifiedName": "max(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(3667..<3699), nameRange: CountableRange(3667..<3671)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(3701..<3722), nameRange: CountableRange(3701..<3709))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func max(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("max(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.max(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "min", "returnSignature": " -> [(date: Date?, value: Double)]", "fullyQualifiedName": "min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(4114..<4146), nameRange: CountableRange(4114..<4118)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(4148..<4188), nameRange: CountableRange(4148..<4151)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(4190..<4211), nameRange: CountableRange(4190..<4198))], "returnType": "[(date: Date?, value: Double)]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func min(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        
            return cuckoo_manager.call("min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.min(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "min", "returnSignature": " -> Double", "fullyQualifiedName": "min(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(4833..<4865), nameRange: CountableRange(4833..<4837)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(4867..<4888), nameRange: CountableRange(4867..<4875))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func min(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("min(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.min(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "sum", "returnSignature": " -> [(date: Date?, value: Double)]", "fullyQualifiedName": "sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(5280..<5312), nameRange: CountableRange(5280..<5284)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(5314..<5354), nameRange: CountableRange(5314..<5317)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(5356..<5377), nameRange: CountableRange(5356..<5364))], "returnType": "[(date: Date?, value: Double)]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sum(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        
            return cuckoo_manager.call("sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.sum(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "sum", "returnSignature": " -> Double", "fullyQualifiedName": "sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(5999..<6031), nameRange: CountableRange(5999..<6003)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(6033..<6054), nameRange: CountableRange(6033..<6041))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sum(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.sum(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "sortSamplesByAggregation", "returnSignature": " -> [(date: Date, samples: [HKQuantitySample])]", "fullyQualifiedName": "sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]", "parameterSignature": "_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component", "inputTypes": "[HKQuantitySample], Calendar.Component", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit", "call": "samples, aggregationUnit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "samples", type: "[HKQuantitySample]", range: CountableRange(6303..<6332), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: nil, name: "aggregationUnit", type: "Calendar.Component", range: CountableRange(6334..<6371), nameRange: CountableRange(0..<0))], "returnType": "[(date: Date, samples: [HKQuantitySample])]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sortSamplesByAggregation(_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component)  -> [(date: Date, samples: [HKQuantitySample])] {
        
            return cuckoo_manager.call("sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]",
                parameters: (samples, aggregationUnit),
                superclassCall:
                    
                    super.sortSamplesByAggregation(samples, aggregationUnit)
                    )
        
    }
    

	struct __StubbingProxy_HKQuantitySampleUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func compute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(operation: M1, over samples: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<(QueryOperation, [HKQuantitySample], HKUnit), [(date: Date?, value: Double)]> where M1.MatchedType == QueryOperation, M2.MatchedType == [HKQuantitySample], M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<(QueryOperation, [HKQuantitySample], HKUnit)>] = [wrap(matchable: operation) { $0.0 }, wrap(matchable: samples) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [(date: Date?, value: Double)]", parameterMatchers: matchers))
	    }
	    
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", parameterMatchers: matchers))
	    }
	    
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "average(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func count<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", parameterMatchers: matchers))
	    }
	    
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", parameterMatchers: matchers))
	    }
	    
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "max(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", parameterMatchers: matchers))
	    }
	    
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "min(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", parameterMatchers: matchers))
	    }
	    
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func sortSamplesByAggregation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ samples: M1, _ aggregationUnit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component), [(date: Date, samples: [HKQuantitySample])]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HKQuantitySampleUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func compute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(operation: M1, over samples: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[(date: Date?, value: Double)]> where M1.MatchedType == QueryOperation, M2.MatchedType == [HKQuantitySample], M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<(QueryOperation, [HKQuantitySample], HKUnit)>] = [wrap(matchable: operation) { $0.0 }, wrap(matchable: samples) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [(date: Date?, value: Double)]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("average(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func count<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("max(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("min(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[(date: Date?, value: Double)]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [(date: Date?, value: Double)]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sortSamplesByAggregation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ samples: M1, _ aggregationUnit: M2) -> Cuckoo.__DoNotUse<[(date: Date, samples: [HKQuantitySample])]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }]
	        return cuckoo_manager.verify("sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HKQuantitySampleUtilStub: HKQuantitySampleUtil {
    

    

    
    public override func compute(operation: QueryOperation, over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date?, value: Double)].self)
    }
    
    public override func average(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date?, value: Double)].self)
    }
    
    public override func average(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func count(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date?, value: Double)].self)
    }
    
    public override func max(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date?, value: Double)].self)
    }
    
    public override func max(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func min(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date?, value: Double)].self)
    }
    
    public override func min(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func sum(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [(date: Date?, value: Double)] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date?, value: Double)].self)
    }
    
    public override func sum(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func sortSamplesByAggregation(_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component)  -> [(date: Date, samples: [HKQuantitySample])] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date, samples: [HKQuantitySample])].self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/HKSampleUtil.swift
//
//  HKSampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit

class MockHKSampleUtil: HKSampleUtil, Cuckoo.ClassMock {
    typealias MocksType = HKSampleUtil
    typealias Stubbing = __StubbingProxy_HKSampleUtil
    typealias Verification = __VerificationProxy_HKSampleUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "sample", "returnSignature": " -> Bool", "fullyQualifiedName": "sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool", "parameterSignature": "_ sample: HKSample, occursOnOneOf daysOfWeek: Set<DayOfWeek>", "parameterSignatureWithoutNames": "sample: HKSample, daysOfWeek: Set<DayOfWeek>", "inputTypes": "HKSample, Set<DayOfWeek>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "sample, daysOfWeek", "call": "sample, occursOnOneOf: daysOfWeek", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "sample", type: "HKSample", range: CountableRange(487..<505), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("occursOnOneOf"), name: "daysOfWeek", type: "Set<DayOfWeek>", range: CountableRange(507..<547), nameRange: CountableRange(507..<520))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sample(_ sample: HKSample, occursOnOneOf daysOfWeek: Set<DayOfWeek>)  -> Bool {
        
            return cuckoo_manager.call("sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool",
                parameters: (sample, daysOfWeek),
                superclassCall:
                    
                    super.sample(sample, occursOnOneOf: daysOfWeek)
                    )
        
    }
    

	struct __StubbingProxy_HKSampleUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func sample<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ sample: M1, occursOnOneOf daysOfWeek: M2) -> Cuckoo.ClassStubFunction<(HKSample, Set<DayOfWeek>), Bool> where M1.MatchedType == HKSample, M2.MatchedType == Set<DayOfWeek> {
	        let matchers: [Cuckoo.ParameterMatcher<(HKSample, Set<DayOfWeek>)>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: daysOfWeek) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKSampleUtil.self, method: "sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HKSampleUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func sample<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ sample: M1, occursOnOneOf daysOfWeek: M2) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == HKSample, M2.MatchedType == Set<DayOfWeek> {
	        let matchers: [Cuckoo.ParameterMatcher<(HKSample, Set<DayOfWeek>)>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: daysOfWeek) { $0.1 }]
	        return cuckoo_manager.verify("sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HKSampleUtilStub: HKSampleUtil {
    

    

    
    public override func sample(_ sample: HKSample, occursOnOneOf daysOfWeek: Set<DayOfWeek>)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/TextNormalizationUtil.swift
//
//  ContractionsReplacementUtil.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockTextNormalizationUtil: TextNormalizationUtil, Cuckoo.ClassMock {
    typealias MocksType = TextNormalizationUtil
    typealias Stubbing = __StubbingProxy_TextNormalizationUtil
    typealias Verification = __VerificationProxy_TextNormalizationUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "expandContractions", "returnSignature": " -> String", "fullyQualifiedName": "expandContractions(_: String) -> String", "parameterSignature": "_ text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "text", "call": "text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "text", type: "String", range: CountableRange(4849..<4863), nameRange: CountableRange(0..<0))], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func expandContractions(_ text: String)  -> String {
        
            return cuckoo_manager.call("expandContractions(_: String) -> String",
                parameters: (text),
                superclassCall:
                    
                    super.expandContractions(text)
                    )
        
    }
    
    // ["name": "normalizeNumbers", "returnSignature": " -> String", "fullyQualifiedName": "normalizeNumbers(_: String) -> String", "parameterSignature": "_ text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "text", "call": "text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "text", type: "String", range: CountableRange(5133..<5147), nameRange: CountableRange(0..<0))], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func normalizeNumbers(_ text: String)  -> String {
        
            return cuckoo_manager.call("normalizeNumbers(_: String) -> String",
                parameters: (text),
                superclassCall:
                    
                    super.normalizeNumbers(text)
                    )
        
    }
    
    // ["name": "removePunctuation", "returnSignature": " -> String", "fullyQualifiedName": "removePunctuation(_: String) -> String", "parameterSignature": "_ text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "text", "call": "text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "text", type: "String", range: CountableRange(6773..<6787), nameRange: CountableRange(0..<0))], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func removePunctuation(_ text: String)  -> String {
        
            return cuckoo_manager.call("removePunctuation(_: String) -> String",
                parameters: (text),
                superclassCall:
                    
                    super.removePunctuation(text)
                    )
        
    }
    

	struct __StubbingProxy_TextNormalizationUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func expandContractions<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.ClassStubFunction<(String), String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTextNormalizationUtil.self, method: "expandContractions(_: String) -> String", parameterMatchers: matchers))
	    }
	    
	    func normalizeNumbers<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.ClassStubFunction<(String), String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTextNormalizationUtil.self, method: "normalizeNumbers(_: String) -> String", parameterMatchers: matchers))
	    }
	    
	    func removePunctuation<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.ClassStubFunction<(String), String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTextNormalizationUtil.self, method: "removePunctuation(_: String) -> String", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_TextNormalizationUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func expandContractions<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("expandContractions(_: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func normalizeNumbers<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("normalizeNumbers(_: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removePunctuation<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("removePunctuation(_: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class TextNormalizationUtilStub: TextNormalizationUtil {
    

    

    
    public override func expandContractions(_ text: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
    public override func normalizeNumbers(_ text: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
    public override func removePunctuation(_ text: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
}

