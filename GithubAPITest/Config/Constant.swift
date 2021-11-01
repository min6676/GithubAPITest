//
//  Constant.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/30.
//
import Alamofire

struct Constant {
    static let BASE_URL = "https://api.github.com/"
    static var HEADERS: HTTPHeaders {
        return ["Authorization" : "token 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"]
    }
}
