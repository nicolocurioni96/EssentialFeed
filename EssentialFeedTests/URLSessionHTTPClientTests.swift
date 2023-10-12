//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 12/10/23.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void) {
        session.dataTask(with: url, completionHandler: { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }).resume()
    }
}

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask
}

protocol HTTPSessionDataTask {
    func resume()
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumeDataTaskWithURL() {
        // Given
        let url = URL(string: "https://an-enjoyable-url.com")!
        let session = HTTPSessionSpy()
        let task = HTTPSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        // When
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in }
        
        // Then
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnRequestedURL() {
        // Given
        let url = URL(string: "https://an-enjoyable-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "Request Error", code: 1)
        session.stub(url: url, error: error)
        
        // When
        let sut = URLSessionHTTPClient(session: session)
        let expectation = XCTestExpectation(description: "Expected to get response from GET methods")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(capturedError as NSError):
                XCTAssertEqual(capturedError, error)
            default:
                XCTFail("Expected failure with error \(error) but we got \(error) instead")
            }
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Helpers
    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: HTTPSessionDataTask
            let error: Error?
        }
        
        func stub(url: URL, task: HTTPSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find a stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: HTTPSessionDataTask {
       func resume() { }
    }
    
    private class HTTPSessionDataTaskSpy: HTTPSessionDataTask {
        var resumeCallCount: Int = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }
}
