//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 12/10/23.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let expectation = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url, url)
            expectation.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        // Given
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as NSError?
        
        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }
    
    func test_getFromURL_failsOnRequestAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyURLResponse(), error: nil))
    }
    
    func test_getFromURL_succeedOnAnyURLHTTPResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let retrievedValues = resultValuesFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(retrievedValues?.response.statusCode, response.statusCode)
        XCTAssertEqual(retrievedValues?.response.url, response.url)
        XCTAssertEqual(retrievedValues?.data, data)
    }
    
    func test_getFromURL_succeedWithEmptyDataOnAnyURLHTTPResponseWithoutData() {
        let response = anyHTTPURLResponse()
        let retrievedvalues = resultValuesFor(data: nil, response: response, error: nil)
        let emptyData = Data()
        
        XCTAssertEqual(retrievedvalues?.response.statusCode, response.statusCode)
        XCTAssertEqual(retrievedvalues?.response.url, response.url)
        XCTAssertEqual(retrievedvalues?.data, emptyData)
    }
    
    // MARK: - Helper methods
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        // Given
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        let expectation = expectation(description: "Expected to get response from GET method")
        var capturedError: Error?
        
        // When
        sut.get(from: anyURL()) { result in
            switch result {
            case let .failure(error):
                capturedError = error
            default:
                XCTFail("Expected failure but we got \(result) instead", file: file, line: line)
            }
            
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        return capturedError
    }
    
    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (response: HTTPURLResponse, data: Data)? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch result {
        case let .success(response, data):
            return (response: response, data: data)
        default:
            XCTFail("Expected success but we got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClientResponse {
        URLProtocolStub.stub(data: data, response: response, error: nil)
        let sut = makeSUT(file: file, line: line)
        let expectation = expectation(description: "Expected to get response from GET method")
        
        var capturedResult: HTTPClientResponse!
        
        sut.get(from: anyURL()) { result in
            capturedResult = result
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        return capturedResult
    }
    
    private func anyURLResponse() -> URLResponse {
        URLResponse(
            url: anyURL(),
            mimeType: nil,
            expectedContentLength: 1,
            textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(
            url: anyURL(),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
    }
    
    private func anyData() -> Data {
        "Any data".data(using: .utf8)!
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(completion: @escaping (URLRequest) -> Void) {
            URLProtocolStub.requestObserver = completion
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                requestObserver(request)
                
                return 
            }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() { }
    }
}
