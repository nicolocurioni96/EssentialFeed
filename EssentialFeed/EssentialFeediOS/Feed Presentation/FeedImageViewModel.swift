//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 11/02/24.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
