//
//  MarvelService.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

final class MarvelService {
    struct Environment {
        static let defaulted = Environment.dev
        static let dev = Environment(baseURL: "http://gateway.marvel.com/v1/public")
        fileprivate var baseURL: String
        fileprivate init(baseURL: String) {
            self.baseURL = baseURL
        }
    }
    
    static let instance = MarvelService()
    
    var environment: Environment
    
    fileprivate lazy var httpClient: HTTPClient = {
        let httpClient = URLSessionHTTPClient(baseURL: self.environment.baseURL,
                                              urlSession: .shared)
        httpClient.headersProvider = self
        return httpClient
    }()
    
    fileprivate lazy var imageClient: ImageClientProtocol = {
        return ImageClient(urlSession: .shared)
    }()
    
    private init(environment: Environment = .defaulted) {
        self.environment = environment
    }
}

extension MarvelService: HeaderProvider {
    func getHeaders() -> [String : String] {
        return [:]
    }
}

extension InternalService {
    static func inject() -> HTTPClient {
        return MarvelService.instance.httpClient
    }
    
    static func inject() -> ImageClientProtocol {
        return MarvelService.instance.imageClient
    }
}
