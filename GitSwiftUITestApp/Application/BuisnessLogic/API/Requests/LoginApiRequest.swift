import Foundation




struct GitLoginApiRequest: ApiRequest {
  typealias Response = ApiUserProfile
  var auth: AuthUser
  var basicURL: URL = Constants.basicURL
  
  var urlRequest: URLRequest {
    let url = basicURL.appendingPathComponent("user")
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    auth.headers().forEach({ key, value in
      request.addValue(value, forHTTPHeaderField: key)
    })
  
    return request
  }
}

struct GitReposApiRequest: ApiRequest {
   typealias Response = [ApiGitRepository]
   var userName: String
   var basicURL: URL = Constants.basicURL
   
   var urlRequest: URLRequest {
     let url = basicURL.appendingPathComponent("users/\(userName)/repos")
     var request = URLRequest(url: url)
     request.httpMethod = "GET"
    
     return request
   }
}
