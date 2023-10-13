//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 12/10/23.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
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


class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_failsOnRequestedURL() {
        URLProtocolStub.startInterceptingRequests()
        // Given
        let url = URL(string: "https://an-enjoyable-url.com")!
        let error = NSError(domain: "Request Error", code: 1)
        URLProtocolStub.stub(url: url, data: nil, response: nil, error: error)
        
        // When
        let sut = URLSessionHTTPClient()
        let expectation = XCTestExpectation(description: "Expected to get response from GET methods")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(capturedError as NSError):
                XCTAssertEqual(capturedError.domain, error.domain)
                XCTAssertEqual(capturedError.code, error.code)
            default:
                XCTFail("Expected failure with error \(error) but we got \(error) instead")
            }
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    // MARK: - Helpers
    private class URLProtocolStub: URLProtocol {
        private static var stubs = [URL: Stub]()
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(url: URL, data: Data?, response: URLResponse?, error: Error?) {
            stubs[url] = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs = [:]
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else {
                return false
            }
            
            return stubs[url] != nil
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let url = request.url,
                  let stub = URLProtocolStub.stubs[url] else {
                return
            }
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() { }
    }
}
