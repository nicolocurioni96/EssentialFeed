//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 05/11/23.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let imageURL: URL
}
