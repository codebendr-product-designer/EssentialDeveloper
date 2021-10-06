import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> ())
}


//add final prevent subclasses
public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    //by using Swift the error
    //we are able to define context
    //and use simple object names
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> () = { _ in }) {
        client.get(from: url) { error in 
            completion(.connectivity)
        }
    }
    
}


