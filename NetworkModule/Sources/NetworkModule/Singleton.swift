//
//  File.swift
//  
//
//  Created by Evans Domina Attafuah on 20/09/2021.
//

import Foundation

public struct LoggedInUser {}

public class ApiClient {
    public static let instance = ApiClient()
    
    private init() {}
    
    public func login(completion: (LoggedInUser) -> ()) {
        
    }
}

public class MockApiClient: ApiClient {
    override public func login(completion: (LoggedInUser) -> ()) {
        
    }
}
