//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni on 01/05/24.
//

import Foundation

final class ImageCommentsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedImageDataLoader.Error.invalidData
        }
        
        return root.items
    }
}
