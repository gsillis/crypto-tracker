//
//  CryptoCellModel.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import Foundation

struct CryptoCellModel {
    var name: String {
        crypto.name ?? "No found"
    }
    var symbol: String {
        crypto.asset ?? "Not found"
    }
    var price: String {
        crypto.price?.currency ?? "Not found"
    }

    var imageString: String? {
        crypto.imageUrl
    }

    private let crypto: Crypto

    init(crypto: Crypto) {
        self.crypto = crypto
    }
}
