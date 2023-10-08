//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import XCTest

class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
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
    func test_notLoadingAnyURL_doesNotRequestDataFromURL() {
        // Given
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client, url: URL(string: "https://a-unique-url.com")!)
        
        // When (missing for that case)
        
        // Then
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadingAnURL_doesRequestDataFromURL() {
        // Given
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: URL(string: "https://a-unique-url.com")!)
        
        // When
        sut.load()
        
        // Then
        XCTAssertNotNil(client.requestedURL)
    }
    
    func tesst_loadingAnURL_doesNotRequestDataFromThatURL() {
        // Given
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-unique-url.com")!
        let sut = RemoteFeedLoader(client: client, url: url)
        
        // When
        sut.load()
        
        // Then
        XCTAssertEqual(client.requestedURL, url)
    }
}
