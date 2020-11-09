//
//  MarvelHTTPRequest.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

struct APIKey {
    static let key = ""
}
protocol MarvelHTTPRequest {
    var partialURLpath: String { get }
}

extension MarvelHTTPRequest {
    var urlPath: String {
        return partialURLpath + "?apiKey=\(APIKey.key)"
    }
}
