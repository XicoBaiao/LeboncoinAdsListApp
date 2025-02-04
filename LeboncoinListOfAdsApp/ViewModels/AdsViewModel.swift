//
//  AdsViewModel.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import Foundation
import SwiftUI

class AdsViewModel {
    var ads: [Ad] = [] {
        didSet {
            reloadTableView?()
        }
    }
    var categories: [Category] = []
    var errorMessage: String?

    private let apiService: APIServiceProtocol

    var reloadTableView: (() -> Void)?

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    func loadAds() {
        apiService.fetchAds { [weak self] result in
            guard let self = self else {return}
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

    func loadCategories() {
        apiService.fetchCategories { [weak self] result in
            guard let self = self else {return}
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

