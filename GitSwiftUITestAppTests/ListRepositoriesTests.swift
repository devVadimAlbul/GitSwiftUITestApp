import Quick
import Nimble
import SwiftUI
import Combine
@testable import GitSwiftUITestApp

class ListRepositoriesTests: QuickSpec {
  var viewModel: ListRepositoriesViewModel!
  
  override func spec() {
    var gateway: RepositoryGatewayMock!
    let userName: String = "test"
    
    beforeEach {
      gateway = RepositoryGatewayMock()
      self.viewModel = ListRepositoriesViewModel(repositoryGateway: gateway, userName: userName)
    }
    
    afterEach {
      self.viewModel = nil
    }
    
    describe("list reposirories view modal") {
      
      it("onAppear") {
        self.testOnAppear(gateway: gateway, inputUserName: userName)
      }
      
      it("loadListRepositoriesSuccess") {
        let list = [
          GitRepository(id: 1, fullName: "test1"),
          GitRepository(id: 2, fullName: "test2"),
          GitRepository(id: 3, fullName: "test3")
        ]
        self.testLoadListSuccess(gateway: gateway, needListRepositories: list)
      }
      
      it("loadListRepositoriesError") {
        self.testLoadListError(gateway: gateway, needError: ApiError.dataNotFound)
      }
    }
  }
  
  func testOnAppear(gateway: RepositoryGatewayMock, inputUserName: String) {
    gateway.listRepositoriesUserNameReturnValue = Future({ (subscriber: @escaping (Result<[GitRepository],Error>) -> Void) in
      subscriber(.success([]))
    }).eraseToAnyPublisher()
    
    self.viewModel.apply(.onAppear)
    
    expect(gateway.listRepositoriesUserNameCalled).to(beTrue())
    expect(gateway.listRepositoriesUserNameCallsCount) == 1
    expect(gateway.listRepositoriesUserNameReceivedUserName) == inputUserName
  }
  
  func testLoadListSuccess(gateway: RepositoryGatewayMock, needListRepositories list: [GitRepository]) {
    gateway.listRepositoriesUserNameReturnValue = Future({ (subscriber: @escaping (Result<[GitRepository],Error>) -> Void) in
      subscriber(.success(list))
    }).eraseToAnyPublisher()
    
    self.viewModel.apply(.onAppear)
    
    expect(gateway.listRepositoriesUserNameCalled).to(beTrue())
    expect(gateway.listRepositoriesUserNameCallsCount) == 1
    expect(self.viewModel.output.repositories).to(contain(list))
  }
  
  func testLoadListError(gateway: RepositoryGatewayMock, needError error: Error) {
    gateway.listRepositoriesUserNameReturnValue = Future({ (subscriber: @escaping (Result<[GitRepository],Error>) -> Void) in
      subscriber(.failure(error))
    }).eraseToAnyPublisher()
    
    self.viewModel.apply(.onAppear)
    
    expect(gateway.listRepositoriesUserNameCalled).to(beTrue())
    expect(gateway.listRepositoriesUserNameCallsCount) == 1
    expect(self.viewModel.output.repositories.isEmpty).to(beTrue())
    expect(self.viewModel.output.isErrorShown).to(beTrue())
    expect(self.viewModel.output.errorMessage) == error.localizedDescription
  }
}
