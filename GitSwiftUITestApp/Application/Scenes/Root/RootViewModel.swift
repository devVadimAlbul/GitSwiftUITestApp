import Foundation
import SwiftUI
import Combine

class RootViewModel: ObservableObject, ViewModalType {
  typealias InputType = Input
  typealias OutputType = Output
  
  enum Input {
    case onAppear
  }
  
  struct Output {
    var userProfile: UserProfile? {
      get { Constants.accountHelper.userProfile }
      set { Constants.accountHelper.userProfile = newValue }
    }
  }
  
  // MARK: property
  private var userGateway: UserProfileGateway
  private var cancellables: [AnyCancellable] = []
  @Published var output: Output = Output()
  var isAuthorized: Bool {
    return output.userProfile != nil
  }
  private let onAppearSubject = PassthroughSubject<Void, Never>()
  private let loadUserSubject = PassthroughSubject<UserProfile?, Never>()
  
  // MARK: life-cycle
  init(userGateway: UserProfileGateway = UserProfileGatewayImpl.default) {
    self.userGateway = userGateway
    bindInput()
    bindOutput()
  }
  
  func apply(_ input: Input) {
    switch input {
    case .onAppear: onAppearSubject.send()
    }
  }
  
  private func bindInput() {
    let subject = onAppearSubject
      .flatMap({
        self.userGateway.loadCurrentUser()
          .catch({ (error) -> Empty<UserProfile?, Never> in
            print("loadCurrentUser error: ", error)
            return .init()
          })
      })
      .subscribe(loadUserSubject)
    
    
    cancellables += [
      subject
    ]
  }
  
  private func bindOutput() {
    let laodStream = loadUserSubject
      .assign(to: \.output.userProfile, on: self)
    
    cancellables += [
      laodStream
    ]
  }
}
