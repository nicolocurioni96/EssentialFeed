//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 11/02/24.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
