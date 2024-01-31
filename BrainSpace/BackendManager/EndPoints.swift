//
//  EndPoints.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 30/01/24.
//

import Foundation
import Alamofire

class BaseEndpoint: APIRequestConvertible {
    
    var config: BackendConfiguration {
        
        return BackendManager.defaultConfiguration
    }
    
    var encoding: ParameterEncoding {
        
        return URLEncoding.default
    }
    
    var parameters: Parameters? {
        
        return nil
    }
    
    var method: HTTPMethod {
        
        return .get
    }
    
    func url() throws -> URL {
        
        return try self.config.baseUrl()
    }
    
    func headers() throws -> HTTPHeaders? {
        
        return try self.config.headers()
    }
}

// MARK: - Authentication API EndPoints
class GetPostsListsDataEndPoint: ApiEndpoint<PostsResponse>, APIRequestConvertible {
    let initialParameters: Parameters
    
    var encoding: ParameterEncoding {
        
        return URLEncoding.default
    }
    
    var method: HTTPMethod {
        
        return .get
    }
    
    init(parameters: [String: Any]) {
        
        self.initialParameters = parameters
    }
    
    var parameters: Parameters? {
        
        return self.initialParameters
    }
    
    func url() throws -> URL {
        
        return try self.config.baseUrl().appendingPathComponent("posts")
    }
    
    func headers() throws -> HTTPHeaders? {
        
        return try self.config.headers()
    }
    
}
class GetPostsDataEndPoint: ApiEndpoint<PostsResponse>, APIRequestConvertible {
    let initialParameters: Parameters
    
    var encoding: ParameterEncoding {
        
        return URLEncoding.default
    }
    
    var method: HTTPMethod {
        
        return .get
    }
    
    init(parameters: [String: Any]) {
        
        self.initialParameters = parameters
    }
    
    var parameters: Parameters? {
        
        return self.initialParameters
    }
    
    func url() throws -> URL {
        
        return try self.config.baseUrl().appendingPathComponent("posts/\(parameters?["id"] ?? 0)")
    }
    
    func headers() throws -> HTTPHeaders? {
        
        return try self.config.headers()
    }
    
}
class GetCommentsDataEndPoint: ApiEndpoint<CommentsResponse>, APIRequestConvertible {
    let initialParameters: Parameters
    
    var encoding: ParameterEncoding {
        
        return URLEncoding.default
    }
    
    var method: HTTPMethod {
        
        return .get
    }
    
    init(parameters: [String: Any]) {
        
        self.initialParameters = parameters
    }
    
    var parameters: Parameters? {
        
        return self.initialParameters
    }
    
    func url() throws -> URL {
        
        return try self.config.baseUrl().appendingPathComponent("comments")
    }
    
    func headers() throws -> HTTPHeaders? {
        
        return try self.config.headers()
    }
    
}
