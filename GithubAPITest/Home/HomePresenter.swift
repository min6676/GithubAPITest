//
//  HomePresenter.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/31.
//

protocol HomePresenterProtocol {
    func fetchData(page: Int, query: String)
}

class HomePresenter: HomePresenterProtocol {
    private let service: HomeService!
    var userList: [UserInfo] = []
    
    init() {
        self.service = HomeService()
    }
    
    func fetchData(page: Int, query: String) {
    }
    
}
