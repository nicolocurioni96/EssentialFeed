//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni on 15/03/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
