//
//  RemoteImageCommentsLoader.swift
//  EssentialFeedAPI
//
//  Created by Nicolò Curioni on 01/05/24.
//

import Foundation
import EssentialFeed

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init (url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
