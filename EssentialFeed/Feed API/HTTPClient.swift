//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 12/10/23.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(HTTPURLResponse, Data), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
