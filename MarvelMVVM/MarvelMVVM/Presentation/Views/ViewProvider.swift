//
//  ViewProvider.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 10/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit

protocol ViewProvider {
    func heroViewController() -> UIViewController
}

final class ViewProviderAdapter: ViewModel, ViewProvider {
    
    private let storyboard: UIStoryboard = .init(name: "HeroesList", bundle: Bundle(for: ViewProviderAdapter.self))
    
    struct Dependencies {
        var heroListViewModel: HeroListViewModelProtocol = inject()
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
    
    func heroViewController() -> UIViewController {
        return self.instantiateViewController { [weak self] (coder) -> HeroListViewController? in
            guard let self = self else { return nil }
            let vc = HeroListViewController(viewModel: self.dependencies.heroListViewModel, coder: coder)
            vc?.modalPresentationStyle = .fullScreen
            return vc
        }
    }
}

private extension ViewProviderAdapter {
    func instantiateViewController<T: UIViewController>(construct: @escaping (NSCoder) -> T?) -> UIViewController {
        let id = String(describing: T.self)
        return self.storyboard.instantiateViewController(identifier: id) { (coder) -> UIViewController? in
            construct(coder)
        }
    }
}
