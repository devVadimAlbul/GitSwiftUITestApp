import Foundation
import SwiftUI
import Combine

protocol UserProfileGateway {
  func loadCurrentUser() -> AnyPublisher<UserProfile?, Error>
  func login(auth: AuthUser) -> AnyPublisher<UserProfile, Error>
}

class UserProfileGatewayImpl: UserProfileGateway {
  
  private var api: ApiGitGateway
  private var storage: CoreProvider<UserProfile>
  
  init(api: ApiGitGateway, storage: CoreProvider<UserProfile>) {
    self.api = api
    self.storage = storage
  }
  
  func loadCurrentUser() -> AnyPublisher<UserProfile?, Error> {
    let sort = NSSortDescriptor(key: "id", ascending: true)
    return storage.query(with: nil, sortDescriptors: [sort])
      .map({$0.first})
      .eraseToAnyPublisher()
  }
  
  
  func login(auth: AuthUser) -> AnyPublisher<UserProfile, Error> {
    return api.login(auth: auth)
      .flatMap({ [storage] entity in
        return storage.save(entity: entity).map({_ in entity})
      })
      .eraseToAnyPublisher()
  }
  
  
  
  static var `default`: UserProfileGatewayImpl {
    return UserProfileGatewayImpl(
              api: ApiGitGatewayImpl(service: APIService()),
              storage: CoreProvider(persistentContainer: CoreDataStack.shared.persistentContainer)
            )
  }
}
