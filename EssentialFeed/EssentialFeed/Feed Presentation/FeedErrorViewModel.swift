//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 20/02/24.
//

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}