//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 12/10/23.
//

import Foundation

public enum HTTPClientResponse {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void)
}
