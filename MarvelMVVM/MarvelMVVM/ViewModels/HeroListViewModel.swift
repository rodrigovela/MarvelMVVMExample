//
//  HeroListViewModel.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

typealias Heroes = Observable<[HeroesTableViewCellViewModel]>

protocol HeroListViewModelProtocol {
    var heroes: Heroes { get }
    
    func sceneDidLoad()
}

final class HeroListViewModel: Interaction {
    struct Dependencies {
        var fetchCharactersService: GetCharacters = inject()
    }
    
    var heroes: Heroes = .init([])
    
    private let dependencies: Dependencies
      
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getCharacters() {
        self.dependencies.fetchCharactersService.execute { [weak self] characters in
            guard
                let self = self,
                let heroes = characters?.compactMap(HeroesTableViewCellViewModel.init(character:))
            else { return }
            self.heroes.value = heroes
        }
    }
}

extension HeroListViewModel: HeroListViewModelProtocol {
    func sceneDidLoad() {
        self.getCharacters()
    }
}

extension HeroesTableViewCellViewModel {
    init(character: Character) {
        self.heroName = character.name ?? ""
        self.heroDescription = character.description ?? ""
        self.image = character.thumbnail?.path ?? ""
    }
}

protocol ViewModel {
    
}

extension ViewModel {
    static func inject() -> HeroListViewModelProtocol {
        return HeroListViewModel()
    }
}
