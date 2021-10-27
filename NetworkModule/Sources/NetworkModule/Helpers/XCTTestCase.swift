import Foundation
import XCTest

public extension XCTestCase {
    func trackMemoryLeak(_ instances: AnyObject..., file: StaticString = #filePath, line: UInt = #line) {
        instances.forEach { sut in
            addTeardownBlock { [weak sut] in
                XCTAssertNil(sut, "Instance should have been deallocated. Potential Memory Leak", file: file, line: line)
            }
        }
    }
}
