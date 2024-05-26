//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 09/03/24.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
