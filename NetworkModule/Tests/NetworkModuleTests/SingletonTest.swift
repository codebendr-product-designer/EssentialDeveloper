import XCTest
import NetworkModule
import UIKit

final class SingletonTests: XCTestCase {
    
    func test_login() throws {
        ApiClient.instance.login {
            print($0)
        }
    }
    
    func test_mock_api() throws {
        class ViewController: UIViewController {
            let api = MockApiClient.instance
            
            override func viewDidLoad() {
                api.login {
                    dump($0)
                }
            }
        }
    }
}
