import HealthKit
import Samples

public final class ActiveEnergyQueryImpl: HealthKitQuery<ActiveEnergy> {
	override func initFromHKSample(_ sample: HKSample) -> ActiveEnergy { ActiveEnergy(sample as! HKQuantitySample) }
}
public final class WorkoutQueryImpl: HealthKitQuery<Workout> {
	override func initFromHKSample(_ sample: HKSample) -> Workout { Workout(sample as! HKWorkout) }
}
