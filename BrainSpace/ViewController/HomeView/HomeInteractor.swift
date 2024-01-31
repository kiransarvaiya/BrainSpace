//
//  HomeInteractor.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

protocol HomeBusinessLogic {
    func getPostsLists(request: Home.fetchLists.Request)
}

protocol HomeDataStore {
    var postResponse: Home.fetchLists.Response? { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
    var worker = HomeWorker()
    var postResponse: Home.fetchLists.Response?
    
    func getPostsLists(request: Home.fetchLists.Request) {
        worker.callPostListsApi(param: request) { [weak self] (objResponse, error) in
            if error != nil {
                self?.presenter?.presentError(error: error!)
            } else if objResponse != nil{
                let response = Home.fetchLists.Response(objResponse: objResponse?.reversed())
                self?.postResponse = response
                self?.presenter?.presentPostListData(response: response)
            }
        }
    }
}
