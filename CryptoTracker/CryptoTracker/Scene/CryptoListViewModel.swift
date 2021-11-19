//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import Foundation
import UIKit

final class CryptoListViewModel {

    private var cryptos = [CryptoCellModel]()
    private let service: NetworkService
    private let repository: CryptoRepository

    enum State {
        case loading
        case loaded
        case error(error: Error)
    }

    // observa as mudanças que ocorrem na closure
    var currentState: State = .loading {
        didSet {
            stateChanged?()
        }
    }

    var stateChanged: (() -> Void)?

    var numberOfItems: Int {
        switch currentState {
            case .loaded:
                return cryptos.count
            default:
                return 0
        }
    }

    var stateDescription: String? {
        switch currentState {
            case .loading:
                return "Loading Cryptos..."
            case .loaded:
               return  numberOfItems == 0 ? "No Cryptos Founded" : nil
            case .error(let error):
                return error.localizedDescription
        }
    }

    init(service: NetworkService = NetworkService.shared, repository: CryptoRepository = CryptoRemoteRepository()) {
        self.service = service
        self.repository = repository
    }

    func modelForRow(at index: Int) -> CryptoCellModel {
        return cryptos[index]
    }

    func loadCryptos() {
        currentState = .loading
        repository.requestAllCryptos { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let cryptos):
                self.cryptos = cryptos.map{ CryptoCellModel(crypto: $0) }
                self.currentState = .loaded
            case .failure(let error):
                self.currentState = .error(error: error)
            }
        }
    }
}
