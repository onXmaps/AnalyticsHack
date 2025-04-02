@preconcurrency import ONXNetworking
import Foundation

public struct SwapiPeople: Decodable {
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}

public final class SwapiClient {
    let client: HTTPClient

    public init() {

        // Customize the URLSessionConfiguration
        let sessionConfig: URLSessionConfiguration = .default
        sessionConfig.httpAdditionalHeaders = [
            HeaderField.appId: "com.onxmaps.onxnetworking-example",
            HeaderField.appVersion: "1.0.1"
        ]
        URLProtocol.registerClass(WatchTowerURLProtocol.self)
        sessionConfig.protocolClasses?.insert(WatchTowerURLProtocol.self, at: 0)

        // Create the configuration
        var clientConfig = HTTPClientConfiguration(
            host: "swapi.dev",
            sessionConfiguration: sessionConfig
        )
        // Use a custom decoder.
        clientConfig.decoder = Self.decoder
        // If we receive an error, attempt to load the most recently cached response.
        clientConfig.loadCachedResponseOnError = true

        // Create the client
        client = HTTPClient(configuration: clientConfig)
    }

    /// Performs a GET request for the specified peopleID.
    /// - Parameter peopleId: The ID of the droid you're looking for.
    /// - Returns: A `SwapiPeople`.
    public func getPeople(_ peopleId: Int) async throws -> SwapiPeople {
        // The request is for a `SwapiPeople` type,
        // which will be decoded from the response on success.
        let req: HTTPRequest<SwapiPeople> = HTTPRequest.get("api/people/\(peopleId)/")
        return try await client.send(req).value
    }
}


extension SwapiClient {
    // Custom date formatter that matches the SWAPI date format.
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // E.G. "2014-12-10T16:42:45.066000Z"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return formatter
    }()

    // Custom JSONDecoder.
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
}
