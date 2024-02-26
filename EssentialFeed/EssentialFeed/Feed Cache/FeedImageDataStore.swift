//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 26/02/24.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
