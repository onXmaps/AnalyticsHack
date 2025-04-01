import Atomics
import Foundation

public final class TimeTower {
    @MainActor public static let shared = TimeTower()
    // Store measurement start times as ContinuousClock.Instant
    private var measurements = [UInt64: ContinuousClock.Instant]()
    private let currentID = ManagedAtomic<UInt64>(1)
    
    /// Convenience method to measure a block of code.
    /// Returns a tuple containing the result of the block and the duration it took.
    public func measure<T>(_ block: () -> T) -> (result: T, duration: Duration) {
        let id = startMeasurement()
        let result = block()
        guard let duration = stopMeasurement(id) else {
            fatalError("Measurement failed for id \(id)")
        }
        return (result, duration)
    }
    
     public func measure<T>(_ block: () throws -> T) throws -> (result: T, duration: Duration) {
        let id = startMeasurement()
        let result = try block()
        guard let duration = stopMeasurement(id) else {
            fatalError("Measurement failed for id \(id)")
        }
        return (result, duration)
    }
   

    public func measure<T>(_ block: () async -> T) async -> (result: T, duration: Duration) {
        let id = startMeasurement()
        let result = await block()
        guard let duration = stopMeasurement(id) else {
            fatalError("Measurement failed for id \(id)")
        }
        return (result, duration)
    }
    
        public func measure<T>(_ block: () async throws -> T) async throws -> (result: T, duration: Duration) {
        let id = startMeasurement()
        let result = try await block()
        guard let duration = stopMeasurement(id) else {
            fatalError("Measurement failed for id \(id)")
        }
        return (result, duration)
    }
    
    /// Starts a new measurement trace and returns a unique identifier.
    private func startMeasurement() -> UInt64 {
        let id = currentID.loadThenWrappingIncrement(ordering: .relaxed)
        let clock = ContinuousClock()
        measurements[id] = clock.now
        return id
    }
    
    /// Ends the measurement trace for the given identifier and returns the elapsed duration.
    private func stopMeasurement(_ id: UInt64) -> Duration? {
        guard let start = measurements.removeValue(forKey: id) else {
            return nil
        }
        let clock = ContinuousClock()
        let end = clock.now
        return end - start
    }
}
