//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import Foundation

public enum HTTPClientResponse {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(RemoteFeedLoader.Error)
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (RemoteFeedLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(httpResponse, data):
                do {
                    let feedItems = try FeedItemsMapper.map(data, httpResponse)
                    
                    completion(.success(feedItems))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private class FeedItemsMapper {
        static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
            guard response.statusCode == 200 else {
                throw RemoteFeedLoader.Error.invalidData
            }
            
            let feedsRoot = try JSONDecoder().decode(Root.self, from: data)
            
            return feedsRoot.items.map { $0.feedItem }
        }
    }
    
    private struct Root: Decodable {
        let items: [Item]
    }
    
    private struct Item: Decodable {
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
}
