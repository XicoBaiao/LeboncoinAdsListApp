//
//  ImageCacheManagerTests.swift
//  LeboncoinListOfAdsAppTests
//
//  Created by Francisco Baião on 04/02/2025.
//

import XCTest
@testable import LeboncoinListOfAdsApp

class ImageCacheManagerTests: XCTestCase {
    var cacheManager: ImageCacheManager!

    override func setUp() {
        super.setUp()
        cacheManager = ImageCacheManager.shared
    }

    override func tearDown() {
        cacheManager.clearCache()
        cacheManager = nil
        super.tearDown()
    }

    func testCacheImage_Success() {
        let testImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://example.com/test.jpg")!

        cacheManager.cacheImage(testImage, for: testURL)
        let cachedImage = cacheManager.getImage(for: testURL)

        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage, testImage)
    }

    func testClearCache() {
        let testImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://example.com/test.jpg")!

        cacheManager.cacheImage(testImage, for: testURL)
        cacheManager.clearCache()

        XCTAssertNil(cacheManager.getImage(for: testURL))
    }

    func testLoadImage_Failure() {
        let testURL = URL(string: "https://example.com/notfound.jpg")!

        let expectation = XCTestExpectation(description: "Image fetch fails")

        ImageCacheManager.shared.loadImage(from: testURL) { image in
            XCTAssertNil(image, "Image should be nil for a failed request")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

}
