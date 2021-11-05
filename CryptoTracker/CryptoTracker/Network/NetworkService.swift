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

    func requestAllCryptos(completion: @escaping (Result<[Crypto], NetworkError>) -> Void) {

        guard let url = URL(string: Constants.baseUrl + "?apiKey=" + Constants.apiKey) else {
            return completion(.failure(.badRequest))
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }

            if let response = response as? HTTPURLResponse, !(200...299 ~= response.statusCode) {
                return completion(.failure(.invalidStatusCode(code: response.statusCode)))
            }

            do {
               let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                return completion(.success(cryptos))
            } catch  {
                return completion(.failure(.custom(error: error)))
            }
        }
        task.resume()
    }
}
