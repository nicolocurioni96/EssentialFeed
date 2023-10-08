//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-unique-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(from url: URL) {
        self.requestedURL = url
    }
    
    override init() {}
}

class RemoteFeedLoaderTests: XCTestCase {
    func test_notLoadingAnyURL_clientDoesNotRequestAnyURL() {
        // Given
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        // When (missing for that case)
        
        // Then
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadingAnURL_clientDoesRequestAnURL() {
        // Given
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        // When (missing for that case)
        sut.load()
        
        // Then
        XCTAssertNotNil(client.requestedURL)
    }
}
