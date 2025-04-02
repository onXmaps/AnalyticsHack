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
        var clientConfig = HTTPClientConfiguration(host: "localhost", sessionConfiguration: sessionConfig)
        clientConfig.isInsecure = true
        clientConfig.port = 8080
        client = HTTPClient(configuration: clientConfig)
    }
    
    func upload(event: Event) async throws {
        try await client.send(.post("/yellowstone-events", body: event))
    }
}
