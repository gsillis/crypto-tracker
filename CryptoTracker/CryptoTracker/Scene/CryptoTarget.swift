//
//  CryptoTarget.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 16/11/21.
//

import Foundation
import Moya

enum CryptoTarget: TargetType {
    case loadCryptos
    case loadImages
    
    var baseURL: URL {
        switch self {
            case .loadCryptos:
                return Constants.url
            case .loadImages:
                return Constants.imageAssetUrl
        }
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestParameters(parameters: ["apiKey" : Constants.apiKey],
                                                    encoding: URLEncoding.queryString)
    }

    var headers: [String : String]?  {
        Constants.Headers.contentTypeApplicationJSON
    }
}

