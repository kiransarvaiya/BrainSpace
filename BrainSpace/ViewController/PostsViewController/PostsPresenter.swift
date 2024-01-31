//
//  PostsPresenter.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

protocol PostsPresentationLogic {
    func presentPostsData(response: Posts.fetchDetails.Response)
    func presentCommentsData(response: Posts.comments.Response)
    func presentError(error: Error)
}

class PostsPresenter: PostsPresentationLogic {
    weak var viewController: PostsDisplayLogic?
    
    // MARK: Do something
    
    func presentPostsData(response: Posts.fetchDetails.Response) {
        let objPosts = Posts.fetchDetails.ViewModel.DisplayPostsData(title: response.objResponse.title,
                                                                     body: response.objResponse.body)
        let viewModel = Posts.fetchDetails.ViewModel(postDetails: objPosts)
        viewController?.postDetails(viewModel: viewModel)
    }
    
    func presentCommentsData(response: Posts.comments.Response) {
        var viewModelArray: [Posts.comments.ViewModel.DisplayCommentsData] = []
        response.objResponse?.forEach({ comment in
            viewModelArray.append(Posts.comments.ViewModel.DisplayCommentsData(name: comment.name, body: comment.body, email: comment.email))
        })
        let viewModel = Posts.comments.ViewModel(comments: viewModelArray)
        viewController?.commentsData(viewModel: viewModel)
    }
    
    func presentError(error: Error) {
        self.viewController?.displayAlert(message: error.localizedDescription)
    }
}
