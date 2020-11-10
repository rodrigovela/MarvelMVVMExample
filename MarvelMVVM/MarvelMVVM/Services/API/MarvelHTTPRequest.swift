//
//  MarvelHTTPRequest.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation
import CommonCrypto

struct APIKey {
    static let key = ""
    static let privateKey = ""
}
protocol MarvelHTTPRequest {
    var partialURLpath: String { get }
}

extension MarvelHTTPRequest {
    var ts: String {
        return Date().timeIntervalSince1970.description
    }
    var urlPath: String {
        let timeStamp = self.ts
        return partialURLpath + "?apikey=\(APIKey.key)&ts=\(timeStamp)&hash=\((timeStamp + APIKey.privateKey + APIKey.key).md5)"
    }
    
    
}

extension String {
    var md5: String {
        let data = self.data(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        _ = data!.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data!.count), &digest)
        }

        return digest.reduce(into: "") { $0 += String(format: "%02x", $1) }
    }
}
