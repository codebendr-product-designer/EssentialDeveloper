//
//  File.swift
//  
//
//  Created by Evans Domina Attafuah on 20/09/2021.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> ())
}
