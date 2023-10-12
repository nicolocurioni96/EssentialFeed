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
        sut.load { _ in }
        
        // Then
        XCTAssertNotNil(client.requestedURLs)
    }
    
    func test_loadTwice_doesNotRequestDataFromThatURL() {
        // Given
        let url = URL(string: "https://another-amazing-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        // When
        sut.load { _ in }
        sut.load { _ in }
        
        // Then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        // Given
        let (sut, client) = makeSUT()
        
        // Then
        expect(sut, with: .failure(.connectivity)) {
            // When
            let error = NSError(domain: "ClientError", code: 1)
            client.complete(with: error)
        }
    }
    
    func test_load_deliversErrorOnClientNon200HTTPResponse() {
        // Given
        let (sut, client) = makeSUT()
        let statusCodes = [199, 201, 300, 400, 500]
        
        statusCodes.enumerated().forEach { index, statusCode in
            // Then
            expect(sut, with: .failure(.invalidData)) {
                // When
                client.complete(withStatusCode: statusCode, at: index)
            }
        }
    }
    
    
    func test_load_deliversErrorOn200HTTPResponseAndInvalidJSON() {
        // Given
        let (sut, client) = makeSUT()
        
        // Then
        expect(sut, with: .failure(.invalidData)) {
            // When
            let invalidJSONData: Data = "Invalid JSON".data(using: .utf8)!
            client.complete(withStatusCode: 200, and: invalidJSONData)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        // Given
        let (sut, client) = makeSUT()
        
        // When
        expect(sut, with: .success([])) {
            // Then
            let emptyJSONListData: Data = "{\"items\":[]}".data(using: .utf8)!
            client.complete(withStatusCode: 200, and: emptyJSONListData)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithValidJSONList() {
        // Given
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID(),
                             description: "First feed item",
                             location: "First feed location",
                             imageURL: URL(string: "https://first-feed-url.com")!)
        
        let item2 = makeItem(id: UUID(),
                             location: "Second feed location",
                             imageURL: URL(string: "https://second-feed-url.com")!)
        
        let item3 = makeItem(id: UUID(),
                             description: "Third feed item",
                             imageURL: URL(string: "https://third-feed-url.com")!)
        
        let item4 = makeItem(id: UUID(),
                             imageURL: URL(string: "https://fourth-feed-url.com")!)
        
        
        
        let feedItems = [item1, item2, item3, item4]
        
        // When
        expect(sut, with: .success(feedItems.map { $0.model })) {
            // Then
            let JSONData = try! makeJSONItem(feedItems.map { $0.json })
            client.complete(withStatusCode: 200, and: JSONData)
        }
    }
    
    // MARK: - Helper methods
    private func makeSUT(url: URL = URL(string: "https://another-amazing-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        return (sut: sut, client: client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, with result: RemoteFeedLoader.Result, onAction action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults: [RemoteFeedLoader.Result] = []
        sut.load { capturedResults.append($0) }
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        let feedItem = FeedItem(id: id,
                                description: description,
                                location: location,
                                imageURL: imageURL)
        let json = [
            "id": id.description,
            "description": description,
            "location": location,
            "imageURL": imageURL.description
        ].compactMapValues { $0 }
        
        return (model: feedItem, json: json)
    }
    
    private func makeJSONItem(_ items: [[String: Any]]) throws -> Data {
        let dictionaryItems = ["items": items]
        return try JSONSerialization.data(withJSONObject: dictionaryItems)
    }
}

private class HTTPClientSpy: HTTPClient {
    init() {}
    
    var messages: [(url: URL, completion: (HTTPClientResponse) -> Void)] = []
    var requestedURLs: [URL]{ self.messages.map { $0.url } }
    
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void) {
        self.messages.append((url: url, completion: completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode statusCode: Int, and data: Data = Data(), at index: Int = 0) {
        let httpResponse = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)!
        
        messages[index].completion(.success(httpResponse, data))
    }
}

private extension Dictionary {
    func serialize() throws  -> Data {
        return try JSONSerialization.data(withJSONObject: self)
    }
}
