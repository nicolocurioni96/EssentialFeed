//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 19/02/24.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {
   var isShowingLocation: Bool {
       return !locationContainer.isHidden
   }
   
   var isShowingImageLoadingIndicator: Bool {
       return feedImageContainer.isShimmering
   }
   
   var isShowingRetryAction: Bool {
       return !feedImageRetryButton.isHidden
   }
   
   var locationText: String? {
       return locationLabel.text
   }
   
   var descriptionText: String? {
       return descriptionLabel.text
   }
   
   var renderedImage: Data? {
       return feedImageView.image?.pngData()
   }
}
