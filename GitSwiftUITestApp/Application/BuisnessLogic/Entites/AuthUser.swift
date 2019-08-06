import Foundation

struct AuthUser {
  var username: String
  var password: String
  
  var key: String {
      return "Authorization"
  }
  
  var value: String {
      let authorization = self.username + ":" + self.password
      return "Basic \(authorization.toBase64() ?? "")"
  }
  
  public func headers() -> [String : String] {
    return [key: value]
  }
}
