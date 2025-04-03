import Foundation

class WatchTowerURLProtocol: URLProtocol {
    private let watchTower: WatchTower = .shared
    
    // Determine whether to intercept the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        // Only handle http and https requests.
        guard let scheme = request.url?.scheme?.lowercased() else {
            return false
        }
        // Prevent infinite loops by checking for a flag.
        if (scheme == "http" || scheme == "https"),
           URLProtocol.property(forKey: "WatchTower", in: request) == nil {
            return true
        }
        return false
    }
    
    // Return the canonical form of the request.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // Start processing the request.
    override func startLoading() {
        // Mark the request as handled to avoid processing it repeatedly.
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }
        URLProtocol.setProperty(true, forKey: "WatchTower", in: mutableRequest)
        
        
        
        let event = Event.Metadata(type: "network_request", value: mutableRequest.url?.absoluteString ?? "unknown URL")
        watchTower.log(event)
        // Create a URLSession task to perform the actual network request.
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        let task = session.dataTask(with: mutableRequest as URLRequest) { data, response, error in
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }
        task.resume()
    }
    
    // Clean up if the request is canceled.
    override func stopLoading() {
        // Cancel any ongoing tasks if needed.
    }
}
