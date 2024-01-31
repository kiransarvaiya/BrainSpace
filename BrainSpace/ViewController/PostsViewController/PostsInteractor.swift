//
//  PostsInteractor.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

protocol PostsBusinessLogic {
    func getPostsDetails()
    func getCommentsDetails()
}

protocol PostsDataStore {
    var postId: Int { get set }
}

class PostsInteractor: PostsBusinessLogic, PostsDataStore {
    var presenter: PostsPresentationLogic?
    let worker = PostsWorker()
    var postId: Int = 0
    
    // MARK: Do get postDetails
    
    func getPostsDetails() {
        let request = Posts.fetchDetails.Request(id: postId)
        worker.callPostDetailsApi(param: request) { (objResponse, error) in
            if error != nil {
                self.presenter?.presentError(error: error!)
            } else if objResponse != nil{
                let response = Posts.fetchDetails.Response(objResponse: objResponse!)
                self.presenter?.presentPostsData(response: response)
            }
        }
    }
    
    func getCommentsDetails() {
        let request = Posts.comments.Request(id: postId)
        worker.callPostsCommentsApi(param: request) { (objResponse, error) in
            if error != nil {
                self.presenter?.presentError(error: error!)
            } else if objResponse != nil{
                let response = Posts.comments.Response(objResponse: objResponse)
                self.presenter?.presentCommentsData(response: response)
            }
        }
    }
}
