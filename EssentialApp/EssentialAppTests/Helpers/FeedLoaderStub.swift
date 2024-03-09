//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Nicolò Curioni  on 09/03/24.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
