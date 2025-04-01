import Foundation

public struct Event: Identifiable, Sendable {
    public let id: UUID
    public let type: String
    public let value: String

    public init(id: UUID, type: String, value: String) {
        self.id = id
        self.type = type
        self.value = value
    }
}

public final class WatchTower {
    @MainActor public static let shared = WatchTower()
    private let measureTower = TimeTower()
    private(set) var events: [Event] = []
    public func log(_ event: Event) {
        print("Logged Event:\nid: \(event.id)\ntype: \(event.type)\nvalue: \(event.value)\n")
        events.append(event)
    }
    
    public func logWithTime<T>(_ event: Event, block: () async throws -> T) async throws -> T {
        let (result, duration) = try await logTime(block)
        let timedEvent = Event(id: event.id, type: event.type, value: "{value: \(event.value), time: \(duration)}")
        log(timedEvent)
        return result
    }
    
    public func logTime<T>(_ block: () -> T) -> (result: T, duration: Duration) {
        measureTower.measure(block)
    }
    
    public func logTime<T>(_ block: () throws -> T) throws -> (result: T, duration: Duration) {
        try measureTower.measure(block)
    }
   
    public func logTime<T>(_ block: () async -> T) async -> (result: T, duration: Duration) {
        await measureTower.measure(block)
    }
    
    public func logTime<T>(_ block: () async throws -> T) async throws -> (result: T, duration: Duration) {
        try await measureTower.measure(block)
    }

}
