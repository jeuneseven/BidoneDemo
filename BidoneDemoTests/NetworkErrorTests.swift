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

    @Test("invalidURL has non-nil error description")
    func testInvalidURLDescription() {
        let error = NetworkError.invalidURL
        #expect(error.errorDescription != nil)
        #expect(error.errorDescription?.isEmpty == false)
    }

    @Test("noData has non-nil error description")
    func testNoDataDescription() {
        let error = NetworkError.noData
        #expect(error.errorDescription != nil)
        #expect(error.errorDescription?.isEmpty == false)
    }

    @Test("decodingError has non-nil error description")
    func testDecodingErrorDescription() {
        let error = NetworkError.decodingError
        #expect(error.errorDescription != nil)
        #expect(error.errorDescription?.isEmpty == false)
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

    // MARK: - Enum Case Coverage
    @Test("All error cases return distinct descriptions")
    func testAllCasesDistinct() {
        let descriptions: [String?] = [
            NetworkError.invalidURL.errorDescription,
            NetworkError.noData.errorDescription,
            NetworkError.decodingError.errorDescription,
            NetworkError.serverError(500).errorDescription
        ]
        let unique = Set(descriptions.compactMap { $0 })
        #expect(unique.count == 4, "Each error case should have a distinct description")
    }
}
