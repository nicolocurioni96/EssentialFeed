//
//  FeedEndpointTests.swift
//  EssentialFeedAPITests
//
//  Created by Nicolò Curioni on 21/05/24.
//

import XCTest
import EssentialFeedAPI

class FeedEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/feed")!
        
        XCTAssertEqual(received, expected)
    }
}
