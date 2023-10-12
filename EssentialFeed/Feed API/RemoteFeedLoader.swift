//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import Foundation

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
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(httpResponse, data):
                completion(self.map(data, httpResponse))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, _ httpResponse: HTTPURLResponse) -> RemoteFeedLoader.Result {
        do {
            let feedItems = try FeedItemsMapper.map(data, httpResponse)
            
            return .success(feedItems)
        } catch {
            return .failure(.invalidData)
        }
    }
}
