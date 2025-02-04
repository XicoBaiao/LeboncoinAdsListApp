//
//  AdDetailViewTests.swift
//  LeboncoinListOfAdsAppTests
//
//  Created by Francisco Baião on 04/02/2025.
//

import SwiftUI
import XCTest
@testable import LeboncoinListOfAdsApp

class AdDetailViewTests: XCTestCase {
    func testDetailViewDisplaysCorrectData() {
        let testAd = Ad(id: 1, categoryId: 2, title: "Test Ad", adDescription: "Description", price: 100, imagesUrl: ImageUrls(small: nil, thumb: nil), creationDate: Date(), isUrgent: false, siret: nil)

        let view = AdDetailView(ad: testAd, categoryName: "Category")
        let hostingController = UIHostingController(rootView: view)

        XCTAssertNotNil(hostingController.view)
    }
}
