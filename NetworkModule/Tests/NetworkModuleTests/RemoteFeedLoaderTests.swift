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
        
        expect(sut, toCompleteWithError: .connectivity) {
            let clientError = NSError(domain: "Test", code: 0)
           client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        for (index, code) in (199...500).enumerated() {
            expect(sut, toCompleteWithError: .invalidData) {
               client.complete(withStatusCode: code, at:index)
            }
        }

    }
    
    func test_load_deliversErrorOnNon200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
 
        expect(sut, toCompleteWithError: .invalidData) {
            let invalidJSON = Data("invalid json".utf8)
           client.complete(withStatusCode: 200, data: invalidJSON)
        }
        
    }

    //MARK: - Helper
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (
        sut: RemoteFeedLoader, client: HTTPClientSpy) {
            let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithError error: RemoteFeedLoader.Error, when action: () -> (), file: StaticString = #filePath, line: UInt = #line) {
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        action()
        
        XCTAssertEqual(capturedErrors, [error], file: file, line: line)
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
