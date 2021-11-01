//
//  HomePresenter.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/31.
//

class HomePresenter {
    private let service: HomeService
    weak fileprivate var homeView: HomeView?
    
    var userList: [UserInfo] = []
    
    init(homeService: HomeService) {
        self.service = homeService
    }
    
    func attachView(view: HomeView) {
        homeView = view
    }
    
    func detachView() {
        homeView = nil
    }
    
    func fetchData(page: Int, query: String) {
        if !query.isEmpty {
            self.service.getUsers(page: page, query: query) { userList, isResult in
                if isResult {
                    self.homeView?.setUsers(userList)
                } else {
                    self.homeView?.setEmpty()
                }
            }
        } else {
            self.homeView?.setEmpty()
        }
    }
    
}
