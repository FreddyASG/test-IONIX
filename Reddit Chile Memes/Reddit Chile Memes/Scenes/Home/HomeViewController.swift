//
//  HomeViewController.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayPosts(viewModel: Home.Posts.ViewModel)
    func displayError(viewModel: RedditModels.Error.ViewModel)
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultsContentView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var refreshControl: UIRefreshControl!
    private var posts = [New.Child]()
    private var searchText: String?
    
    private struct Constans {
        static let limit = 100
    }
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: - Setup
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
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        setupRefreshControl()
        setupTableView()
        
        fetchPosts()
    }
    
    // MARK: - Methods
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: HomeTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - fetchPosts
    func fetchPosts(isRefresh: Bool = true) {
        
        activityIndicatorView.startAnimating()
        
        let request = Home.Posts.Request(isRefresh: isRefresh,
                                         limit: Constans.limit,
                                         query: searchText)
        interactor?.fetchPosts(request: request)
    }
    
    // MARK: - Actions
    @IBAction func didTapConfig(_ sender: Any) {
        router?.routeToAuthorizationCarousel()
    }
    
    @objc func refresh(_ sender: Any) {
        fetchPosts()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height * 4 {
            fetchPosts(isRefresh: false)
        }
    }
}

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayPosts(viewModel: Home.Posts.ViewModel) {
        posts = viewModel.posts
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
            self.noResultsContentView.isHidden = !self.posts.isEmpty
        }
    }
    
    func displayError(viewModel: RedditModels.Error.ViewModel) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
            
            self.showAlert(title: "Error", message: viewModel.error.description)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? HomeTableViewCell else {
            fatalError()
        }
        
        cell.setupHomeCell(image: posts[indexPath.row].data?.url ?? "",
                           score: posts[indexPath.row].data?.score ?? 0,
                           title: posts[indexPath.row].data?.title ?? "",
                           comments: posts[indexPath.row].data?.numComments ?? 0)
        
        return cell
    }
    
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText.isEmpty ? nil : searchText
        
        fetchPosts()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
