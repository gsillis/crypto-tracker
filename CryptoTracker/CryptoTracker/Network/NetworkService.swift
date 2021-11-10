//
//  NetworkService.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case noData
    case invalidStatusCode(code: Int)
    case custom(error: Error)
}

final class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func requestList<T: Decodable>(url: URL, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }

            if let statusCode = (response as? HTTPURLResponse)?.statusCode, !(200 ... 299 ~= statusCode) {
                return completion(.failure(.invalidStatusCode(code: statusCode)))
            }

            do {
                let list = try JSONDecoder().decode([T].self, from: data)
                return completion(.success(list))

            } catch let error {
                return completion(.failure(.custom(error: error)))
            }

        }
        task.resume()
    }

    func requestAllCryptos(completion: @escaping (Result<[Crypto], NetworkError>) -> Void) {
        guard let url = URL(string:  Constants.baseUrl + "?apikey=" + Constants.apiKey) else {
            return completion(.failure(.badRequest))
        }

        requestList(url: url) { (result: Result<[Crypto], NetworkError>) in
            switch result {
                case .success(var cryptos):
                    self.requestAlIIcons { result in

                        switch result {
                        case .success(let icons):
                            for (index, crypto) in cryptos.enumerated() {
                                    let icon = icons.first(where: {$0.assetId == crypto.asset})
                                    cryptos[index].imageUrl = icon?.url
                            }
                            return completion(.success(cryptos))
                        case .failure(let error):
                            return completion(.failure(error))
                        }
                    }

                case .failure(let error):
                    return completion(.failure(.custom(error: error)))
            }
        }
    }

    func requestAlIIcons(completion: @escaping (Result<[Icon], NetworkError>) -> Void) {
        guard let url = URL(string:  Constants.iconsUrl + "?apikey=" + Constants.apiKey) else {
            return completion(.failure(.badRequest))
        }

        requestList(url: url, completion: completion)
    }
}
