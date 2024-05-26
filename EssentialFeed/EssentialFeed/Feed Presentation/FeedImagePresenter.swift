//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 11/02/24.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description, location: image.location)
    }
}
