//
//  BackendManager.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 30/01/24.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator
import ObjectMapper
import AlamofireObjectMapper

/// Handles communication with backend
class BackendManager {
    static var defaultConfiguration = BackendConfiguration()
    
    private let sessionManager: Alamofire.SessionManager =
    {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        let manager = Alamofire.SessionManager()
        //            manager.startRequestsImmediately = false
        return manager
    }()
    
    private let syncQueue = DispatchQueue(label: "BackendManager.syncQueue", attributes: [])
    private var pendingRequests = [URLRequest: APIRequest]()
    
    deinit {
        self.cancelAllRequests()
    }
    
    class func encodedUrlRquest(for endpoint: APIRequestConvertible) throws -> URLRequest {
        
        var urlRequest = try URLRequest(url: try endpoint.url(), method: endpoint.method, headers: try endpoint.headers())
#if DEBUG
        print("===============================================")
        print("API URL: ->", try endpoint.url())
        print("API Header: ->", try endpoint.headers()!)
        print("API Method: ->", endpoint.method)
        print("API Parameter: -> \(endpoint.parameters!)")
#endif
        urlRequest.cachePolicy = endpoint.config.cachePolicy
        urlRequest.timeoutInterval = endpoint.config.timeout
        urlRequest.httpShouldHandleCookies = false
        
        urlRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies ?? [])
        
        return try endpoint.encoding.encode(urlRequest, with: endpoint.parameters!)
    }
    
    @discardableResult
    func cancelAllRequests() -> [APIRequest] {
        let requests = self.pendingRequests
        requests.forEach { (request) in
            request.value.cancel()
        }
        return requests.map({ $0.value })
    }
    
    @discardableResult
    func requestImage(from endPoint: APIRequestConvertible,
                      progressHandler: @escaping (Progress) -> Void = { (_) in },
                      resizedTo targetSize: CGSize? = nil,
                      completion: @escaping (Result<UIImage>) -> Void) -> APIRequest? {
        let apiRequest = self.requestData(from: endPoint, progressHandler: progressHandler) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(data: let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(RequestImageError.invalidImageData))
                }
            }
        }
        
        return apiRequest
    }
    
    @discardableResult
    func requestData(from endPoint: APIRequestConvertible, progressHandler: @escaping (Progress) -> Void = { (_) in }, completion: @escaping (Result<Data>) -> Void) -> APIRequest? {
        switch self.validatedRequest(endPoint: endPoint, progressHandler: progressHandler) {
        case .failure(let error):
            completion(.failure(error))
            return nil
            
        case .success(let apiRequest):
            apiRequest.dataRequest.responseData(completionHandler: { (response) in
                
                switch response.result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let data):
                    completion(.success(data))
                }
            })
            return apiRequest
        }
    }
    
    @discardableResult
    func requestJSON(endPoint: APIRequestConvertible, progressHandler: @escaping (Progress) -> Void = { (_) in }, completion: @escaping (Result<JSON>) -> Void) -> APIRequest? {
        switch self.validatedRequest(endPoint: endPoint, progressHandler: progressHandler) {
        case .failure(let error):
            completion(.failure(error))
            return nil
            
        case .success(let apiRequest):
            apiRequest.dataRequest.responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let responseValue):
                    switch responseValue as? JSON {
                    case .none:
                        completion(.failure(RequestJSONError.parsingFailed))
                        
                    case .some(let jsonData):
                        completion(.success(jsonData))
                    }
                }
            })
            
            return apiRequest
        }
    }
    
    @discardableResult
    func requestObject<EndPoint, ModelType>(from endPoint: EndPoint,
                                            progressHandler: @escaping (Progress) -> Void = { (_) in },
                                            completion: @escaping (Result<ModelType>) -> Void) -> APIRequest? where EndPoint: ApiEndpoint<ModelType>, EndPoint: APIRequestConvertible, ModelType: Mappable {
        switch self.validatedRequest(endPoint: endPoint, progressHandler: progressHandler) {
        case .failure(let error):
            completion(.failure(error))
            return nil
            
        case .success(let apiRequest):
            apiRequest.dataRequest.responseObject(keyPath: endPoint.dataKeyPath, completionHandler: { (response: DataResponse<ModelType>) -> Void in
                
                switch response.result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let object):
                    completion(.success(object))
                }
            })
            
            return apiRequest
        }
    }
    
    @discardableResult
    func requestObjects<EndPoint, ModelType>(from endPoint: EndPoint,
                                             progressHandler: @escaping (Progress) -> Void = { (_) in },
                                             completion: @escaping (Result<[ModelType]>) -> Void) -> APIRequest? where EndPoint: ApiEndpoint<ModelType>, EndPoint: APIRequestConvertible, ModelType: Mappable {
        switch self.validatedRequest(endPoint: endPoint, progressHandler: progressHandler) {
        case .failure(let error):
            completion(.failure(error))
            return nil
            
        case .success(let apiRequest):
            apiRequest.dataRequest.responseArray(keyPath: endPoint.dataKeyPath, completionHandler: { (response: DataResponse<[ModelType]>) -> Void in
                
                switch response.result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let objects):
                    completion(.success(objects))
                }
            })
            
            return apiRequest
        }
    }
    
    final func didReceive(response: DefaultDataResponse, for apiRequest: APIRequest) {
        self.removePendingRequest(apiRequest)
    }
    
    
    private final func validatedRequest(endPoint: APIRequestConvertible, progressHandler: @escaping (Progress) -> Void = { (_) in }) -> Result<APIRequest> {
        let requestResult = self.createRequest(endPoint: endPoint, progressHandler: progressHandler)
        switch requestResult {
        case .failure(let error):
            return .failure(error)
            
        case .success(let request):
            
            request.dataRequest.validate(endPoint.validationBlock)
            return .success(request)
        }
    }
    
    private final func createRequest(endPoint: APIRequestConvertible, progressHandler: @escaping (Progress) -> Void = { (_) in }) -> Result<APIRequest> {
        do {
            let encodedUrlRequest = try BackendManager.encodedUrlRquest(for: endPoint)
            
            let dataRequest = self.sessionManager.request(encodedUrlRequest)
            let apiRequest = APIRequest(endPoint: endPoint, request: dataRequest)
            
            dataRequest.response(completionHandler: { [unowned self] (response) in
                self.didReceive(response: response, for: apiRequest)
            })
            dataRequest.downloadProgress(closure: progressHandler)
            
            self.syncQueue.sync {
                if let request = dataRequest.request {
                    self.pendingRequests[request] = apiRequest
                }
            }
            
            return .success(apiRequest)
        } catch let error {
            return .failure(error)
        }
    }
    
    private func removePendingRequest(_ apiRequest: APIRequest) {
        self.syncQueue.sync {
            if let request = apiRequest.urlRequest {
                self.pendingRequests[request] = nil
            }
        }
    }
}


