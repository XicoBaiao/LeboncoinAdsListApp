//
//  Ad.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import Foundation

struct Ad: Codable {
    let id: Int
    let categoryId: Int
    let title: String
    let adDescription: String
    let price: Float
    let imagesUrl: ImageUrls
    let creationDate: Date
    let isUrgent: Bool
    let siret: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case title
        case adDescription = "description"
        case price
        case imagesUrl = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
        case siret
    }
}

struct ImageUrls: Codable {
    let small: String?
    let thumb: String?
}

