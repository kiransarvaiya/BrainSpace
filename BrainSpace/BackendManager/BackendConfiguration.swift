//
//  BackendConfiguration.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 30/01/24.
//
import Foundation
import Alamofire

struct BackendConfiguration {
    
    var timeout: TimeInterval {
        
        return 10.0
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        
        return .useProtocolCachePolicy
    }
    
    func baseUrl() throws -> URL {
        if let url = URL(string: "https://jsonplaceholder.typicode.com") {
            return url
        }
        throw APIRequestError.invalidUrl(errorDescription: String(describing: self))
    }
    
    func headers() throws -> HTTPHeaders? {
        
        return [:]
    }
}
