//
//  APIService.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
    case noData
    case unknown
    case serverError
    case badRequest
    case notAuthorized
    case notFound

    var errorMessage: String {
        switch self {
        case .notFound:
            return "Endpoint not found"
        case .badURL:
            return "Bad URL"
        case .badRequest:
            return "Bad Request"
        case .serverError:
            return "Server error"
        case .notAuthorized:
            return "Not authorized"
        case .noData:
            return "No Data in the response"
        default:
            return "An error occurred"
        }
    }
}

enum APIConfig {
    static let baseURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
}

protocol APIServiceProtocol {
    func fetchAds(completion: @escaping (Result<[Ad], Error>) -> Void)
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void)
}

class APIService: APIServiceProtocol {
    static let shared = APIService()

    private init() {}

    var cancellables = Set<AnyCancellable>()

    func fetchAds(completion: @escaping ((Result<[Ad], Error>) -> Void)) {

        guard let url = URL(string: APIConfig.baseURL + "listing.json") else {
            completion(.failure(NetworkError.badURL))
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.noData
                }

                switch response.statusCode {
                case 200...300:
                    return data
                case 400:
                    throw NetworkError.badRequest
                case 401...403:
                    throw NetworkError.notAuthorized
                case 404:
                    throw NetworkError.notFound
                case 500:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Ad].self, decoder: decoder)
            .sink { completed in
                switch completed {
                case .finished:
                    print("Request finished")
                case .failure(let error):
                    completion(.failure(error))
                }
            } receiveValue: { ads in
                completion(.success(ads))
            }
            .store(in: &cancellables)
    }

    func fetchCategories(completion: @escaping ((Result<[Category],Error>) -> Void)) {
        guard let url = URL(string: APIConfig.baseURL + "categories.json") else {
            completion(.failure(NetworkError.badURL))
            return
        }

        let decoder = JSONDecoder()

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.noData
                }

                switch response.statusCode {
                case 200...300:
                    return data
                case 400:
                    throw NetworkError.badRequest
                case 401...403:
                    throw NetworkError.notAuthorized
                case 404:
                    throw NetworkError.notFound
                case 500:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Category].self, decoder: decoder)
            .sink { completed in
                switch completed {
                case .finished:
                    print("Request finished")
                case .failure(let error):
                    completion(.failure(error))
                }
            } receiveValue: { categories in
                completion(.success(categories))
            }
            .store(in: &cancellables)
    }
}
