import Foundation

public enum HTTPClientResult {
    case success(Data,HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> ())
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
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> ()) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, _):
                if let root = try?  JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.items))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure :
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [FeedItem]
}

