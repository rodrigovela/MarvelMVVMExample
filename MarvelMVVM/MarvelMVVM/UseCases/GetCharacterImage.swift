//
//  GetCharacterImage.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 10/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit

protocol GetCharacterImage {
    func execute(image: Image?, completion: @escaping (UIImage?) -> Void)
}

extension Interaction {
    static func inject() -> GetCharacterImage {
        return GetCharacterImageAdapter()
    }
}

final class GetCharacterImageAdapter: UseCase {
    struct Dependencies {
        var retrieveImageService: RetrieveImageService = inject()
    }
    
    private var retrieveImageService: RetrieveImageService {
        return self.dependencies.retrieveImageService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension GetCharacterImageAdapter: GetCharacterImage {
    func execute(image: Image?, completion: @escaping (UIImage?) -> Void) {
        guard let image = image else {
            completion(nil)
            return
        }
        self.retrieveImageService.execute(image: image,
                                          imageType: .init(orientation: .landscape,
                                                           size: .xlarge),
                                          completion: completion)
    }
}
