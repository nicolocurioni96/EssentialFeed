//
//  ImageCommentsEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Nicolò Curioni on 21/05/24.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appending(path: "/v1/image/\(id)/comments")
        }
    }
}
