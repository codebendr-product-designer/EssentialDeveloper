import Foundation
import XCTest

public extension XCTestCase {
    func trackMemoryLeaks(_ instances: AnyObject..., file: StaticString = #filePath, line: UInt = #line) {
        instances.forEach { sut in
            addTeardownBlock { [weak sut] in
                XCTAssertNil(sut, "Instance should have been deallocated. Potential Memory Leak", file: file, line: line)
            }
        }
    }
}

public extension Data {
    static var anyData: Self { .init("any data".utf8) }
}

public extension URLResponse {
    static var nonHTTPURLResponse: Self {
        .init(url: .anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    static var anyHTTPURLResponse: HTTPURLResponse {
        HTTPURLResponse(url: .anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
}




