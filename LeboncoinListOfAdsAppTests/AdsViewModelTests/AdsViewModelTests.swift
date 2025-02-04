//
//  AdsViewModelTests.swift
//  LeboncoinListOfAdsAppTests
//
//  Created by Francisco Baião on 04/02/2025.
//

import XCTest
@testable import LeboncoinListOfAdsApp

class AdsViewModelTests: XCTestCase {
    var viewModel: AdsViewModel!
    var mockService: MockAPIService!

    override func setUp() {
        super.setUp()

        let mockAds = [
            Ad(id: 1, categoryId: 2, title: "Test Ad", adDescription: "Description", price: 100, imagesUrl: ImageUrls(small: nil, thumb: nil), creationDate: Date(), isUrgent: false, siret: nil)
        ]

        mockService = MockAPIService(mockAds: mockAds)
        viewModel = AdsViewModel()
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchAds_Success() {
        let expectation = XCTestExpectation(description: "Ads fetched successfully")

        mockService.fetchAds { result in
            switch result {
            case .success(let ads):
                XCTAssertEqual(ads.count, 1)
                XCTAssertEqual(ads.first?.title, "Test Ad")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchAds_Failure() {
        let mockService = MockAPIService(shouldReturnError: true)

        let expectation = XCTestExpectation(description: "Ads fetch failed")

        mockService.fetchAds { result in
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

    func testLoadAds_Success() {
        let mockAds = [
            Ad(id: 1, categoryId: 2, title: "Test Ad", adDescription: "Description", price: 100, imagesUrl: ImageUrls(small: nil, thumb: nil), creationDate: Date(), isUrgent: false, siret: nil)
        ]

        mockService = MockAPIService(mockAds: mockAds)
        viewModel = AdsViewModel(apiService: mockService)

        let expectation = XCTestExpectation(description: "Ads loaded successfully")

        viewModel.loadAds()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.ads.count, 1)
            XCTAssertEqual(self.viewModel.ads.first?.title, "Test Ad")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadAds_Failure() {
        let failingMockService = MockAPIService(shouldReturnError: true)
        viewModel = AdsViewModel(apiService: failingMockService)

        let expectation = XCTestExpectation(description: "Error message set when API fails")

        viewModel.loadAds()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadCategories_Success() {
        let mockCategories = [
            Category(id: 1, name: "Tech")
        ]

        mockService = MockAPIService(mockCategories: mockCategories)
        viewModel = AdsViewModel(apiService: mockService)

        let expectation = XCTestExpectation(description: "Ads loaded successfully")

        viewModel.loadCategories()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.categories.count, 1)
            XCTAssertEqual(self.viewModel.categories.first?.name, "Tech")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadCategories_Failure() {
        let failingMockService = MockAPIService(shouldReturnError: true)
        viewModel = AdsViewModel(apiService: failingMockService)

        let expectation = XCTestExpectation(description: "Error message set when API fails")

        viewModel.loadCategories()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

}

