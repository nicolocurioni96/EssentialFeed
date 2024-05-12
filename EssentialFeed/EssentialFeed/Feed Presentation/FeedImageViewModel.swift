//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 21/02/24.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
