import Foundation

public struct Event: Identifiable {
    public let id: UUID
    public let type: String
    public let value: String

    public init(id: UUID, type: String, value: String) {
        self.id = id
        self.type = type
        self.value = value
    }
}

public struct WatchTower: Sendable {
    public static let shared = WatchTower()
    public func log(_ event: Event) {
        print("Logged Event:\nid: \(event.id)\ntype: \(event.type)\nvalue: \(event.value)\n")
    }
}
