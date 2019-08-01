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
  @Published private(set) var output = Output() {
    didSet {
      willChangeSubject.send(())
    }
  }
  private let willChangeSubject = PassthroughSubject<Void, Never>()
  private let errorSubject = PassthroughSubject<Error, Never>()
  private let onSubmitSubject = PassthroughSubject<Void, Never>()
  private var cancellables: [AnyCancellable] = []
  
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
  
  init() {
    
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
    
    cancellables += [
    ]
  }
  
  private func bindOutput() {
    let errorMessageStream = errorSubject
      .map {$0.localizedDescription}
      .assign(to: \.output.errorMessage, on: self)
    
    let errorStream = errorSubject
      .map { _ in true }
      .assign(to: \.output.isErrorShown, on: self)
    
    let validStream = willChangeSubject
      .map{ !self.output.username.isEmpty && !self.output.password.isEmpty }
      .assign(to: \.output.isValid, on: self)
    
    cancellables += [
      errorStream,
      errorMessageStream,
      validStream
    ]
  }
  
  
  
}

