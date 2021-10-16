import XCTest
import NetworkModule

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
//    func test_getFromURL_createsDataTaskWithURL() {
//        let url = URL(string: "http://any-url.com")!
//        let session = URLSessionSpy()
//        let sut = URLSessionHTTPClient(session: session)
//        sut.get(from: url)
//
//        XCTAssertEqual(session.recievedURLs, [url])
//    }
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(session.recievedURLs, [url])
    }
    
    func test_getFromURLfailsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPClient(session: session)
         
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError) :
                XCTAssertEqual(receivedError.domain, error.domain)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        XCTAssertEqual(session.recievedURLs, [url])
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    private class URLSessionSpy: HTTPSession {
        var recievedURLs = [URL]()
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: HTTPSessionTask
            let error: Error?
        }
        
        func stub(url: URL, task: HTTPSessionTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> HTTPSessionTask {
            guard let stub = stubs[url] else {
               fatalError("Couldn't find stub for \(url)")
            }
                
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: HTTPSessionTask {
         func resume() { }
    }
    
    private class URLSessionDataTaskSpy: HTTPSessionTask {
        var resumeCallCount = 0
        
         func resume() {
            resumeCallCount += 1
        }
    }
}
