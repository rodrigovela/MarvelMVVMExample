//
//  MarvelMVVMGateway.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit

public protocol MarvelMVVMGateway {
    func mainViewController() -> UIViewController
}

public final class MarvelMVVMGatewayAdapter: MarvelMVVMGateway {
    struct Dependencies {
        var viewProvider: ViewProvider = ViewProviderAdapter()
    }
    
    let dependencies: Dependencies
    
    public static let instance: MarvelMVVMGateway = MarvelMVVMGatewayAdapter()
    
    private init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension MarvelMVVMGatewayAdapter {
    public func mainViewController() -> UIViewController  {
        return dependencies.viewProvider.heroViewController()
    }
}
