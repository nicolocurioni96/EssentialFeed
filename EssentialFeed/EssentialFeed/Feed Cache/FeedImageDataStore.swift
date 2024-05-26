//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 26/02/24.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
