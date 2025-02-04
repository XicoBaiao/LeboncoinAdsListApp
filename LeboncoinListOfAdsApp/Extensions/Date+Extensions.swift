//
//  Date+Extensions.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import Foundation

extension Date {
    // Function to format Date to "dd/MM/yyyy"
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Format as "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
