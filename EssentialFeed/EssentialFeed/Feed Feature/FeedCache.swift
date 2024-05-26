//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 09/03/24.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
