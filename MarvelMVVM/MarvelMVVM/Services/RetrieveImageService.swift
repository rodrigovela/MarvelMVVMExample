//
//  RetrieveImageService.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 10/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit

protocol RetrieveImageService {
    func execute(image: Image, imageType: ImageType, completion: @escaping (UIImage?) -> Void)
}

extension UseCase {
    static func inject() -> RetrieveImageService {
        return RetrieveImageServiceAdapter()
    }
}

struct ImageType {
    var orientation: ImageOrientation = .standard
    var size: ImageSize = .small
    
    fileprivate var path: String {
        return "\(self.orientation)_\(self.size)"
    }
}

enum ImageOrientation: String {
    case portrait
    case standard
    case landscape
}

enum ImageSize: String {
    case small
    case medium
    case xlarge
    case fantastic
    case uncanny
    case incredible
}

final class RetrieveImageServiceAdapter: InternalService {
    struct Dependencies {
        var imageClient: ImageClientProtocol = inject()
    }
    
    private let dependencies: Dependencies
    
    private var imageClient: ImageClientProtocol {
        return self.dependencies.imageClient
    }
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension RetrieveImageServiceAdapter: RetrieveImageService {
    func execute(image: Image, imageType: ImageType, completion: @escaping (UIImage?) -> Void) {
        guard let path = image.fullPath(imageType: imageType) else {
            completion(nil)
            return
        }
        let completionMain = self.endOnMainThread(completion: completion)
        self.imageClient.execute(withURL: path, completion: completionMain)
    }
}

extension Image {
    func fullPath(imageType: ImageType) -> String? {
        guard
            let resourceUrl = self.path,
            let ext = self.extension
        else {
            return nil
        }
        
        return "\(resourceUrl)/\(imageType.path).\(ext)"
    }
}
