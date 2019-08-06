import SwiftUI
import Combine

protocol ApiGitGateway {
  func login(auth: AuthUser) -> AnyPublisher<UserProfile, Error>
  func listRepositories(userName: String) -> AnyPublisher<[GitRepository], Error>
}

class ApiGitGatewayImpl: ApiGitGateway {
  
  private var service: APIService
  
  init(service: APIService = APIService()) {
    self.service = service
  }
  
  func login(auth: AuthUser) -> AnyPublisher<UserProfile, Error> {
    let request = GitLoginApiRequest(auth: auth)
    return service
      .response(from: request)
      .map({$0.asDomain()})
      .eraseToAnyPublisher()
  }
  
  func listRepositories(userName: String) -> AnyPublisher<[GitRepository], Error> {
    let request = GitReposApiRequest(userName: userName)
    return service
      .response(from: request)
      .map({ items in items.map({$0.asDomain()})})
      .eraseToAnyPublisher()
  }
  
}
