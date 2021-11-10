//
//  Models.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import Foundation

struct Crypto: Decodable {
    var asset: String?
    var name: String?
    var price: Double?
    var imageUrl: String? = nil
    enum CodingKeys: String, CodingKey {
        case asset = "asset_id"
        case price = "price_usd"
        case name 
    }
}


struct Icon: Codable {
    let assetId: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case url
    }
}
