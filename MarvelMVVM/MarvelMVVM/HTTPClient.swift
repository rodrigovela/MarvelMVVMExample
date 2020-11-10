//
//  HTTPClient.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

enum HTTPMethod: String, CaseIterable {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case trace = "TRACE"
}

protocol HTTPRequest {
    associatedtype Body: Codable
    associatedtype Response: Codable
    
    var urlPath: String { get }
    var method: HTTPMethod { get }
    var body: Body? { get }
    var headers: [String: String] { get }
}

extension HTTPRequest {
    var headers: [String: String] {
        return [:]
    }
}

struct HTTPResponse<Model> {
    enum Error: Swift.Error {
        case unknown
        case missingInternetConnection
        case badFormedURL
        case badCodingBody(error: Swift.Error)
        case badReponseDecode(error: Swift.Error)
        case serverError
        case httpError(error: Swift.Error?)
    }
    let urlRequest: URLRequest?
    let httpResponse: HTTPURLResponse?
    let result: Result<Model, Error>
}

protocol HTTPClient: class {
    var baseURL: String { get set }
    var headersProvider: HeaderProvider? { get set }
    
    func execute<Request: HTTPRequest>(request: Request,
                                       completion: @escaping (HTTPResponse<Request.Response>) -> Void)
}

protocol HeaderProvider: class {
    func getHeaders() -> [String: String]
}

final class URLSessionHTTPClient {
    private let bodyEncoder: JSONEncoder
    private let responseDecoder: JSONDecoder
    private let urlSession: URLSession
    
    var baseURL: String
    weak var headersProvider: HeaderProvider?
    
    init(baseURL: String,
         urlSession: URLSession,
         bodyEncoder: JSONEncoder = .init(),
         responseDecoder: JSONDecoder = .init()) {
        self.baseURL = baseURL
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
        self.urlSession = urlSession
    }
}

extension URLSessionHTTPClient: HTTPClient {
    private struct Constants {
        static let httpSuccessfullCodeRange = 200...299
    }
    
    func execute<Request: HTTPRequest>(
        request: Request,
        completion: @escaping (HTTPResponse<Request.Response>) -> Void
    ) {
        let responseFactory = HTTPResponseFactory<Request>()
        
        do {
            let urlRequest = try createURLRequest(for: request)
            let task = self.urlSession.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
                responseFactory.urlRequest = urlRequest
                guard
                    let self = self,
                    let httpResponse = urlResponse as? HTTPURLResponse
                else {
                    let missingInternet = (error as NSError?)?.code == NSURLErrorNotConnectedToInternet
                    completion(responseFactory.createFailedResponse(error: missingInternet ? .missingInternetConnection : .unknown))
                    return
                }
                responseFactory.httpResponse = httpResponse
                
                guard Constants.httpSuccessfullCodeRange.contains(httpResponse.statusCode) else {
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                         print("[DEBUG] Error Response: \(json)")
                    }
                   
                    completion(responseFactory.createFailedResponse(error: .httpError(error: error)))
                    return
                }
                
                completion(self.decodeResponse(request: request,
                                               urlRequest: urlRequest,
                                               httpResponse: httpResponse,
                                               data: data, error: error))
            }
            task.resume()
        } catch {
            guard let httpResponseError = error as? HTTPResponse<Request.Response>.Error else {
                completion(responseFactory.createFailedResponse(error: .unknown))
                return
            }
            completion(responseFactory.createFailedResponse(error: httpResponseError))
        }
    }
}

private extension URLSessionHTTPClient {
    func createURLRequest<Request: HTTPRequest>(for request: Request) throws -> URLRequest {
        guard let url = URL(string: baseURL + request.urlPath) else {
            throw HTTPResponse<Request.Response>.Error.badFormedURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let headers = (self.headersProvider?.getHeaders() ?? [:]).merging(request.headers) { $1 }
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try bodyEncoder.encode(body)
            } catch let error {
                throw HTTPResponse<Request.Response>.Error.badCodingBody(error: error)
            }
        }
        
        return urlRequest
    }
    
    func decodeResponse<Request: HTTPRequest>(
        request: Request,
        urlRequest: URLRequest,
        httpResponse: HTTPURLResponse?,
        data: Data?,
        error: Error?) -> HTTPResponse<Request.Response>
    {
        let responseFactory = HTTPResponseFactory<Request>()
        responseFactory.urlRequest = urlRequest
        responseFactory.httpResponse = httpResponse
        
        switch (error: error, data: data) {
        case (error: .some(let requestError), data: _):
            return responseFactory.createFailedResponse(error: .httpError(error: requestError))
        case (error: .none, data: .some(let responseData)):
            do {
                let decodedResponse = try responseDecoder.decode(Request.Response.self, from: responseData)
                return responseFactory.createSuccessfullResponse(response: decodedResponse)
            } catch let error {
                let json = (try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]) ?? [:]
                print("[DEBUG] ERROR RECEIVED: \n \(error) \n [DEBUG] WHILE PARSING: \n \(json)")
                return responseFactory.createFailedResponse(error: .badReponseDecode(error: error))
            }
        case (error: .none, data: .none):
            return responseFactory.createFailedResponse(error: .serverError)
        }
    }
}

private final class HTTPResponseFactory<Request: HTTPRequest> {
    var urlRequest: URLRequest?
    var httpResponse: HTTPURLResponse?
    
    init() {
    }
    
    func createSuccessfullResponse(response: Request.Response) -> HTTPResponse<Request.Response> {
        return .init(urlRequest: urlRequest,
                     httpResponse: httpResponse,
                     result: .success(response))
    }
    
    func createFailedResponse(error: HTTPResponse<Request.Response>.Error) -> HTTPResponse<Request.Response> {
        return .init(urlRequest: urlRequest,
                     httpResponse: httpResponse,
                     result: .failure(error))
    }
}
