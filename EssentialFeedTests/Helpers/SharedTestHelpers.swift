//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Nicolò Curioni  on 08/11/23.
//

import Foundation

func anyURL() -> URL {
    URL(string: "https://an-amazing-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "My Domain", code: 1)
}
