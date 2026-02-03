//
//  NetworkErrorTests.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

@Suite("NetworkError Tests")
struct NetworkErrorTests {
    
    @Test("invalidURL has correct error description")
    func testInvalidURLDescription() {
        let error = NetworkError.invalidURL
        #expect(error.errorDescription == "Invalid URL")
    }
    
    @Test("noData has correct error description")
    func testNoDataDescription() {
        let error = NetworkError.noData
        #expect(error.errorDescription == "No data received")
    }
    
    @Test("decodingError has correct error description")
    func testDecodingErrorDescription() {
        let error = NetworkError.decodingError
        #expect(error.errorDescription == "Failed to decode response")
    }
    
    @Test("serverError includes status code in description")
    func testServerErrorDescription() {
        let error404 = NetworkError.serverError(404)
        #expect(error404.errorDescription?.contains("404") == true)
        
        let error500 = NetworkError.serverError(500)
        #expect(error500.errorDescription?.contains("500") == true)
    }
    
    @Test("unknown error uses underlying error description")
    func testUnknownErrorDescription() {
        let underlyingError = NSError(
            domain: "TestDomain",
            code: 123,
            userInfo: [NSLocalizedDescriptionKey: "Test error message"]
        )
        let error = NetworkError.unknown(underlyingError)
        #expect(error.errorDescription == "Test error message")
    }
}
