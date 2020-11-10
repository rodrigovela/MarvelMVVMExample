//
//  DataWrapper.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

struct DataWrapper<Entity: Codable>: Codable {
    var data: DataContainer?
    
    struct DataContainer: Codable {
        var offset: Int?
        var limit: Int?
        var total: Int?
        var count: Int?
        var results: Entity?
    }
}
