//
//  CryptoRepository.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 16/11/21.
//

import Foundation
import Moya


protocol CryptoRepository: AnyObject {
    func requestAllCryptos(completion: @escaping(Result<[Crypto], Error>) -> Void)
    func requestAllIcons(completion: @escaping(Result<[Icon], Error>) -> Void)
}

final class CryptoRemoteRepository: CryptoRepository {
    let provider: MoyaProvider<CryptoTarget>

    init(provider: MoyaProvider<CryptoTarget> = MoyaProvider<CryptoTarget>()) {
        self.provider = provider
    }

    func requestAllCryptos(completion: @escaping(Result<[Crypto], Error>) -> Void) {
        provider.request(.loadCryptos) { [weak self] result in

            guard let self = self else { return }
            switch result {
                case .success(let moyaResponse):
                    do {
                        var cryptos =  try moyaResponse.map([Crypto].self)
                        self.requestAllIcons { result in
                            switch result {
                                case .failure(let error):
                                    return completion(.failure(error))
                                case .success(let icons):
                                    for (index, crypto) in cryptos.enumerated() {
                                        let icon = icons.first(where: {$0.assetId == crypto.asset})
                                        cryptos[index].imageUrl = icon?.url
                                    }
                                    return completion(.success(cryptos))
                            }
                        }
                    } catch {
                        return completion(.failure(error))
                    }
                case .failure(let error):
                    return completion(.failure(error))
            }
        }
    }


    func requestAllIcons(completion: @escaping(Result<[Icon], Error>) -> Void) {
        provider.request(.loadImages) { result in
            switch result {
                case .success(let moyaResponse):
                    do {
                        let icons = try moyaResponse.map([Icon].self)
                        return completion(.success(icons))
                    } catch {
                        return completion(.failure(error))
                    }
                case .failure(let error):
                    return completion(.failure(error))
            }
        }
    }
}

