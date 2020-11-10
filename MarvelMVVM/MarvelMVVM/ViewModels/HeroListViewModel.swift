//
//  HeroListViewModel.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit

typealias Heroes = Observable<[HeroesTableViewCellViewModel]>

protocol HeroListViewModelProtocol {
    var heroes: Heroes { get }
    
    func sceneDidLoad()
}

final class HeroListViewModel: Interaction {
    struct Dependencies {
        var fetchCharactersService: GetCharacters = inject()
        var getCharacterImage: GetCharacterImage = inject()
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
                let heroes = characters?.compactMap(self.formatCharacter(_:))
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

extension HeroListViewModel {
    func formatCharacter(_ character: Character) ->  HeroesTableViewCellViewModel {
        let imageObservable = Observable<UIImage?>(nil)
        return .init(image: imageObservable,
                     heroName: character.name ?? "",
                     heroDescription: character.description ?? "",
                     onViewWillDisplay: { [weak self] in
                        guard let self = self else {
                            return
                        }
                        
                        self.dependencies.getCharacterImage.execute(image: character.thumbnail) { (image) in
                            imageObservable.value = image
                        }
        })
    }
}

protocol ViewModel {
    
}

extension ViewModel {
    static func inject() -> HeroListViewModelProtocol {
        return HeroListViewModel()
    }
}
