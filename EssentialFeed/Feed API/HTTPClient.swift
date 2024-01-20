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
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void)
}
