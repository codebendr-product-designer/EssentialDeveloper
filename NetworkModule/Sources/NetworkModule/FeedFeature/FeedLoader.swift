//
//  File.swift
//  
//
//  Created by Evans Domina Attafuah on 20/09/2021.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> ())
}
