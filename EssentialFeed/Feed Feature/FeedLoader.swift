//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
