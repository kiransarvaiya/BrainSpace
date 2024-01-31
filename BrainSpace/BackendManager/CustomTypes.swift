//
//  CustomTypes.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 30/01/24.
//

import Foundation

typealias JSON = [String: Any]

enum Result<ResultType> {
    
    case success(ResultType)
    case failure(Error)
}

enum APIRequestError: Error {
    
    case validationFailed(url: URL?, errorDescription: String)
    case invalidUrl(errorDescription: String)
}

enum RequestJSONError: Error {
    
    case parsingFailed
    case mappingFailed
}

enum RequestImageError: Error {
    
    case invalidImageData
    case invalidDataResponse
}
