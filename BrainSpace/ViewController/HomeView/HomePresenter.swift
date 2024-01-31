//
//  HomePresenter.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

protocol HomePresentationLogic {
    func presentPostListData(response: Home.fetchLists.Response)
    func presentError(error: Error) 
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentPostListData(response: Home.fetchLists.Response) {
        var viewModelArray: [Home.fetchLists.ViewModel.DisplayPostsData] = []
        response.objResponse?.forEach({ post in
            viewModelArray.append(Home.fetchLists.ViewModel.DisplayPostsData(title: post.title, body: post.body))
        })
        let viewModel = Home.fetchLists.ViewModel(posts: viewModelArray)
        viewController?.displayPostsList(viewModel: viewModel)
    }
    
    func presentError(error: Error) {
        self.viewController?.displayAlert(message: error.localizedDescription)
    }
}
