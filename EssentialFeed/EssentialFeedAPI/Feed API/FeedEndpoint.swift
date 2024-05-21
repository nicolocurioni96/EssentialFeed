//
//  FeedEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Nicolò Curioni on 21/05/24.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appending(path: "/v1/feed")
        }
    }
}
