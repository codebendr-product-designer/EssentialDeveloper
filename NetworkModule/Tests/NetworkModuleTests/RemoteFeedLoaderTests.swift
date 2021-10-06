import XCTest
import NetworkModule


class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_RequestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_RequestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        var capturedErrors: Array = [RemoteFeedLoader.Error]()
        let clientError = NSError(domain: "Test", code: 0)
        
        sut.load {
            capturedErrors.append($0)
        }

        client.complete(with: clientError)
  
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    //MARK: - Helper
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (
        sut: RemoteFeedLoader, client: HTTPClientSpy) {
            let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    //Spies are for capturing values
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
             messages.map { $0.url }
        }
        var completions = [(Error) -> ()]()
        
        private var messages = [(url: URL, completion: (Error) -> ())]()
        
        func get(from url: URL, completion: @escaping (Error) -> ()) {
            messages.append((url, completion))
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](error)
        }
    }
    
}
