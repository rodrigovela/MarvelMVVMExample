//
//  GetCharacters.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

protocol GetCharacters {
    func execute(completion: @escaping (MarvelCharacters.Response) -> Void)
}

extension UseCase {
    static func inject() -> GetCharacters {
        return GetCharactersAdapter()
    }
}

final class GetCharactersAdapter: InternalService {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = inject()) {
        self.httpClient = httpClient
    }
}

extension GetCharactersAdapter: GetCharacters {
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
