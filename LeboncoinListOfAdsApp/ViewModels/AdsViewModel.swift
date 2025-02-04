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
    // List of ads
    var ads: [Ad] = [] {
        didSet {
            reloadTableView?()
        }
    }

    // List of categories
    var categories: [Category] = []

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

    private let apiService: APIServiceProtocol

    // Callbacks to update UI
    var reloadTableView: (() -> Void)?
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
                if !ads.isEmpty {
                    self.ads = ads
                }
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
            case .success(let categories):
                if !categories.isEmpty {
                    self.categories = categories
                }
            case .failure(let error):
                self.errorMessage = (error as? NetworkError)?.errorMessage ?? "An error occurred"
            }
        }
    }
}
