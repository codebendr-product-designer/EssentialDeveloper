//
//  File.swift
//  
//
//  Created by Evans Domina Attafuah on 13/10/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data,HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> ())
}
