//
//  Service.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 30/01/24.
//

import Foundation
import Reachability

/// The Service acts as an interface to the BackendManager providing app data updating functionality.

class Service {
    static let shared = Service()
    private let backendManager = BackendManager()
    
    private let reachabilityHelper: Reachability? = {
        
        var reachabilityHelper: Reachability?
        
        if let url = try? BaseEndpoint().url(),
           let reachability = try? Reachability(hostname: url.absoluteString) {
            
            return reachability
        }
        
        return nil
    }()
    
    private var serviceReachable: (() -> Void)?
    
    init() {
        self.setupReachabilityObserver()
    }
    
    private func setupReachabilityObserver() {
        
        self.reachabilityHelper?.whenReachable = { [weak self] (_) in
            self?.serviceReachable?()
        }
        
        do {
            try self.reachabilityHelper?.startNotifier()
            
        } catch let error {
            
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func getPostsListDataService(_ param: Home.fetchLists.Request, completion: @escaping (Result<[PostsResponse]>) -> Void) {
        let endPoint = GetPostsListsDataEndPoint(parameters: [:])
        
        guard let url = try? endPoint.url(),
              let reachability = try? Reachability(hostname: url.absoluteString) else {
            return
        }
        if reachability.connection == .unavailable {
            return
        }
        
        
        self.backendManager.requestObjects(from: endPoint, completion: { result in
            completion(result)
        })
    }
    
    func getPostsDataService(_ param: Posts.fetchDetails.Request, completion: @escaping (Result<PostsResponse>) -> Void) {
        let endPoint = GetPostsDataEndPoint(parameters: ["id": param.id ?? 0])
        
        guard let url = try? endPoint.url(),
              let reachability = try? Reachability(hostname: url.absoluteString) else {
            return
        }
        if reachability.connection == .unavailable {
            return
        }
        
        self.backendManager.requestObject(from: endPoint, completion: { result in
            completion(result)
        })
    }
    
    func getCommentsDataService(_ param: Posts.comments.Request, completion: @escaping (Result<[CommentsResponse]>) -> Void) {
        let endPoint = GetCommentsDataEndPoint(parameters: ["postId": param.id ?? 0])
        
        guard let url = try? endPoint.url(),
              let reachability = try? Reachability(hostname: url.absoluteString) else {
            return
        }
        if reachability.connection == .unavailable {
            return
        }
        
        self.backendManager.requestObjects(from: endPoint, completion: { result in
            completion(result)
        })
    }
}
