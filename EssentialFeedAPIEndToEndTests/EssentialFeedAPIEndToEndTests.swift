//
//  EssentialFeedAPIEndToEndTests.swift
//  EssentialFeedAPIEndToEndTests
//
//  Created by Nicolò Curioni  on 19/10/23.
//

import XCTest
import EssentialFeed

final class EssentialFeedAPIEndToEndTests: XCTestCase {
    func test_endToEndTestServerGETFeedResult_MatchesFixedTestAccountData() {
        switch getFeedResult() {
        case let .success(items):
            XCTAssertEqual(items.count, 8, "Expected 8 items in the test account feed")
            
            XCTAssertEqual(items[0], expectedItem(at: 0))
            XCTAssertEqual(items[1], expectedItem(at: 1))
            XCTAssertEqual(items[2], expectedItem(at: 2))
            XCTAssertEqual(items[3], expectedItem(at: 3))
            XCTAssertEqual(items[4], expectedItem(at: 4))
            XCTAssertEqual(items[5], expectedItem(at: 5))
            XCTAssertEqual(items[6], expectedItem(at: 6))
            XCTAssertEqual(items[7], expectedItem(at: 7))
        case let .failure(error):
            XCTFail("Expected successful feed results, got failure with error \(error) instead")
        case .none:
            XCTFail("Expected successful feed results, got no result instead")
        }
    }
    
    // MARK: - Helper methods
    private func expectedItem(at index: Int) -> FeedItem {
        FeedItem(
            id: expectedID(at: index),
            description: expectedDescription(at: index),
            location: expectedLocation(at: index),
            imageURL: expectedURL(at: index))
    }
    
    private func expectedID(at index: Int) -> UUID {
        UUID(
            uuidString: [
                "853DF947-A034-491B-BC0F-8E0E224A49E2",
                "BA473803-875A-4FB8-852F-A53D2BADC8BC",
                "93EED266-A585-4A38-A7C8-9035CEF0AF00",
                "094223AF-84DE-424D-809C-D2CCD2969BDD",
                "74C3E1B6-3999-4CCC-9472-00E7F68ECFA5",
                "1C2FFA4F-A465-4643-8B30-282A3B991F86",
                "6A629552-73A9-4E58-8185-FA2A45C37060",
                "29F4997F-2A53-4B9A-A705-416C6DD572AF",
            ][index])!
    }
    
    private func expectedDescription(at index: Int) -> String? {
        [
            "Description 1",
            nil,
            "Description 3",
            nil,
            "Description 5",
            "Description 6",
            "Description 7",
            "Description 8",
        ][index]
    }
    
    private func expectedLocation(at index: Int) -> String? {
        [
            "Location 1",
            "Location 2",
            nil,
            nil,
            "Location 5",
            "Location 6",
            "Location 7",
            "Location 8",
        ][index]
    }
    
    private func expectedURL(at index: Int) -> URL {
        URL(
            string: [
                "https://url-1.com",
                "https://url-2.com",
                "https://url-3.com",
                "https://url-4.com",
                "https://url-5.com",
                "https://url-6.com",
                "https://url-7.com",
                "https://url-8.com",
            ][index])!
    }
    
    private func getFeedResult() -> LoadFeedResult? {
        let url = URL(string: "https://localhost:3000/response")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(client: client, url: url)
        let expectation = expectation(description: "Wait for load completion")
        
        var receivedResult: LoadFeedResult?
        
        loader.load { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        return receivedResult
    }
}
