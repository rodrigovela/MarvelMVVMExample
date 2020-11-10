//
//  ImageClient.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 10/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import UIKit

protocol ImageClientProtocol {
    func execute(withURL url: String, completion: @escaping (UIImage?) -> Void)
}

final class ImageClient: ImageClientProtocol {
    private struct Constants {
        static let httpSuccesfullCodeRange = 200...299
    }
    
    enum Error: Swift.Error {
        case unknown
        case notInternetConnection
        case badFormedURL
        case httpError(code: String)
    }
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func execute(withURL url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = urlSession.dataTask(with: imageURL) { (data, response, error) in
            guard
                error == nil,
                let httpURLResponse = response?.httpURLResponse,
                httpURLResponse.validate(),
                let data = data
            else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
        }
        
        task.resume()
    }
}

extension URLResponse {
    var httpURLResponse: HTTPURLResponse? {
        return self as? HTTPURLResponse
    }
}

extension HTTPURLResponse {
    private struct Constants {
        static let httpSuccesfullCodeRange = 200...299
    }
    
    func validate() -> Bool {
        return Constants.httpSuccesfullCodeRange.contains(statusCode)
    }
}
