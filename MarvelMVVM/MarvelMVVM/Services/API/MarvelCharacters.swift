//
//  MarvelCharacters.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

struct MarvelCharacters: HTTPRequest, MarvelHTTPRequest {
    struct APIKey {
        static let key = ""
    }
    typealias Response = DataWrapper<[Character]>
    struct Body: Codable { }
    
    let partialURLpath: String = "/characters"
    let method: HTTPMethod = .get
    let body: Body? = nil
}
