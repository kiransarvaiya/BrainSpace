//
//  HomeViewController.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayPostsList(viewModel: Home.fetchLists.ViewModel)
    func displayAlert(message: String)
    
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    @IBOutlet weak var postListTableView: UITableView?
    // MARK: Object lifecycle
    var posts: [Home.fetchLists.ViewModel.DisplayPostsData]?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build()
    }
    
    private func build() {
        setupNavigationTitle()
        registerCells()
        requestPostListFromServer()
    }
    
    private func setupNavigationTitle() {
        self.title = "Latest Posts"
    }
    
    private func registerCells() {
        postListTableView?.register(UINib(nibName: String(describing: PostsListTableCell.self), bundle: nil),
                                    forCellReuseIdentifier: String(describing: PostsListTableCell.self))
    }
    
    private func requestPostListFromServer() {
        let request = Home.fetchLists.Request()
        interactor?.getPostsLists(request: request)
    }
    
    func displayPostsList(viewModel: Home.fetchLists.ViewModel) {
        // Display data from here based on requirements
        posts = viewModel.posts
        postListTableView?.reloadData()
    }
    func displayAlert(message: String) {
        self.presentAlert(message: message)
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsListTableCell.self), for: indexPath) as? PostsListTableCell else { return UITableViewCell() }
        cell.setPostDetails(title: posts?[indexPath.row].title, body: posts?[indexPath.row].body)
        
        return cell
    }
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToPostDetails(indexPath.row)
    }
}
