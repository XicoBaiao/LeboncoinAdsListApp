//
//  MockAPIService.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import Foundation

class MockAPIService: APIServiceProtocol {
    var shouldReturnError: Bool
    var mockAds: [Ad] = []
    var mockCategories: [Category] = []

    init(shouldReturnError: Bool = false, mockAds: [Ad] = [], mockCategories: [Category] = []) {
        self.shouldReturnError = shouldReturnError
        self.mockAds = mockAds
        self.mockCategories = mockCategories
    }

    func fetchAds(completion: @escaping (Result<[Ad], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.serverError))
        } else {
            completion(.success(mockAds))
        }
    }

    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.badRequest))
        } else {
            completion(.success(mockCategories))
        }
    }
}

