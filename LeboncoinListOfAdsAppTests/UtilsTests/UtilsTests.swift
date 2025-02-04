//
//  UtilsTests.swift
//  LeboncoinListOfAdsAppTests
//
//  Created by Francisco Baião on 04/02/2025.
//

import XCTest
@testable import LeboncoinListOfAdsApp

class UtilsTests: XCTestCase {

    func testFormatDate() {
        // Given: A known date
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 2
        dateComponents.day = 3
        let testDate = calendar.date(from: dateComponents)!

        // When: Formatting the date
        let formattedDate = testDate.formatDate()

        // Then: Expect it to be in "dd/MM/yyyy" format
        XCTAssertEqual(formattedDate, "03/02/2025", "Expected '03/02/2025', but got '\(formattedDate)'")
    }
}
