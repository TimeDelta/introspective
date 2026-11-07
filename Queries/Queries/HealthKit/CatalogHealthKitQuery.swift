import Foundation
import HealthKit
import Samples

/// Runtime identity for generic catalog queries. Saved queries still persist the
/// catalog's permanent SampleFactory ID rather than a display name or list index.
public protocol CatalogHealthQueryIdentifying {
    var catalogSampleType: Sample.Type { get }
}

/// Each generated marker specializes this query to one concrete Sample.Type.
/// HealthKit supplies the stored record; there is no parallel recording editor.
public final class CatalogHealthKitQuery<SampleType: HealthCatalogSample>:
    HealthKitQuery<SampleType>, CatalogHealthQueryIdentifying {
    public var catalogSampleType: Sample.Type { SampleType.self }

    override func initFromHKSample(_ sample: HKSample) throws -> SampleType {
        try SampleType(validating: sample)
    }
}
