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
    private(set) var events: [Event] = []
    public func log(_ event: Event) {
        print("Logged Event:\nid: \(event.id)\ntype: \(event.type)\nvalue: \(event.value)\n")
        events.append(event)
    }
}
