import SwiftUI
import Combine

class AccountHelper: ObservableObject {
  
  @Published var userProfile: UserProfile? = nil
  private var userGatway: UserProfileGateway
  var isAuthorized: Bool {
    return userProfile != nil
  }
  private var cancellables: [AnyCancellable] = []
  
  init(userGatway: UserProfileGateway = UserProfileGatewayImpl.default) {
    self.userGatway = userGatway
    bindContent()
  }
  
  private func bindContent() {
    let subject = userGatway.loadCurrentUser()
      .catch({ (error) -> Empty<UserProfile?, Never> in
        print("loadCurrentUser error: ", error)
        return .init()
      })
      .assign(to: \.userProfile, on: self)
    
    cancellables += [
      subject
    ]
  }
  
}
