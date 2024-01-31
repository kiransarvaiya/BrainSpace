//
//  APIRequestConvertible.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 30/01/24.
//

import Foundation
import Alamofire

class APIRequest: NSObject {
    let endPoint: APIRequestConvertible
    let dataRequest: DataRequest
    var cancelled = false
    
    var urlRequest: URLRequest? {
        return self.dataRequest.request
    }
    
    var isCancelled: Bool {
        return self.cancelled
    }
    
    init(endPoint: APIRequestConvertible, request: DataRequest) {
        self.endPoint = endPoint
        self.dataRequest = request
    }
    
    func cancel() {
        self.cancelled = true
        self.dataRequest.cancel()
    }
}

protocol APIRequestConvertible {
    func url() throws -> URL
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    func headers() throws -> HTTPHeaders?
    var config: BackendConfiguration { get }
    var validationBlock: (URLRequest?, HTTPURLResponse, Data?) -> Request.ValidationResult { get }
    var dataKeyPath: String? { get }
}

extension APIRequestConvertible {
    
    var method: HTTPMethod {
        return .get
    }
    var parameters: Parameters? {
        return nil
    }
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var validationBlock: (URLRequest?, HTTPURLResponse, Data?) -> Request.ValidationResult {
        return { (
            request, response, data) in
            switch response.statusCode {
            case 200..<400:
                return .success
            default:
                return .failure(APIRequestError.validationFailed(url: response.url, errorDescription: HTTPURLResponse.localizedString(forStatusCode: response.statusCode)))
            }
        }
    }
    var dataKeyPath: String? {
        return nil
    }
}
