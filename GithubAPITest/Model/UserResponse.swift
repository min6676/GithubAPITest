//
//  UserResponse.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/31.
//

struct UserResponse: Codable {
    let total_count: Int
    let items: [UserInfo]
}

struct UserInfo: Codable {
    let login: String
    let avatar_url: String
}
