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
        sut.load { _ in}
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_RequestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in}
        sut.load { _ in}
        
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
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        for (index, code) in (199...500).enumerated() {
            
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load { capturedErrors.append($0) }
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(capturedErrors, [.invalidData])
        }

    }
    
    func test_load_deliversErrorOnNon200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
 
        var invalidJSON = Data(bytes: "invalid json".utf8)
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load { capturedErrors.append($0) }
        client.complete(withStatusCode: 200, data: invalidJSON)
            XCTAssertEqual(capturedErrors, [.invalidData])
    }

    //MARK: - Helper
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (
        sut: RemoteFeedLoader, client: HTTPClientSpy) {
            let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    //Spies are for capturing values
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] { messages.map { $0.url } }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> ())]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> ()) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
           let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
           )!
            messages[index].completion(.success(data, response))
        }
    }
    
}
