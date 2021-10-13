import Foundation
import CloudKit



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
            case let .success(data, response):
                do {
                    let items = try Mapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure :
                completion(.failure(.connectivity))
            }
        }
    }
}

private final class Mapper {
    
    private struct Root: Decodable {
        let items: [Item]
    }
    
    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var item: FeedItem {
            .init(id: id, description: description, location: location, imageURL: image)
        }
    }
    static var OK_200 = 200
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map{ $0.item }
        
    }
}



