//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 11/02/24.
//

import UIKit

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
 
