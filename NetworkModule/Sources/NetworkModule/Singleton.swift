import Foundation


//Inverse Dependency

public class ApiClient {
    public static let instance = ApiClient()
    
    private init() {}
    
    public func execute(_ : URLRequest, completion: (Data) -> ()) {
        
    }
   
}

public struct LoggedInUser {}

