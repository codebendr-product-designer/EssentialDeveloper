//
//  File.swift
//  
//
//  Created by Evans Domina Attafuah on 20/09/2021.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (Error) -> ())
}
