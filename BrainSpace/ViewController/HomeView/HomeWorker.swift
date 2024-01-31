//
//  HomeWorker.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

class HomeWorker {
    func callPostListsApi(param: Home.fetchLists.Request, completionHandler: @escaping ([PostsResponse]?, Error?) -> Void) {
        Service.shared.getPostsListDataService(param) {(result)in
            switch result {
            case .failure (let error):
                completionHandler(nil, error)
            case .success (let objResponse):
                completionHandler(objResponse, nil)
            }
        }
    }
}
