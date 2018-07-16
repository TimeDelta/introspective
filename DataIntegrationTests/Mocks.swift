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


// MARK: - Mocks generated from file: DataIntegration/DataTypes/DataTypes.swift
//
//  DataTypes.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

// MARK: - Mocks generated from file: DataIntegration/DataTypes/HKQuantitySampleExtension.swift
//
//  HKQuantitySampleExtension.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit
import os

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
import HealthKit

class MockHeartRate: HeartRate, Cuckoo.ClassMock {
    typealias MocksType = HeartRate
    typealias Stubbing = __StubbingProxy_HeartRate
    typealias Verification = __VerificationProxy_HeartRate
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "value", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": "public"]
    public override var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
        set {
            
            cuckoo_manager.setter("value", value: newValue, superclassCall: super.value = newValue)
            
        }
        
    }
    
    // ["name": "dates", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[DateType: Date]", "isReadOnly": false, "accessibility": "public"]
    public override var dates: [DateType: Date] {
        get {
            
            return cuckoo_manager.getter("dates", superclassCall: super.dates)
            
        }
        
        set {
            
            cuckoo_manager.setter("dates", value: newValue, superclassCall: super.dates = newValue)
            
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
	    
	    var dates: Cuckoo.ClassToBeStubbedProperty<MockHeartRate, [DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates")
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
	    
	    var dates: Cuckoo.VerifyProperty<[DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class HeartRateStub: HeartRate {
    
    public override var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    
    public override var dates: [DateType: Date] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([DateType: Date]).self)
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


// MARK: - Mocks generated from file: DataIntegration/DataTypes/NumericSample.swift
//
//  Averagable.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockNumericSample: NumericSample, Cuckoo.ProtocolMock {
    typealias MocksType = NumericSample
    typealias Stubbing = __StubbingProxy_NumericSample
    typealias Verification = __VerificationProxy_NumericSample
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "value", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": true, "accessibility": "public"]
    public var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "dates", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[DateType: Date]", "isReadOnly": true, "accessibility": "public"]
    public var dates: [DateType: Date] {
        get {
            
            return cuckoo_manager.getter("dates", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    

	struct __StubbingProxy_NumericSample: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var value: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNumericSample, Double> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    var dates: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNumericSample, [DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates")
	    }
	    
	    
	}

	struct __VerificationProxy_NumericSample: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var value: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var dates: Cuckoo.VerifyReadOnlyProperty<[DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class NumericSampleStub: NumericSample {
    
    public var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    public var dates: [DateType: Date] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([DateType: Date]).self)
        }
        
    }
    

    

    
}


class MockDoubleValueSample: DoubleValueSample, Cuckoo.ClassMock {
    typealias MocksType = DoubleValueSample
    typealias Stubbing = __StubbingProxy_DoubleValueSample
    typealias Verification = __VerificationProxy_DoubleValueSample
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "value", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": "public"]
    public override var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
        set {
            
            cuckoo_manager.setter("value", value: newValue, superclassCall: super.value = newValue)
            
        }
        
    }
    
    // ["name": "dates", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[DateType: Date]", "isReadOnly": false, "accessibility": "public"]
    public override var dates: [DateType: Date] {
        get {
            
            return cuckoo_manager.getter("dates", superclassCall: super.dates)
            
        }
        
        set {
            
            cuckoo_manager.setter("dates", value: newValue, superclassCall: super.dates = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_DoubleValueSample: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var value: Cuckoo.ClassToBeStubbedProperty<MockDoubleValueSample, Double> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    var dates: Cuckoo.ClassToBeStubbedProperty<MockDoubleValueSample, [DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates")
	    }
	    
	    
	}

	struct __VerificationProxy_DoubleValueSample: Cuckoo.VerificationProxy {
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
	    
	    var dates: Cuckoo.VerifyProperty<[DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class DoubleValueSampleStub: DoubleValueSample {
    
    public override var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    
    public override var dates: [DateType: Date] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([DateType: Date]).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/Sample.swift
//
//  Sample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockSample: Sample, Cuckoo.ProtocolMock {
    typealias MocksType = Sample
    typealias Stubbing = __StubbingProxy_Sample
    typealias Verification = __VerificationProxy_Sample
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "dates", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[DateType: Date]", "isReadOnly": true, "accessibility": "public"]
    public var dates: [DateType: Date] {
        get {
            
            return cuckoo_manager.getter("dates", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Sample: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var dates: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSample, [DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates")
	    }
	    
	    
	}

	struct __VerificationProxy_Sample: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var dates: Cuckoo.VerifyReadOnlyProperty<[DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class SampleStub: Sample {
    
    public var dates: [DateType: Date] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([DateType: Date]).self)
        }
        
    }
    

    

    
}


class MockAnySample: AnySample, Cuckoo.ClassMock {
    typealias MocksType = AnySample
    typealias Stubbing = __StubbingProxy_AnySample
    typealias Verification = __VerificationProxy_AnySample
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "dates", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[DateType: Date]", "isReadOnly": false, "accessibility": "public"]
    public override var dates: [DateType: Date] {
        get {
            
            return cuckoo_manager.getter("dates", superclassCall: super.dates)
            
        }
        
        set {
            
            cuckoo_manager.setter("dates", value: newValue, superclassCall: super.dates = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_AnySample: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var dates: Cuckoo.ClassToBeStubbedProperty<MockAnySample, [DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates")
	    }
	    
	    
	}

	struct __VerificationProxy_AnySample: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var dates: Cuckoo.VerifyProperty<[DateType: Date]> {
	        return .init(manager: cuckoo_manager, name: "dates", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class AnySampleStub: AnySample {
    
    public override var dates: [DateType: Date] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([DateType: Date]).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/AdvancedQuestion.swift
//
//  AdvancedQuestion.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockAdvancedQuestion: AdvancedQuestion, Cuckoo.ClassMock {
    typealias MocksType = AdvancedQuestion
    typealias Stubbing = __StubbingProxy_AdvancedQuestion
    typealias Verification = __VerificationProxy_AdvancedQuestion
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "questionParts", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[Query<AnySample>]", "isReadOnly": false, "accessibility": "public"]
    public override var questionParts: [Query<AnySample>] {
        get {
            
            return cuckoo_manager.getter("questionParts", superclassCall: super.questionParts)
            
        }
        
        set {
            
            cuckoo_manager.setter("questionParts", value: newValue, superclassCall: super.questionParts = newValue)
            
        }
        
    }
    

    

    
    // ["name": "parse", "returnSignature": "", "fullyQualifiedName": "parse(callback: (Error?) -> ())", "parameterSignature": "callback: (Error?) -> ()", "parameterSignatureWithoutNames": "callback: (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "(Error?) -> ()", range: CountableRange(330..<354), nameRange: CountableRange(330..<338))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func parse(callback: (Error?) -> ())  {
        	return withoutActuallyEscaping(callback, do: { (callback) in

            return cuckoo_manager.call("parse(callback: (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.parse(callback: callback)
                    )
        	})

    }
    
    // ["name": "answer", "returnSignature": "", "fullyQualifiedName": "answer(callback: @escaping (Answer?, Error?) -> ())", "parameterSignature": "callback: @escaping (Answer?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Answer?, Error?) -> ()", "inputTypes": "(Answer?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Answer?, Error?) -> ()", range: CountableRange(399..<442), nameRange: CountableRange(399..<407))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func answer(callback: @escaping (Answer?, Error?) -> ())  {
        
            return cuckoo_manager.call("answer(callback: @escaping (Answer?, Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.answer(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_AdvancedQuestion: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var questionParts: Cuckoo.ClassToBeStubbedProperty<MockAdvancedQuestion, [Query<AnySample>]> {
	        return .init(manager: cuckoo_manager, name: "questionParts")
	    }
	    
	    
	    func parse<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Error?) -> ())> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAdvancedQuestion.self, method: "parse(callback: (Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func answer<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Answer?, Error?) -> ())> where M1.MatchedType == (Answer?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Answer?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAdvancedQuestion.self, method: "answer(callback: @escaping (Answer?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_AdvancedQuestion: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var questionParts: Cuckoo.VerifyProperty<[Query<AnySample>]> {
	        return .init(manager: cuckoo_manager, name: "questionParts", callMatcher: callMatcher, sourceLocation: sourceLocation)
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

 class AdvancedQuestionStub: AdvancedQuestion {
    
    public override var questionParts: [Query<AnySample>] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Query<AnySample>]).self)
        }
        
        set { }
        
    }
    

    

    
     override func parse(callback: (Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     override func answer(callback: @escaping (Answer?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
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


// MARK: - Mocks generated from file: DataIntegration/Questions/Attributes.swift
//
//  Attributes.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

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


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/AttributeRestriction.swift
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
    
    // ["name": "abbreviation", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var abbreviation: String {
        get {
            
            return cuckoo_manager.getter("abbreviation", superclassCall: super.abbreviation)
            
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
	    
	    var abbreviation: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockDayOfWeek, String> {
	        return .init(manager: cuckoo_manager, name: "abbreviation")
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
	    
	    var abbreviation: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "abbreviation", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
    
    public override var abbreviation: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
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

    
    // ["name": "timeConstraints", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Set<TimeConstraint>", "isReadOnly": false, "accessibility": "public"]
    public override var timeConstraints: Set<TimeConstraint> {
        get {
            
            return cuckoo_manager.getter("timeConstraints", superclassCall: super.timeConstraints)
            
        }
        
        set {
            
            cuckoo_manager.setter("timeConstraints", value: newValue, superclassCall: super.timeConstraints = newValue)
            
        }
        
    }
    
    // ["name": "attributeRestrictions", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[AttributeRestriction]", "isReadOnly": false, "accessibility": "public"]
    public override var attributeRestrictions: [AttributeRestriction] {
        get {
            
            return cuckoo_manager.getter("attributeRestrictions", superclassCall: super.attributeRestrictions)
            
        }
        
        set {
            
            cuckoo_manager.setter("attributeRestrictions", value: newValue, superclassCall: super.attributeRestrictions = newValue)
            
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
    
    // ["name": "numberOfDatesPerSample", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Int", "isReadOnly": true, "accessibility": "public"]
    public override var numberOfDatesPerSample: Int {
        get {
            
            return cuckoo_manager.getter("numberOfDatesPerSample", superclassCall: super.numberOfDatesPerSample)
            
        }
        
    }
    

    

    
    // ["name": "runQuery", "returnSignature": "", "fullyQualifiedName": "runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ())", "parameterSignature": "callback: @escaping (QueryResult<SampleType>?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (QueryResult<SampleType>?, Error?) -> ()", "inputTypes": "(QueryResult<SampleType>?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (QueryResult<SampleType>?, Error?) -> ()", range: CountableRange(742..<802), nameRange: CountableRange(742..<750))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ())  {
        
            return cuckoo_manager.call("runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ())",
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
	    
	    var timeConstraints: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Set<TimeConstraint>> {
	        return .init(manager: cuckoo_manager, name: "timeConstraints")
	    }
	    
	    var attributeRestrictions: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, [AttributeRestriction]> {
	        return .init(manager: cuckoo_manager, name: "attributeRestrictions")
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly")
	    }
	    
	    var numberOfDatesPerSample: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockHeartRateQuery, Int> {
	        return .init(manager: cuckoo_manager, name: "numberOfDatesPerSample")
	    }
	    
	    
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((QueryResult<SampleType>?, Error?) -> ())> where M1.MatchedType == (QueryResult<SampleType>?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult<SampleType>?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuery.self, method: "runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ())", parameterMatchers: matchers))
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
	
	    
	    var timeConstraints: Cuckoo.VerifyProperty<Set<TimeConstraint>> {
	        return .init(manager: cuckoo_manager, name: "timeConstraints", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var attributeRestrictions: Cuckoo.VerifyProperty<[AttributeRestriction]> {
	        return .init(manager: cuckoo_manager, name: "attributeRestrictions", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var numberOfDatesPerSample: Cuckoo.VerifyReadOnlyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "numberOfDatesPerSample", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (QueryResult<SampleType>?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult<SampleType>?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateQueryStub: HeartRateQuery {
    
    public override var timeConstraints: Set<TimeConstraint> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<TimeConstraint>).self)
        }
        
        set { }
        
    }
    
    public override var attributeRestrictions: [AttributeRestriction] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AttributeRestriction]).self)
        }
        
        set { }
        
    }
    
    public override var mostRecentEntryOnly: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    public override var numberOfDatesPerSample: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
    }
    

    

    
    public override func runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
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

    

    

    
    // ["name": "getHeartRates", "returnSignature": "", "fullyQualifiedName": "getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", "parameterSignature": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "inputTypes": "NSPredicate, (Array<HKQuantitySample>?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, callback", "call": "predicate: predicate, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(639..<661), nameRange: CountableRange(639..<648)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Array<HKQuantitySample>?, Error?)->()", range: CountableRange(663..<720), nameRange: CountableRange(663..<671))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())  {
        
            return cuckoo_manager.call("getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())",
                parameters: (predicate, callback),
                superclassCall:
                    
                    super.getHeartRates(predicate: predicate, callback: callback)
                    )
        
    }
    
    // ["name": "getStatisticsFromHeartRates", "returnSignature": "", "fullyQualifiedName": "getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", "parameterSignature": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "inputTypes": "NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, statsOptions, callback", "call": "predicate: predicate, statsOptions: statsOptions, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(1023..<1045), nameRange: CountableRange(1023..<1032)), CuckooGeneratorFramework.MethodParameter(label: Optional("statsOptions"), name: "statsOptions", type: "HKStatisticsOptions", range: CountableRange(1047..<1080), nameRange: CountableRange(1047..<1059)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (HKStatistics?, Error?)->()", range: CountableRange(1082..<1128), nameRange: CountableRange(1082..<1090))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())  {
        
            return cuckoo_manager.call("getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())",
                parameters: (predicate, statsOptions, callback),
                superclassCall:
                    
                    super.getStatisticsFromHeartRates(predicate: predicate, statsOptions: statsOptions, callback: callback)
                    )
        
    }
    
    // ["name": "getAuthorization", "returnSignature": "", "fullyQualifiedName": "getAuthorization(callback: @escaping (Error?) -> ())", "parameterSignature": "callback: @escaping (Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Error?) -> ()", range: CountableRange(1440..<1474), nameRange: CountableRange(1440..<1448))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
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

// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/TimeConstraint.swift
//
//  TimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import os

class MockTimeConstraint: TimeConstraint, Cuckoo.ClassMock {
    typealias MocksType = TimeConstraint
    typealias Stubbing = __StubbingProxy_TimeConstraint
    typealias Verification = __VerificationProxy_TimeConstraint
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "description", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var description: String {
        get {
            
            return cuckoo_manager.getter("description", superclassCall: super.description)
            
        }
        
    }
    
    // ["name": "useStartOrEndDate", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "StartOrEnd", "isReadOnly": false, "accessibility": "public"]
    public override var useStartOrEndDate: StartOrEnd {
        get {
            
            return cuckoo_manager.getter("useStartOrEndDate", superclassCall: super.useStartOrEndDate)
            
        }
        
        set {
            
            cuckoo_manager.setter("useStartOrEndDate", value: newValue, superclassCall: super.useStartOrEndDate = newValue)
            
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
    
    // ["name": "specificDate", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": "public"]
    public override var specificDate: Date? {
        get {
            
            return cuckoo_manager.getter("specificDate", superclassCall: super.specificDate)
            
        }
        
        set {
            
            cuckoo_manager.setter("specificDate", value: newValue, superclassCall: super.specificDate = newValue)
            
        }
        
    }
    
    // ["name": "constraintType", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "ConstraintType", "isReadOnly": false, "accessibility": "public"]
    public override var constraintType: ConstraintType {
        get {
            
            return cuckoo_manager.getter("constraintType", superclassCall: super.constraintType)
            
        }
        
        set {
            
            cuckoo_manager.setter("constraintType", value: newValue, superclassCall: super.constraintType = newValue)
            
        }
        
    }
    

    

    
    // ["name": "isValid", "returnSignature": " -> Bool", "fullyQualifiedName": "isValid() -> Bool", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func isValid()  -> Bool {
        
            return cuckoo_manager.call("isValid() -> Bool",
                parameters: (),
                superclassCall:
                    
                    super.isValid()
                    )
        
    }
    

	struct __StubbingProxy_TimeConstraint: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var description: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockTimeConstraint, String> {
	        return .init(manager: cuckoo_manager, name: "description")
	    }
	    
	    var useStartOrEndDate: Cuckoo.ClassToBeStubbedProperty<MockTimeConstraint, StartOrEnd> {
	        return .init(manager: cuckoo_manager, name: "useStartOrEndDate")
	    }
	    
	    var daysOfWeek: Cuckoo.ClassToBeStubbedProperty<MockTimeConstraint, Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek")
	    }
	    
	    var specificDate: Cuckoo.ClassToBeStubbedProperty<MockTimeConstraint, Date?> {
	        return .init(manager: cuckoo_manager, name: "specificDate")
	    }
	    
	    var constraintType: Cuckoo.ClassToBeStubbedProperty<MockTimeConstraint, ConstraintType> {
	        return .init(manager: cuckoo_manager, name: "constraintType")
	    }
	    
	    
	    func isValid() -> Cuckoo.ClassStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTimeConstraint.self, method: "isValid() -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_TimeConstraint: Cuckoo.VerificationProxy {
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
	    
	    var useStartOrEndDate: Cuckoo.VerifyProperty<StartOrEnd> {
	        return .init(manager: cuckoo_manager, name: "useStartOrEndDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var daysOfWeek: Cuckoo.VerifyProperty<Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var specificDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "specificDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var constraintType: Cuckoo.VerifyProperty<ConstraintType> {
	        return .init(manager: cuckoo_manager, name: "constraintType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func isValid() -> Cuckoo.__DoNotUse<Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("isValid() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class TimeConstraintStub: TimeConstraint {
    
    public override var description: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var useStartOrEndDate: StartOrEnd {
        get {
            return DefaultValueRegistry.defaultValue(for: (StartOrEnd).self)
        }
        
        set { }
        
    }
    
    public override var daysOfWeek: Set<DayOfWeek> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<DayOfWeek>).self)
        }
        
        set { }
        
    }
    
    public override var specificDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
    public override var constraintType: ConstraintType {
        get {
            return DefaultValueRegistry.defaultValue(for: (ConstraintType).self)
        }
        
        set { }
        
    }
    

    

    
    public override func isValid()  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Question.swift
//
//  Question.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQuestion: Question, Cuckoo.ProtocolMock {
    typealias MocksType = Question
    typealias Stubbing = __StubbingProxy_Question
    typealias Verification = __VerificationProxy_Question
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    

    

    
    // ["name": "parse", "returnSignature": "", "fullyQualifiedName": "parse(callback: (Error?) -> ())", "parameterSignature": "callback: (Error?) -> ()", "parameterSignatureWithoutNames": "callback: (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": true, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "(Error?) -> ()", range: CountableRange(193..<217), nameRange: CountableRange(193..<201))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func parse(callback: (Error?) -> ())  {
        	return withoutActuallyEscaping(callback, do: { (callback) in

            return cuckoo_manager.call("parse(callback: (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        	})

    }
    
    // ["name": "answer", "returnSignature": "", "fullyQualifiedName": "answer(callback: @escaping (Answer?, Error?) -> ())", "parameterSignature": "callback: @escaping (Answer?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Answer?, Error?) -> ()", "inputTypes": "(Answer?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": true, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Answer?, Error?) -> ()", range: CountableRange(232..<275), nameRange: CountableRange(232..<240))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func answer(callback: @escaping (Answer?, Error?) -> ())  {
        
            return cuckoo_manager.call("answer(callback: @escaping (Answer?, Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_Question: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func parse<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ProtocolStubNoReturnFunction<((Error?) -> ())> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestion.self, method: "parse(callback: (Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func answer<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ProtocolStubNoReturnFunction<((Answer?, Error?) -> ())> where M1.MatchedType == (Answer?, Error?) -> () {
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
    

    

    
     func parse(callback: (Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func answer(callback: @escaping (Answer?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/QuestionPart.swift
//
//  QuestionPart.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

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


// MARK: - Mocks generated from file: DataIntegration/Questions/TextQuestion.swift
////
////  Question.swift
////  Data Integration
////
////  Created by Bryan Nova on 6/24/18.
////  Copyright © 2018 Bryan Nova. All rights reserved.
////
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage
import os

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


// MARK: - Mocks generated from file: DataIntegration/UI/AdvancedQuestion/AttributeRestrictionTableViewCell.swift
//
//  AttributeRestrictionTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import UIKit

class MockAttributeRestrictionTableViewCell: AttributeRestrictionTableViewCell, Cuckoo.ClassMock {
    typealias MocksType = AttributeRestrictionTableViewCell
    typealias Stubbing = __StubbingProxy_AttributeRestrictionTableViewCell
    typealias Verification = __VerificationProxy_AttributeRestrictionTableViewCell
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "label", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "UILabel!", "isReadOnly": false, "accessibility": ""]
     override var label: UILabel! {
        get {
            
            return cuckoo_manager.getter("label", superclassCall: super.label)
            
        }
        
        set {
            
            cuckoo_manager.setter("label", value: newValue, superclassCall: super.label = newValue)
            
        }
        
    }
    
    // ["name": "attributeRestriction", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "AttributeRestriction!", "isReadOnly": false, "accessibility": ""]
     override var attributeRestriction: AttributeRestriction! {
        get {
            
            return cuckoo_manager.getter("attributeRestriction", superclassCall: super.attributeRestriction)
            
        }
        
        set {
            
            cuckoo_manager.setter("attributeRestriction", value: newValue, superclassCall: super.attributeRestriction = newValue)
            
        }
        
    }
    

    

    
    // ["name": "awakeFromNib", "returnSignature": "", "fullyQualifiedName": "awakeFromNib()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func awakeFromNib()  {
        
            return cuckoo_manager.call("awakeFromNib()",
                parameters: (),
                superclassCall:
                    
                    super.awakeFromNib()
                    )
        
    }
    

	struct __StubbingProxy_AttributeRestrictionTableViewCell: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var label: Cuckoo.ClassToBeStubbedProperty<MockAttributeRestrictionTableViewCell, UILabel?> {
	        return .init(manager: cuckoo_manager, name: "label")
	    }
	    
	    var attributeRestriction: Cuckoo.ClassToBeStubbedProperty<MockAttributeRestrictionTableViewCell, AttributeRestriction?> {
	        return .init(manager: cuckoo_manager, name: "attributeRestriction")
	    }
	    
	    
	    func awakeFromNib() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAttributeRestrictionTableViewCell.self, method: "awakeFromNib()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_AttributeRestrictionTableViewCell: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var label: Cuckoo.VerifyProperty<UILabel?> {
	        return .init(manager: cuckoo_manager, name: "label", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var attributeRestriction: Cuckoo.VerifyProperty<AttributeRestriction?> {
	        return .init(manager: cuckoo_manager, name: "attributeRestriction", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func awakeFromNib() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("awakeFromNib()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class AttributeRestrictionTableViewCellStub: AttributeRestrictionTableViewCell {
    
     override var label: UILabel! {
        get {
            return DefaultValueRegistry.defaultValue(for: (UILabel!).self)
        }
        
        set { }
        
    }
    
     override var attributeRestriction: AttributeRestriction! {
        get {
            return DefaultValueRegistry.defaultValue(for: (AttributeRestriction!).self)
        }
        
        set { }
        
    }
    

    

    
     override func awakeFromNib()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/UI/AdvancedQuestion/TimeConstraintTableViewCell.swift
//
//  TimeConstraintTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import SwiftDate
import UIKit
import os

class MockTimeConstraintTableViewCell: TimeConstraintTableViewCell, Cuckoo.ClassMock {
    typealias MocksType = TimeConstraintTableViewCell
    typealias Stubbing = __StubbingProxy_TimeConstraintTableViewCell
    typealias Verification = __VerificationProxy_TimeConstraintTableViewCell
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "label", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "UILabel!", "isReadOnly": false, "accessibility": ""]
     override var label: UILabel! {
        get {
            
            return cuckoo_manager.getter("label", superclassCall: super.label)
            
        }
        
        set {
            
            cuckoo_manager.setter("label", value: newValue, superclassCall: super.label = newValue)
            
        }
        
    }
    
    // ["name": "timeConstraint", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "TimeConstraint!", "isReadOnly": false, "accessibility": ""]
     override var timeConstraint: TimeConstraint! {
        get {
            
            return cuckoo_manager.getter("timeConstraint", superclassCall: super.timeConstraint)
            
        }
        
        set {
            
            cuckoo_manager.setter("timeConstraint", value: newValue, superclassCall: super.timeConstraint = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_TimeConstraintTableViewCell: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var label: Cuckoo.ClassToBeStubbedProperty<MockTimeConstraintTableViewCell, UILabel?> {
	        return .init(manager: cuckoo_manager, name: "label")
	    }
	    
	    var timeConstraint: Cuckoo.ClassToBeStubbedProperty<MockTimeConstraintTableViewCell, TimeConstraint?> {
	        return .init(manager: cuckoo_manager, name: "timeConstraint")
	    }
	    
	    
	}

	struct __VerificationProxy_TimeConstraintTableViewCell: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var label: Cuckoo.VerifyProperty<UILabel?> {
	        return .init(manager: cuckoo_manager, name: "label", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var timeConstraint: Cuckoo.VerifyProperty<TimeConstraint?> {
	        return .init(manager: cuckoo_manager, name: "timeConstraint", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class TimeConstraintTableViewCellStub: TimeConstraintTableViewCell {
    
     override var label: UILabel! {
        get {
            return DefaultValueRegistry.defaultValue(for: (UILabel!).self)
        }
        
        set { }
        
    }
    
     override var timeConstraint: TimeConstraint! {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeConstraint!).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/UI/Results/HeartRateTableViewCell.swift
//
//  HeartRateTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import SwiftDate
import UIKit

class MockHeartRateTableViewCell: HeartRateTableViewCell, Cuckoo.ClassMock {
    typealias MocksType = HeartRateTableViewCell
    typealias Stubbing = __StubbingProxy_HeartRateTableViewCell
    typealias Verification = __VerificationProxy_HeartRateTableViewCell
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "heartRate", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "HeartRate!", "isReadOnly": false, "accessibility": "public"]
    public override var heartRate: HeartRate! {
        get {
            
            return cuckoo_manager.getter("heartRate", superclassCall: super.heartRate)
            
        }
        
        set {
            
            cuckoo_manager.setter("heartRate", value: newValue, superclassCall: super.heartRate = newValue)
            
        }
        
    }
    
    // ["name": "valueLabel", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "UILabel!", "isReadOnly": false, "accessibility": ""]
     override var valueLabel: UILabel! {
        get {
            
            return cuckoo_manager.getter("valueLabel", superclassCall: super.valueLabel)
            
        }
        
        set {
            
            cuckoo_manager.setter("valueLabel", value: newValue, superclassCall: super.valueLabel = newValue)
            
        }
        
    }
    
    // ["name": "timestampLabel", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "UILabel!", "isReadOnly": false, "accessibility": ""]
     override var timestampLabel: UILabel! {
        get {
            
            return cuckoo_manager.getter("timestampLabel", superclassCall: super.timestampLabel)
            
        }
        
        set {
            
            cuckoo_manager.setter("timestampLabel", value: newValue, superclassCall: super.timestampLabel = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_HeartRateTableViewCell: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var heartRate: Cuckoo.ClassToBeStubbedProperty<MockHeartRateTableViewCell, HeartRate?> {
	        return .init(manager: cuckoo_manager, name: "heartRate")
	    }
	    
	    var valueLabel: Cuckoo.ClassToBeStubbedProperty<MockHeartRateTableViewCell, UILabel?> {
	        return .init(manager: cuckoo_manager, name: "valueLabel")
	    }
	    
	    var timestampLabel: Cuckoo.ClassToBeStubbedProperty<MockHeartRateTableViewCell, UILabel?> {
	        return .init(manager: cuckoo_manager, name: "timestampLabel")
	    }
	    
	    
	}

	struct __VerificationProxy_HeartRateTableViewCell: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var heartRate: Cuckoo.VerifyProperty<HeartRate?> {
	        return .init(manager: cuckoo_manager, name: "heartRate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var valueLabel: Cuckoo.VerifyProperty<UILabel?> {
	        return .init(manager: cuckoo_manager, name: "valueLabel", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var timestampLabel: Cuckoo.VerifyProperty<UILabel?> {
	        return .init(manager: cuckoo_manager, name: "timestampLabel", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class HeartRateTableViewCellStub: HeartRateTableViewCell {
    
    public override var heartRate: HeartRate! {
        get {
            return DefaultValueRegistry.defaultValue(for: (HeartRate!).self)
        }
        
        set { }
        
    }
    
     override var valueLabel: UILabel! {
        get {
            return DefaultValueRegistry.defaultValue(for: (UILabel!).self)
        }
        
        set { }
        
    }
    
     override var timestampLabel: UILabel! {
        get {
            return DefaultValueRegistry.defaultValue(for: (UILabel!).self)
        }
        
        set { }
        
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

    

    

    
    // ["name": "start", "returnSignature": " -> Date", "fullyQualifiedName": "start(of: Calendar.Component, in: Date) -> Date", "parameterSignature": "of component: Calendar.Component, in date: Date", "parameterSignatureWithoutNames": "component: Calendar.Component, date: Date", "inputTypes": "Calendar.Component, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "component, date", "call": "of: component, in: date", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("of"), name: "component", type: "Calendar.Component", range: CountableRange(979..<1011), nameRange: CountableRange(979..<981)), CuckooGeneratorFramework.MethodParameter(label: Optional("in"), name: "date", type: "Date", range: CountableRange(1013..<1026), nameRange: CountableRange(1013..<1015))], "returnType": "Date", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func start(of component: Calendar.Component, in date: Date)  -> Date {
        
            return cuckoo_manager.call("start(of: Calendar.Component, in: Date) -> Date",
                parameters: (component, date),
                superclassCall:
                    
                    super.start(of: component, in: date)
                    )
        
    }
    
    // ["name": "end", "returnSignature": " -> Date", "fullyQualifiedName": "end(of: Calendar.Component, in: Date) -> Date", "parameterSignature": "of component: Calendar.Component, in date: Date", "parameterSignatureWithoutNames": "component: Calendar.Component, date: Date", "inputTypes": "Calendar.Component, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "component, date", "call": "of: component, in: date", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("of"), name: "component", type: "Calendar.Component", range: CountableRange(1555..<1587), nameRange: CountableRange(1555..<1557)), CuckooGeneratorFramework.MethodParameter(label: Optional("in"), name: "date", type: "Date", range: CountableRange(1589..<1602), nameRange: CountableRange(1589..<1591))], "returnType": "Date", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func end(of component: Calendar.Component, in date: Date)  -> Date {
        
            return cuckoo_manager.call("end(of: Calendar.Component, in: Date) -> Date",
                parameters: (component, date),
                superclassCall:
                    
                    super.end(of: component, in: date)
                    )
        
    }
    
    // ["name": "string", "returnSignature": " -> String", "fullyQualifiedName": "string(for: Date, inFormat: String) -> String", "parameterSignature": "for date: Date, inFormat format: String", "parameterSignatureWithoutNames": "date: Date, format: String", "inputTypes": "Date, String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "date, format", "call": "for: date, inFormat: format", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("for"), name: "date", type: "Date", range: CountableRange(1851..<1865), nameRange: CountableRange(1851..<1854)), CuckooGeneratorFramework.MethodParameter(label: Optional("inFormat"), name: "format", type: "String", range: CountableRange(1867..<1914), nameRange: CountableRange(1867..<1875))], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func string(for date: Date, inFormat format: String)  -> String {
        
            return cuckoo_manager.call("string(for: Date, inFormat: String) -> String",
                parameters: (date, format),
                superclassCall:
                    
                    super.string(for: date, inFormat: format)
                    )
        
    }
    
    // ["name": "date", "returnSignature": " -> Bool", "fullyQualifiedName": "date(_: Date, occursOnSame: Calendar.Component, as: Date) -> Bool", "parameterSignature": "_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date", "parameterSignatureWithoutNames": "date1: Date, component: Calendar.Component, date2: Date", "inputTypes": "Date, Calendar.Component, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "date1, component, date2", "call": "date1, occursOnSame: component, as: date2", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "date1", type: "Date", range: CountableRange(2136..<2149), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("occursOnSame"), name: "component", type: "Calendar.Component", range: CountableRange(2151..<2193), nameRange: CountableRange(2151..<2163)), CuckooGeneratorFramework.MethodParameter(label: Optional("as"), name: "date2", type: "Date", range: CountableRange(2195..<2209), nameRange: CountableRange(2195..<2197))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date)  -> Bool {
        
            return cuckoo_manager.call("date(_: Date, occursOnSame: Calendar.Component, as: Date) -> Bool",
                parameters: (date1, component, date2),
                superclassCall:
                    
                    super.date(date1, occursOnSame: component, as: date2)
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
	    
	    func string<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for date: M1, inFormat format: M2) -> Cuckoo.ClassStubFunction<(Date, String), String> where M1.MatchedType == Date, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(Date, String)>] = [wrap(matchable: date) { $0.0 }, wrap(matchable: format) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCalendarUtil.self, method: "string(for: Date, inFormat: String) -> String", parameterMatchers: matchers))
	    }
	    
	    func date<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ date1: M1, occursOnSame component: M2, as date2: M3) -> Cuckoo.ClassStubFunction<(Date, Calendar.Component, Date), Bool> where M1.MatchedType == Date, M2.MatchedType == Calendar.Component, M3.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date, Calendar.Component, Date)>] = [wrap(matchable: date1) { $0.0 }, wrap(matchable: component) { $0.1 }, wrap(matchable: date2) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCalendarUtil.self, method: "date(_: Date, occursOnSame: Calendar.Component, as: Date) -> Bool", parameterMatchers: matchers))
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
	    
	    @discardableResult
	    func string<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for date: M1, inFormat format: M2) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == Date, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(Date, String)>] = [wrap(matchable: date) { $0.0 }, wrap(matchable: format) { $0.1 }]
	        return cuckoo_manager.verify("string(for: Date, inFormat: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func date<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ date1: M1, occursOnSame component: M2, as date2: M3) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == Date, M2.MatchedType == Calendar.Component, M3.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date, Calendar.Component, Date)>] = [wrap(matchable: date1) { $0.0 }, wrap(matchable: component) { $0.1 }, wrap(matchable: date2) { $0.2 }]
	        return cuckoo_manager.verify("date(_: Date, occursOnSame: Calendar.Component, as: Date) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
    public override func string(for date: Date, inFormat format: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
    public override func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date)  -> Bool {
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


// MARK: - Mocks generated from file: DataIntegration/Util/TimeConstraintUtil.swift
//
//  TimeConstraintUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockTimeConstraintUtil: TimeConstraintUtil, Cuckoo.ClassMock {
    typealias MocksType = TimeConstraintUtil
    typealias Stubbing = __StubbingProxy_TimeConstraintUtil
    typealias Verification = __VerificationProxy_TimeConstraintUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "getStartAndEndDatesFrom", "returnSignature": " -> (start: Date?, end: Date?)", "fullyQualifiedName": "getStartAndEndDatesFrom(timeConstraints: Set<TimeConstraint>) -> (start: Date?, end: Date?)", "parameterSignature": "timeConstraints: Set<TimeConstraint>", "parameterSignatureWithoutNames": "timeConstraints: Set<TimeConstraint>", "inputTypes": "Set<TimeConstraint>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "timeConstraints", "call": "timeConstraints: timeConstraints", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("timeConstraints"), name: "timeConstraints", type: "Set<TimeConstraint>", range: CountableRange(243..<279), nameRange: CountableRange(243..<258))], "returnType": "(start: Date?, end: Date?)", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func getStartAndEndDatesFrom(timeConstraints: Set<TimeConstraint>)  -> (start: Date?, end: Date?) {
        
            return cuckoo_manager.call("getStartAndEndDatesFrom(timeConstraints: Set<TimeConstraint>) -> (start: Date?, end: Date?)",
                parameters: (timeConstraints),
                superclassCall:
                    
                    super.getStartAndEndDatesFrom(timeConstraints: timeConstraints)
                    )
        
    }
    
    // ["name": "getDaysOfWeekFrom", "returnSignature": " -> Set<DayOfWeek>", "fullyQualifiedName": "getDaysOfWeekFrom(timeConstraints: Set<TimeConstraint>) -> Set<DayOfWeek>", "parameterSignature": "timeConstraints: Set<TimeConstraint>", "parameterSignatureWithoutNames": "timeConstraints: Set<TimeConstraint>", "inputTypes": "Set<TimeConstraint>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "timeConstraints", "call": "timeConstraints: timeConstraints", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("timeConstraints"), name: "timeConstraints", type: "Set<TimeConstraint>", range: CountableRange(744..<780), nameRange: CountableRange(744..<759))], "returnType": "Set<DayOfWeek>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func getDaysOfWeekFrom(timeConstraints: Set<TimeConstraint>)  -> Set<DayOfWeek> {
        
            return cuckoo_manager.call("getDaysOfWeekFrom(timeConstraints: Set<TimeConstraint>) -> Set<DayOfWeek>",
                parameters: (timeConstraints),
                superclassCall:
                    
                    super.getDaysOfWeekFrom(timeConstraints: timeConstraints)
                    )
        
    }
    

	struct __StubbingProxy_TimeConstraintUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getStartAndEndDatesFrom<M1: Cuckoo.Matchable>(timeConstraints: M1) -> Cuckoo.ClassStubFunction<(Set<TimeConstraint>), (start: Date?, end: Date?)> where M1.MatchedType == Set<TimeConstraint> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<TimeConstraint>)>] = [wrap(matchable: timeConstraints) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTimeConstraintUtil.self, method: "getStartAndEndDatesFrom(timeConstraints: Set<TimeConstraint>) -> (start: Date?, end: Date?)", parameterMatchers: matchers))
	    }
	    
	    func getDaysOfWeekFrom<M1: Cuckoo.Matchable>(timeConstraints: M1) -> Cuckoo.ClassStubFunction<(Set<TimeConstraint>), Set<DayOfWeek>> where M1.MatchedType == Set<TimeConstraint> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<TimeConstraint>)>] = [wrap(matchable: timeConstraints) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTimeConstraintUtil.self, method: "getDaysOfWeekFrom(timeConstraints: Set<TimeConstraint>) -> Set<DayOfWeek>", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_TimeConstraintUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getStartAndEndDatesFrom<M1: Cuckoo.Matchable>(timeConstraints: M1) -> Cuckoo.__DoNotUse<(start: Date?, end: Date?)> where M1.MatchedType == Set<TimeConstraint> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<TimeConstraint>)>] = [wrap(matchable: timeConstraints) { $0 }]
	        return cuckoo_manager.verify("getStartAndEndDatesFrom(timeConstraints: Set<TimeConstraint>) -> (start: Date?, end: Date?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getDaysOfWeekFrom<M1: Cuckoo.Matchable>(timeConstraints: M1) -> Cuckoo.__DoNotUse<Set<DayOfWeek>> where M1.MatchedType == Set<TimeConstraint> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<TimeConstraint>)>] = [wrap(matchable: timeConstraints) { $0 }]
	        return cuckoo_manager.verify("getDaysOfWeekFrom(timeConstraints: Set<TimeConstraint>) -> Set<DayOfWeek>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class TimeConstraintUtilStub: TimeConstraintUtil {
    

    

    
    public override func getStartAndEndDatesFrom(timeConstraints: Set<TimeConstraint>)  -> (start: Date?, end: Date?) {
        return DefaultValueRegistry.defaultValue(for: (start: Date?, end: Date?).self)
    }
    
    public override func getDaysOfWeekFrom(timeConstraints: Set<TimeConstraint>)  -> Set<DayOfWeek> {
        return DefaultValueRegistry.defaultValue(for: Set<DayOfWeek>.self)
    }
    
}

