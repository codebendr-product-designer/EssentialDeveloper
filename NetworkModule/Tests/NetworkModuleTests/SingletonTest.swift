import XCTest
import NetworkModule
import UIKit

final class SingletonTests: XCTestCase {
    
    func test_login() throws {
//        ApiClient.instance.login {
//            print($0)
//        }
    }
    
    class ViewModule {
        //two closures and an optional for the braces
      var login: (((LoggedInUser) -> ()) -> ())?
        
        func load() {
            login? {
                print($0)
            }
        }
    
    }
    
    func test_mock_api() throws {
       
    }
}
