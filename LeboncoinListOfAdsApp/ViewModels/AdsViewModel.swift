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
                switch error {
                case NetworkError.notFound:
                    self.errorMessage = "Endpoint not found"
                case NetworkError.badRequest:
                    self.errorMessage = "Bad Request"
                case NetworkError.serverError:
                    self.errorMessage = "Server error"
                case NetworkError.notAuthorized:
                    self.errorMessage = "Not authorized"
                default:
                    self.errorMessage = "An error occurred"
                }
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
                switch error {
                case NetworkError.notFound:
                    self.errorMessage = "Endpoint not found"
                case NetworkError.badRequest:
                    self.errorMessage = "Bad Request"
                case NetworkError.serverError:
                    self.errorMessage = "Server error"
                case NetworkError.notAuthorized:
                    self.errorMessage = "Not authorized"
                default:
                    self.errorMessage = "An error occurred"
                }
            }
        }
    }
}

