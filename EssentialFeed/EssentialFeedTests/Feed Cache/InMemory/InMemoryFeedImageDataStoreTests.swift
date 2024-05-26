//
//  InMemoryFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni on 26/05/24.
//

import XCTest
import EssentialFeed

class InMemoryFeedImageDataStoreTests: XCTestCase, FeedImageDataStoreSpecs {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> InMemoryFeedStore {
        let sut = InMemoryFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
