import SwiftUI
import Combine

protocol RepositoryGateway {
  func listRepositories(userName: String) -> AnyPublisher<[GitRepository], Error>
}

class RepositoryGatewayImpl: RepositoryGateway {
  
  private var api: ApiGitGateway
  private var storage: CoreProvider<GitRepository>
  
  init(api: ApiGitGateway, storage: CoreProvider<GitRepository>) {
    self.api = api
    self.storage = storage
  }
  
  func listRepositories(userName: String) -> AnyPublisher<[GitRepository], Error> {
    let sort = NSSortDescriptor(key: CoreGitRepository.Attributes.createdAt.rawValue, ascending: true)
    let saved = storage.query(with: nil, sortDescriptors: [sort])
    
    let load = api.listRepositories(userName: userName)
      .catch({ _ -> Empty<[GitRepository], Error> in return .init()})
      .flatMap({ [storage] items in
        storage.save(entities: items).map({_ in items})
      })

    return saved.merge(with: load).eraseToAnyPublisher()
  }
}
