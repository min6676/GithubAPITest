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
    @IBOutlet weak var tableView: UITableView!
    
    private var emptyView: UIView?
    private var emptyLabel: UILabel?
    
    fileprivate var users = [UserInfo]()
    fileprivate let presenter = HomePresenter(homeService: HomeService())
    
    
    private var currentPage = 1
    private var requestSearchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    @objc
    func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
    }
}

//MARK: - SearchBar

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        requestSearchWorkItem?.cancel()
        
        let requestSearchWorkItem = DispatchWorkItem {
            self.presenter.fetchData(page: self.currentPage, query: text)
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        
        self.requestSearchWorkItem = requestSearchWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: requestSearchWorkItem)
    }
}

//MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else { return UITableViewCell() }
        
        let data = users[indexPath.row]
        
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

//MARK: - HomeView

extension HomeViewController: HomeView {
    func startLoading() {
    }
    
    func finishLoading() {
    }
    
    func setUsers(_ users: [UserInfo]) {
        self.users = users
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        self.users = []
        DispatchQueue.main.async {
            self.emptyView?.isHidden = false
            self.tableView.reloadData()
        }
        
    }
    
    
}
