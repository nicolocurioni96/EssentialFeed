//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import Foundation
import EssentialFeed

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init (url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}

