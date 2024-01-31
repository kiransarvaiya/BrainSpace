//
//  PostsViewController.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright (c) 2024 Kiran Sarvaiya. All rights reserved.
import UIKit

protocol PostsDisplayLogic: AnyObject {
    func postDetails(viewModel: Posts.fetchDetails.ViewModel)
    func commentsData(viewModel: Posts.comments.ViewModel)
    
    func displayAlert(message: String)
}

class PostsViewController: UIViewController, PostsDisplayLogic {
    var interactor: PostsBusinessLogic?
    var router: (NSObjectProtocol & PostsRoutingLogic & PostsDataPassing)?
    
    // MARK: IBOutlet and object
    //@IBOutlet private weak var nameTextField: UITextField!
    var postDetails: Posts.fetchDetails.ViewModel.DisplayPostsData?
    var commentList: [Posts.comments.ViewModel.DisplayCommentsData]?
    
    @IBOutlet weak var postDetailsTableView: UITableView?
    
    // MARK: Object lifecycle
    
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
        let interactor = PostsInteractor()
        let presenter = PostsPresenter()
        let router = PostsRouter()
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
        fetchPostDetails()
    }
    
    private func setupNavigationTitle() {
        self.title = "Post Information"
    }
    
    private func registerCells() {
        postDetailsTableView?.register(UINib(nibName: String(describing: PostsListTableCell.self), bundle: nil),
                                       forCellReuseIdentifier: String(describing: PostsListTableCell.self))
        postDetailsTableView?.register(UINib(nibName: String(describing: PostsCommentTableCell.self), bundle: nil),
                                       forCellReuseIdentifier: String(describing: PostsCommentTableCell.self))
        
    }
    private func fetchPostDetails() {
        interactor?.getPostsDetails()
        interactor?.getCommentsDetails()
    }
    
    func postDetails(viewModel: Posts.fetchDetails.ViewModel) {
        // Display data from here based on requirements
        postDetails = viewModel.postDetails
        postDetailsTableView?.reloadData()
    }
    
    func commentsData(viewModel: Posts.comments.ViewModel) {
        commentList = viewModel.comments
        postDetailsTableView?.reloadData()
    }
    func displayAlert(message: String) {
        self.presentAlert(message: message)
    }
}
extension PostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return commentList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsListTableCell.self), for: indexPath) as? PostsListTableCell else { return UITableViewCell() }
            cell.setPostDetails(title: postDetails?.title, body: postDetails?.body)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsCommentTableCell.self), for: indexPath) as? PostsCommentTableCell else { return UITableViewCell() }
        guard let commentData = commentList?[indexPath.row] else { return UITableViewCell() }
        cell.setCommentData(commentData.name, email: commentData.email, commentData.body)
        return cell
    }
}
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Post Details"
        }
        return "Comments"
    }
}
