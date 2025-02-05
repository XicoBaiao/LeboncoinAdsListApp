//
//  AdsViewModel.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import Foundation
import SwiftUI

// ViewModel responsible for managing the state of ads and categories.
class AdsViewModel {
    // List of all ads
    var allAds: [Ad] = []

    // List of filtered ads (based on selected category)
    var filteredAds: [Ad] = [] {
        didSet {
            reloadTableView?()
        }
    }

    // List of categories
    var categories: [Category] = [] {
        didSet {
            reloadCategories?()
        }
    }

    // Tracks errors and notifies the UI
    var errorMessage: String? {
        didSet {
            showErrorMessage?(errorMessage)
        }
    }

    // Tracks whether data is being loaded
    var isLoading: Bool = false {
        didSet {
            updateLoadingState?(isLoading)
        }
    }

    // Stores the currently selected category (default: show all)
    var selectedCategoryId: Int? {
        didSet {
            filterAds()
        }
    }

    private let apiService: APIServiceProtocol

    // Callbacks to update UI
    var reloadTableView: (() -> Void)?
    var reloadCategories: (() -> Void)?
    var showErrorMessage: ((String?) -> Void)?
    var updateLoadingState: ((Bool) -> Void)?

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    // Fetches ads and updates the UI
    func loadAds() {
        isLoading = true
        apiService.fetchAds { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let ads):
                self.allAds = ads
                self.filteredAds = ads
                self.reloadTableView?()
            case .failure(let error):
                self.errorMessage = (error as? NetworkError)?.errorMessage ?? "An error occurred"
            }
        }
    }

    // Fetches categories and updates the UI
    func loadCategories() {
        isLoading = true
        apiService.fetchCategories { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(var categories):
                let allProductsCategory = Category(id: 0, name: "Tous les produits") // "All Products"
                categories.insert(allProductsCategory, at: 0) // Always first
                self.categories = categories
                self.reloadCategories?()
            case .failure(let error):
                self.errorMessage = (error as? NetworkError)?.errorMessage ?? "An error occurred"
            }
        }
    }

    // Filters ads based on the selected category
    func filterAds() {
        if let categoryId = selectedCategoryId, categoryId != 0 {
            filteredAds = allAds.filter { $0.categoryId == categoryId }
        } else {
            filteredAds = allAds
        }
        reloadTableView?()
    }
}
