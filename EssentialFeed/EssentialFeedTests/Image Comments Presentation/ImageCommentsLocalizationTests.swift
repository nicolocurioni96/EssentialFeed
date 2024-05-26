//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni on 12/05/24.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
