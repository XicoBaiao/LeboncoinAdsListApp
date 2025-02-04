//
//  APIServiceTests.swift
//  LeboncoinListOfAdsAppTests
//
//  Created by Francisco Baião on 04/02/2025.
//

import XCTest
@testable import LeboncoinListOfAdsApp

class APIServiceTests: XCTestCase {
    var apiService: MockAPIService!

    override func setUp() {
        super.setUp()

        let mockAds = [
            Ad(id: 1, categoryId: 2, title: "Test Ad", adDescription: "Description", price: 100, imagesUrl: ImageUrls(small: nil, thumb: nil), creationDate: Date(), isUrgent: false, siret: nil),
            Ad(id: 2, categoryId: 3, title: "Second Test Ad", adDescription: "Another Description", price: 200, imagesUrl: ImageUrls(small: nil, thumb: nil), creationDate: Date(), isUrgent: true, siret: nil)
        ]

        let mockCategories = [
            Category(id: 2, name: "Category 2"),
            Category(id: 3, name: "Category 3")
        ]

        apiService = MockAPIService(mockAds: mockAds, mockCategories: mockCategories)
    }

    override func tearDown() {
        apiService = nil
        super.tearDown()
    }

    func testFetchAds_Success() {
        let expectation = XCTestExpectation(description: "Ads fetched successfully")

        apiService.fetchAds { result in
            switch result {
            case .success(let ads):
                XCTAssertEqual(ads.count, 2) // ✅ Ensure we get 2 ads
                XCTAssertEqual(ads.first?.title, "Test Ad")
                XCTAssertEqual(ads.last?.title, "Second Test Ad")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchAds_Failure() {
        let failingMockService = MockAPIService(shouldReturnError: true)
        let expectation = XCTestExpectation(description: "Ads fetch failed")

        failingMockService.fetchAds { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchCategories_Success() {
        let expectation = XCTestExpectation(description: "Categories fetched successfully")

        apiService.fetchCategories { result in
            switch result {
            case .success(let categories):
                XCTAssertEqual(categories.count, 2)
                XCTAssertEqual(categories.first?.name, "Category 2")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchCategories_Failure() {
        let failingMockService = MockAPIService(shouldReturnError: true)
        let expectation = XCTestExpectation(description: "Categories fetch failed")

        failingMockService.fetchCategories { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
