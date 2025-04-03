import Foundation
@preconcurrency import ONXNetworking

struct WatchTowerNetworking {
    let client: HTTPClient
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "ONX-Account-ID" : "12345",
            "ONX-Application-ID": "hunt",
            "ONX-Application-Version": "1.0",
            "ONX-Application-Platform": "iOS"
        ]
        let clientConfig = HTTPClientConfiguration(host: "https://yellowstone-hackathon.daily.onxmaps.com", sessionConfiguration: sessionConfig)
        client = HTTPClient(configuration: clientConfig)
    }
    
    struct EventsRequest: Codable {
        let events: [Event]
    }
    func upload(events: [Event]) async throws {
        try await client.send(.post("/api/v1/yellowstone/events", body: EventsRequest(events: events)))
    }
}
