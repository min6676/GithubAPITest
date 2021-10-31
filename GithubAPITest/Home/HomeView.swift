//
//  HomeView.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/11/01.
//

import Foundation

protocol HomeView {
    func startLoading()
    func finishLoading()
    func setUsers(_ users: [UserInfo])
    func setEmpty()
}
