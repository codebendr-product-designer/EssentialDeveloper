import XCTest
import NetworkModule

final class SingletonTests: XCTestCase {
    
    func testConnect() throws {
        ApiClient.instance.connect()
    }
}
