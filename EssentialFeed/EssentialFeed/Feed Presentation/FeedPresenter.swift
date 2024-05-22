//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 12/02/24.
//

import Foundation

public protocol FeedErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}

public final class FeedPresenter {
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                          tableName: "Feed",
                          bundle: Bundle(for: FeedPresenter.self),
                          comment: "Title for the feed view")
    }
}
