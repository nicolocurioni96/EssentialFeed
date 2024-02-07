//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 05/11/23.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
