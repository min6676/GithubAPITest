//
//  UserResponse.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/31.
//

struct UserResponse: Decodable {
    let total_count: Int
    let items: [UserInfo]
}

struct UserInfo: Decodable {
    let login: String
    let avatar_url: String
}
