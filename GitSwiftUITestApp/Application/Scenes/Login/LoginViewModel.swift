import SwiftUI
import Combine

class LoginViewModel: ObservableObject, ViewModalType {
  typealias InputType = Input
  typealias OutputType = Output
  
  enum Input {
    case onSubmit
  }
  
  struct Output {
    var username: String = ""
    var password: String = ""
    var isValid: Bool = false
    var isErrorShown = false
    var errorMessage = ""
  }
  
  // MARK: property
  private let willChange = PassthroughSubject<Void, Never>()
  private let errorSubject = PassthroughSubject<Error, Never>()
  private let onSubmitSubject = PassthroughSubject<Void, Never>()
  private let authSubject = PassthroughSubject<UserProfile, Never>()
  private var cancellables: [AnyCancellable] = []
  private var userGateway: UserProfileGateway
  
  @Published private(set) var output = Output() {
    didSet {
      willChange.send(())
    }
  }
  
  var isErrorShown: Bool {
    get { return output.isErrorShown }
    set { output.isErrorShown = newValue }
  }
  
  var username: String {
    set { output.username = newValue }
    get { return output.username }
  }
  
  var password: String {
    set { output.password = newValue }
    get { return output.password }
  }
  
  init(userGateway: UserProfileGateway) {
    self.userGateway = userGateway
    bindInputs()
    bindOutput()
  }
  
  // MARK: apply
  func apply(_ input: Input) {
    switch input {
    case .onSubmit: onSubmitSubject.send(())
    }
  }
  
  // MARK: binds
  private func bindInputs() {
    let submitStream = onSubmitSubject
      .filter({self.output.isValid})
      .map({AuthUser(username: self.output.username, password: self.output.password)})
      .flatMap({ [userGateway, errorSubject] auth in
        userGateway.login(auth: auth)
          .catch { (error) -> Empty<UserProfile, Never> in
            errorSubject.send(error)
            return .init()
          }
      })
      .subscribe(authSubject)
    
    cancellables += [
      submitStream
    ]
  }
  
  private func bindOutput() {
    let errorMessageStream = errorSubject
      .map {$0.localizedDescription}
      .assign(to: \.output.errorMessage, on: self)
    
    let errorStream = errorSubject
      .map { _ in true }
      .assign(to: \.output.isErrorShown, on: self)
    
    let validStream = willChange
      .map{ !self.output.username.isEmpty && !self.output.password.isEmpty }
      .removeDuplicates()
      .assign(to: \.output.isValid, on: self)
    
    let authStream = authSubject.sink(receiveValue: {
      Constants.accountHelper.userProfile = $0
    })
    
    cancellables += [
      errorStream,
      errorMessageStream,
      validStream,
      authStream
    ]
  }

}
