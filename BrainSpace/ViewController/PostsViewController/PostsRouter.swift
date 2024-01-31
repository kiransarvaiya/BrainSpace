//
//  PostsRouter.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

@objc protocol PostsRoutingLogic {
    //private func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol PostsDataPassing {
    var dataStore: PostsDataStore? { get }
}

class PostsRouter: NSObject, PostsRoutingLogic, PostsDataPassing {
    weak var viewController: PostsViewController?
    var dataStore: PostsDataStore?

}
