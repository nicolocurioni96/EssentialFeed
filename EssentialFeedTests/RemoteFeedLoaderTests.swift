//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import XCTest
import EssentialFeed

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    init() {}
    
    func get(from url: URL) {
        self.requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_notLoadingAnyURL_doesNotRequestDataFromURL() {
        // Given
        let (_, client) = makeSUT(url: URL(string: "https://a-unique-url.com")!)
        
        // When (missing for that case)
        
        // Then
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_loadingAnURL_doesRequestDataFromURL() {
        // Given
        let (sut, client) = makeSUT(url: URL(string: "https://a-unique-url.com")!)
        
        // When
        sut.load()
        
        // Then
        XCTAssertNotNil(client.requestedURL)
    }
    
    func tesst_init_loadingAnURL_doesNotRequestDataFromThatURL() {
        // Given
        let url = URL(string: "https://a-unique-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        // When
        sut.load()
        
        // Then
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helper methods
    private func makeSUT(url: URL) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        return (sut: sut, client: client)
    }
}
