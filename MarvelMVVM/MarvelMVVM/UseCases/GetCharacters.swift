//
//  GetCharacters.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

protocol GetCharacters {
    func execute(completion: @escaping ([Character]?) -> Void)
}

final class GetCharactersAdapter: UseCase {
    struct Dependencies {
        var fetchCharactersService: FetchCharactersService = inject()
    }
    
    private var fetchCharactersService: FetchCharactersService {
        return self.dependencies.fetchCharactersService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension GetCharactersAdapter: GetCharacters {
    func execute(completion: @escaping ([Character]?) -> Void) {
        self.fetchCharactersService.execute { response in
            completion(response.data?.results)
        }
    }
}
