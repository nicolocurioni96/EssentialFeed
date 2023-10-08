//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import XCTest

class RemoteFeedLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "https://a-unique-url.com")!)
    }
}

class HTTPClient {
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
        _ = RemoteFeedLoader(client: client)
        
        // When (missing for that case)
        
        // Then
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadingAnURL_clientDoesRequestAnURL() {
        // Given
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        // When (missing for that case)
        sut.load()
        
        // Then
        XCTAssertNotNil(client.requestedURL)
    }
}
