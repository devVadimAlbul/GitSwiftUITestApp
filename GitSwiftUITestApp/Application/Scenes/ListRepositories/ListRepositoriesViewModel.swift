import SwiftUI
import Combine

class ListRepositoriesViewModel: ObservableObject, ViewModalType {
  
  typealias InputType = Input
  typealias OutputType = Output
  
  enum Input {
    case onAppear
  }
  
  struct Output {
    var repositories: [GitRepository] = []
    var isErrorShown = false
    var errorMessage = ""
  }
  
  // MARK: property
  @Published private(set) var output = Output() {
    didSet {
      self.objectWillChange.send()
    }
  }
  private var repositoryGateway: RepositoryGateway
  private var userName: String
  private let onAppearSubject = PassthroughSubject<Void, Never>()
  private let loadListSubject = PassthroughSubject<[GitRepository], Never>()
  private let errorSubject = PassthroughSubject<Error, Never>()
  private var cancellables: [AnyCancellable] = []
  
  var isErrorShown: Bool {
    get { return output.isErrorShown }
    set { output.isErrorShown = newValue }
  }
  var repositories: [GitRepository] {
    get { return output.repositories }
    set { output.repositories = newValue }
  }
  
  // MARK: life-cycle
  init(repositoryGateway: RepositoryGateway, userName: String) {
     self.repositoryGateway = repositoryGateway
     self.userName = userName
     bindInputs()
     bindOutput()
   }
  
  // MARK: apply
  func apply(_ input: Input) {
    switch input {
      case .onAppear: onAppearSubject.send(())
    }
  }
  
  // MARK: binds
  private func bindInputs() {
    let streamLoad = onAppearSubject
      .flatMap({ _ in
        self.repositoryGateway
          .listRepositories(userName: self.userName)
          .catch { (error) -> Empty<[GitRepository], Never> in
            self.errorSubject.send(error)
            return .init()
          }
      })
      .subscribe(loadListSubject)
    
    cancellables += [
      streamLoad
    ]
  }
  
  private func bindOutput() {
    let errorMessageStream = errorSubject
      .map {$0.localizedDescription}
      .assign(to: \.output.errorMessage, on: self)
    
    let errorStream = errorSubject
      .map { _ in true }
      .assign(to: \.output.isErrorShown, on: self)
    
    let loadStream = loadListSubject
      .assign(to: \.output.repositories, on: self)
    
    cancellables += [
      errorMessageStream,
      errorStream,
      loadStream
    ]
  }
}
