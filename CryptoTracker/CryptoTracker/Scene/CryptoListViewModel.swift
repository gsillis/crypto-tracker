//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import Foundation

final class CryptoListViewModel {

    private var cryptos = [CryptoCellModel]()
    private let service: NetworkService

    var numberOfItems: Int {
        return cryptos.count
    }

    init(service: NetworkService = NetworkService.shared) {
        self.service = service
    }

    func modelForRow(at index: Int) -> CryptoCellModel {
        return cryptos[index]
    }

    func loadCryptos() {
        service.requestAllCryptos { [weak self] result in

            guard let self = self else { return }
            
            switch result {
            case .success(let cryptos):
                self.cryptos = cryptos.map{ CryptoCellModel(crypto: $0) }
            case .failure(let error):
                print(error)
            }
        }
    }
}
