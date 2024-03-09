//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 09/03/24.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
