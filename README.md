# GithubAPITest
Github API 테스트 앱입니다.

앱 실행을 위해 Config/Secret.swift 를 다음과 같이 생성해주세요.

class K {
    static var HEADERS: HTTPHeaders {
        return ["Authorization" : "token [**Github Personal Access Token 값**]"]
    }
}
