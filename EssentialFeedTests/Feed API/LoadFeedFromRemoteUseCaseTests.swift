//
//  LoadFeedFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 08/10/23.
//

import XCTest
import EssentialFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
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
        expect(sut, with: failure(.connectivity)) {
            // When
            let error = NSError(domain: "ClientError", code: 1)
            client.complete(with: error)
        }
    }
    
    func test_load_deliversErrorOnClientNon200HTTPResponse() {
        // Given
        let (sut, client) = makeSUT()
        let statusCodes = [199, 201, 300, 400, 500]
        let validJSON = try! makeJSONItem([
            makeItem(id: UUID(),
                     description: "A description",
                     location: "A location",
                     imageURL: URL(string: "https://an-url.com")!
                    ).json
        ])
        
        statusCodes.enumerated().forEach { index, statusCode in
            // Then
            expect(sut, with: failure(.invalidData)) {
                // When
                client.complete(withStatusCode: statusCode, and: validJSON, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseAndInvalidJSON() {
        // Given
        let (sut, client) = makeSUT()
        
        // Then
        expect(sut, with: failure(.invalidData)) {
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
        
        
        
        let items = [item1.model, item2.model, item3.model, item4.model]
        
        // When
        expect(sut, with: .success(items)) {
            // Then
            let json = try! makeJSONItem([item1.json, item2.json, item3.json, item4.json])
            client.complete(withStatusCode: 200, and: json)
        }
    }
    
    func test_load_deliversEmptyListWhenReferenceToSUTHasBeenLost() {
        // Given
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-random-url.com")!
        var sut: RemoteFeedLoader? = RemoteFeedLoader(client: client, url: url)
        var capturedResults: [RemoteFeedLoader.Result] = []
        
        // When
        sut?.load { capturedResults.append($0) }
        sut = nil
        client.complete(withStatusCode: 200, and: try! makeJSONItem([]))
        
        // Then
        XCTAssertTrue(capturedResults.isEmpty)
        
    }
    
    // MARK: - Helper methods
    private func makeSUT(url: URL = URL(string: "https://another-amazing-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut: sut, client: client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, with expectedResult: RemoteFeedLoader.Result, onAction action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectation = XCTestExpectation(description: "Expect: ")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            expectation.fulfill()
        }
        
        action()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let feedImage = FeedImage(id: id,
                                description: description,
                                location: location,
                                url: imageURL)
        let json = [
            "id": id.description,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return (model: feedImage, json: json)
    }
    
    private func makeJSONItem(_ items: [[String: Any]]) throws -> Data {
        let dictionaryItems = ["items": items]
        return try JSONSerialization.data(withJSONObject: dictionaryItems)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        .failure(error)
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
    
    func complete(withStatusCode statusCode: Int, and data: Data, at index: Int = 0) {
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
