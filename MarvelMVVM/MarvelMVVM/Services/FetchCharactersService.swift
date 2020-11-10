//
//  FetchCharacters.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

protocol FetchCharactersService {
    func execute(completion: @escaping (MarvelCharacters.Response) -> Void)
}

extension UseCase {
    static func inject() -> FetchCharactersService {
        return FetchCharactersServiceAdapter()
    }
}

final class FetchCharactersServiceAdapter: InternalService {
    struct Dependencies {
        var httpClient: HTTPClient = inject()
    }
    
    private let dependencies: Dependencies
    
    private var httpClient: HTTPClient {
        return self.dependencies.httpClient
    }
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension FetchCharactersServiceAdapter: FetchCharactersService {
    func execute(completion: @escaping (MarvelCharacters.Response) -> Void) {
        let request = MarvelCharacters()
        let mainThreadCompletion = endOnMainThread(completion: completion)
        self.httpClient.execute(request: request) { (response) in
            switch response.result {
            case .success(let result):
                mainThreadCompletion(result)
            default:
                break
            }
        }
    }
}
