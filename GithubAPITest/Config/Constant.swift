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
