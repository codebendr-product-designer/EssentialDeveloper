import Foundation

public class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}

public protocol HTTPClient {
    func get(from url:URL)
}
