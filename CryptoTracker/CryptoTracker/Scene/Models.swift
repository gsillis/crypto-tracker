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

    enum CodingKeys: String, CodingKey {
        case asset = "asset_id"
        case name = "name"
        case price = "price_usd"
    }
}
