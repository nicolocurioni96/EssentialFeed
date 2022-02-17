//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni on 17/02/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
