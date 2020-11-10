//
//  InternalService.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

protocol InternalService {
}

extension InternalService {
    func endOnMainThread<Arg>(completion: @escaping (Arg) -> Void) -> ((Arg) -> Void) {
        return { arg in
            DispatchQueue.main.async {
                completion(arg)
            }
        }
    }
}
