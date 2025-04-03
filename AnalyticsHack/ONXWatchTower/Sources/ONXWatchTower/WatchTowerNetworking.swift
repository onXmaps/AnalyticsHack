import Foundation
@preconcurrency import ONXNetworking

struct WatchTowerNetworking {
    let client: HTTPClient
    let encoder = JSONEncoder()
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "ONX-Account-ID" : "12345",
            "ONX-Application-ID": "hunt",
            "ONX-Application-Version": "1.0",
            "ONX-Application-Platform": "iOS"
        ]
        var clientConfig = HTTPClientConfiguration(host: "https://yellowstone-hackathon.daily.onxmaps.com", sessionConfiguration: sessionConfig)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        encoder.dateEncodingStrategy = .custom({ date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(formatter.string(from: date))
        })
        
        clientConfig.encoder = encoder
        client = HTTPClient(configuration: clientConfig)
    }
    
    struct EventsRequest: Codable {
        let events: [Event]
    }
    func upload(events: [Event]) async throws {
        let eventData = try encoder.encode(events)
        print(try! JSONSerialization.jsonObject(with: eventData))
        try await client.send(.post("/api/v1/yellowstone/events", body: EventsRequest(events: events)))
    }
}
