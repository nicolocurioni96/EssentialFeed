//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        // Given
        let (_, client) = makeSUT(url: URL(string: "https://an-amazing-url.com")!)
        
        // When (missing for that case)
        
        // Then
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_doesRequestDataFromThatURL() {
        // Given
        let url = URL(string: "https://another-amazing-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        // When
        sut.load()
        
        // Then
        XCTAssertNotNil(client.requestedURLs)
    }
    
    func test_loadTwice_doesNotRequestDataFromThatURL() {
        // Given
        let url = URL(string: "https://another-amazing-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        // When
        sut.load()
        sut.load()
        
        // Then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        // Given
        let (sut, client) = makeSUT()
        var capturedErrors: [RemoteFeedLoader.Error?] = []
        
        // When
        sut.load { capturedErrors.append($0) }
        client.completions[0](NSError(domain: "ClientError", code: 1, userInfo: nil))
        
        // Then
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helper methods
    private func makeSUT(url: URL = URL(string: "https://another-amazing-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        return (sut: sut, client: client)
    }
}

private class HTTPClientSpy: HTTPClient {
    init() {}
    
    var requestedURLs: [URL] = []
    var completions: [(Error) -> Void] = []
    
    func get(from url: URL, completion: @escaping (Error) -> Void) {
        self.requestedURLs.append(url)
        self.completions.append(completion)
    }
}
