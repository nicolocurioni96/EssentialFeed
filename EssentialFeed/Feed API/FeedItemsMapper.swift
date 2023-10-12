//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 12/10/23.
//

import Foundation

internal class FeedItemsMapper {
    internal struct Root: Decodable {
        let items: [Item]
    }
    
    internal struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let imageURL: URL
        
        var feedItem: FeedItem {
            FeedItem(id: id,
                     description: description,
                     location: location,
                     imageURL: imageURL
            )
        }
    }
    
    private static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let feedsRoot = try JSONDecoder().decode(Root.self, from: data)
        
        return feedsRoot.items.map { $0.feedItem }
    }
}
