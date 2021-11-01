//
//  ViewController.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/29.
//

import UIKit
import Kingfisher
import SnapKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private var emptyView: UIView?
    private var emptyLabel: UILabel?
    
    fileprivate var users = [UserInfo]()
    fileprivate let presenter = HomePresenter(homeService: HomeService())
    
    private var isSearch: Bool = false
    private var moreFetch: Bool = false
    private var query: String?
    private var currentPage = 1
    private var requestSearchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spinner.hidesWhenStopped = true
        
        setupSearchBar()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupEmtpyView()
        
        presenter.attachView(view: self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    private func setupEmtpyView() {
        emptyView = UIView()
        self.view.addSubview(emptyView!)
        
        emptyView!.backgroundColor = tableView.backgroundColor
        emptyView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLabel = UILabel()
        emptyLabel!.textColor = self.navigationItem.titleView?.tintColor
        emptyLabel!.text = "Search Users"
        emptyView!.addSubview(emptyLabel!)
        emptyLabel!.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Users"
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.keyboardType = .asciiCapable
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    @objc
    func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    func fetchUsers() {
        self.currentPage += 1
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.spinner?.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.spinner?.stopAnimating()
            self.tableView.contentInset = UIEdgeInsets.zero
            self.presenter.fetchData(page: self.currentPage, query: self.query ?? "")
        }
    }
}

//MARK: - SearchBar

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        requestSearchWorkItem?.cancel()
        
        if query != searchController.searchBar.text {
            let requestSearchWorkItem = DispatchWorkItem { [weak self] in
                self?.query = searchController.searchBar.text
                self?.isSearch = true
                self?.currentPage = 1
                self?.presenter.fetchData(page: self!.currentPage, query: self?.query ?? "")
                self?.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
            
            self.requestSearchWorkItem = requestSearchWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: requestSearchWorkItem)
        }
    }
}

//MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else { return UITableViewCell() }
        
        let data = self.users[indexPath.row]
        
        cell.userLabel.text = data.login
        let downsamplingProcessor = DownsamplingImageProcessor(size: cell.profileImageView.frame.size)
        let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: cell.profileImageView.layer.cornerRadius)
        cell.profileImageView.kf.setImage(with: URL(string: data.avatar_url), options: [.processor(downsamplingProcessor |> roundCornerProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

//MARK: - ScrollView

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 0 && self.moreFetch
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) && moreFetch {
            self.moreFetch = false
            if !self.spinner.isAnimating {
                fetchUsers()
            }
        }
    }

}

//MARK: - HomeView

extension HomeViewController: HomeView {
    func setUsers(_ users: [UserInfo], moreFetch: Bool) {
        self.moreFetch = moreFetch
        if isSearch {
            self.users.removeAll()
            self.isSearch = false
        }
        self.users += users
        self.tableView.reloadData()
        if self.emptyView?.isHidden == false {
            self.emptyView?.isHidden = true
        }
    }
    
    func setEmpty() {
        guard let text = navigationItem.searchController?.searchBar.text else { return }
        
        if text.isEmpty {
            DispatchQueue.main.async {
                self.emptyLabel?.text = "Search Users"
            }
            
        } else {
            DispatchQueue.main.async {
                self.emptyLabel?.text = "No Result"
            }
        }
        self.users.removeAll()
        self.emptyView?.isHidden = false
        self.tableView.reloadData()
        
    }
    
    
}
