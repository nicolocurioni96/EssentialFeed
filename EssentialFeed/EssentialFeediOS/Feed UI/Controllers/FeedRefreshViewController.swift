//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Nicolò Curioni  on 11/02/24.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()
    
    private let localFeed: () -> Void
    
    init(localFeed: @escaping () -> Void) {
        self.localFeed = localFeed
    }
    
    @objc func refresh() {
        localFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
