//
//  HomeView.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/11/01.
//

import Foundation

protocol HomeView: NSObjectProtocol {
    func setUsers(_ users: [UserInfo], moreFetch: Bool)
    func setEmpty()
}
