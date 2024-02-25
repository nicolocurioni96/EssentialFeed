//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Nicolò Curioni  on 25/02/24.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
