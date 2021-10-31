//
//  HomeService.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/31.
//

import Alamofire

class HomeService {
    func getUsers(page: Int, query: String, completion: @escaping ([UserInfo], Bool) -> Void ) {
        let url = Constant.BASE_URL + "search/users"
        let param = ["q": query, "per_page": 20, "page": page] as [String : Any]
        
        AF.request(url, method: .get, parameters: param, encoding: JSONEncoding.default, headers: Constant.HEADERS).validate().responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let response):
                var isResult = true
                if response.total_count > 0 {
                    isResult = true
                } else {
                    isResult = false
                }
                completion(response.items, isResult)
            case .failure:
                print("Network Error")
            }
        }
    }
}
