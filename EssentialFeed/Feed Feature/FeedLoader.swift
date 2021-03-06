//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni on 17/02/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
