//
//  HeroListViewModel.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

final class HeroListViewModel {
    struct Dependencies {
        var fetchCharactersService: GetCharacters = GetCharactersAdapter()
    }
    
    private let dependencies: Dependencies
      
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getCharacters() {
        self.dependencies.fetchCharactersService.execute { [weak self] characters in
        }
    }
}
