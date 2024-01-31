//
//  PostsWorker.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

class PostsWorker {
    func callPostDetailsApi(param: Posts.fetchDetails.Request, completionHandler: @escaping (PostsResponse?, Error?) -> Void) {
        Service.shared.getPostsDataService(param) {(result)in
            switch result {
            case .failure (let error):
                completionHandler(nil, error)
            case .success (let objResponse):
                completionHandler(objResponse, nil)
            }
        }
    }
    
    func callPostsCommentsApi(param: Posts.comments.Request, completionHandler: @escaping ([CommentsResponse]?, Error?) -> Void) {
        Service.shared.getCommentsDataService(param) {(result)in
            switch result {
            case .failure (let error):
                completionHandler(nil, error)
            case .success (let objResponse):
                completionHandler(objResponse, nil)
            }
        }
    }
}

