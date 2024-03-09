//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 09/03/24.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
