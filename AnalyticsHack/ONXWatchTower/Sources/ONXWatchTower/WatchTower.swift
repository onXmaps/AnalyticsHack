import Foundation
import Combine
import Network
import CoreTelephony

public struct Event: Identifiable, Sendable, Codable {
    public struct Metadata {
        let type: String
        let value: String
        public init(type: String, value: String) {
            self.type = type
            self.value = value
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "event_id"
        case sessionId = "session_id"
        case type = "event_type"
        case value
        case timestamp
    }
    
    public let id: UUID = .init()
    public let sessionId: UUID
    public let type: String
    public let value: String
    public let timestamp: Date = .init()

    public init(sessionId: UUID, type: String, value: String) {
        self.sessionId = sessionId
        self.type = type
        self.value = value
    }
}

public final class WatchTower: @unchecked Sendable {
    public static let shared = WatchTower()
    private let timeTower = TimeTower()
    private let watchTowerNetworking = WatchTowerNetworking()
    private let logQueue = DispatchQueue(label: "com.onxmaps.WatchTower.logQueue")
    private let networkMonitor = NWPathMonitor()
    private let networkMonitorQueue = DispatchQueue(label: "com.onxmaps.WatchTower.networkMonitorQueue")
    private(set) var events: [Event] = []
    private var lastConnectionType: String?
    private let sessionId = UUID()
    public init() {
        startNetworkMonitoring()
    }
    
    private func startNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            let connectionType: String
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) {
                    connectionType = "WiFi"
                } else if path.usesInterfaceType(.cellular) {
                    let radioTechs = self?.getRadioNetworkTechnology()
                    connectionType = "Cellular: \(radioTechs?.joined(separator: ", ") ?? "Unknown")"
                } else if path.usesInterfaceType(.wiredEthernet) {
                    connectionType = "WiredEthernet"
                } else {
                    connectionType = "Other"
                }
            } else {
                connectionType = "Offline"
            }
            guard connectionType != self?.lastConnectionType else { return }
            self?.lastConnectionType = connectionType
            let event = Event.Metadata(type: "network_change", value: connectionType)
            self?.log(event)
        }
        networkMonitor.start(queue: networkMonitorQueue)
    }
    
    private func getRadioNetworkTechnology() -> [String]? {
        let networkInfo = CTTelephonyNetworkInfo()
            
        // Get radio access technology for each service
        guard let technologies = networkInfo.serviceCurrentRadioAccessTechnology?.values else {
            return nil
        }
        return Array<String>(technologies)
    }
    
    public func log(_ event: Event.Metadata) {
        let event = Event(sessionId: sessionId, type: event.type, value: event.value)
        print("Logged Event:\nid: \(event.id)\ntype: \(event.type)\nvalue: \(event.value)\n")
        logQueue.async { [self] in
            events.append(event)
        }
    }
    
    public func upload() async throws {
        let eventsToUpload = logQueue.sync { [self] in
            self.events
        }
        try await watchTowerNetworking.upload(events: eventsToUpload)
        logQueue.async { [self] in
            events.removeAll()
        }
    }
    
    public func logWithTime<T>(_ event: Event.Metadata, block: () async throws -> T) async throws -> T {
        let (result, duration) = try await logTime(block)
        let timedEvent = Event.Metadata(type: event.type, value: "{value: \(event.value), time: \(duration)}")
        log(timedEvent)
        return result
    }
    
    public func logTime<T>(_ block: () -> T) -> (result: T, duration: Duration) {
        timeTower.measure(block)
    }
    
    public func logTime<T>(_ block: () throws -> T) throws -> (result: T, duration: Duration) {
        try timeTower.measure(block)
    }
   
    public func logTime<T>(_ block: () async -> T) async -> (result: T, duration: Duration) {
        await timeTower.measure(block)
    }
    
    public func logTime<T>(_ block: () async throws -> T) async throws -> (result: T, duration: Duration) {
        try await timeTower.measure(block)
    }
}
