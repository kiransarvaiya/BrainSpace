//
//  HomeRouter.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.
import UIKit

@objc protocol HomeRoutingLogic {
    func routeToPostDetails(_ postIndex: Int)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Routing
    
    func routeToPostDetails(_ postIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPostDetails(source: dataStore!, destination: &destinationDS, postIndex)
        navigateToPostDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToPostDetails(source: HomeViewController, destination: PostsViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToPostDetails(source: HomeDataStore, destination: inout PostsDataStore, _ postIndex: Int) {
        destination.postId = source.postResponse?.objResponse?[postIndex].id ?? 0
    }
}
