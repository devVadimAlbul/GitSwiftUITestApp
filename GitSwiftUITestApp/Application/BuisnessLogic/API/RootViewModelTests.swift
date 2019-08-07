import Quick
import Nimble
import SwiftUI
import Combine
@testable import GitSwiftUITestApp

class RootViewModelTests: QuickSpec {
  
  var viewModel: RootViewModel!
  
  override func spec() {
    var userGateway: UserProfileGatewayMock!
    
    beforeEach {
      Constants.accountHelper = AccountHelper()
      userGateway = UserProfileGatewayMock()
      self.viewModel = RootViewModel(userGateway: userGateway)
    }
    
    afterEach {
      self.viewModel = nil
    }
    
    describe("load root view modal") {
      
      it("onAppear") {
        let input = self.generateTestUser()
        let output = self.generateTestUser()
        self.testOnAppearAction(gateway: userGateway, inputUser: input, outputUser: output)
      }
      
      it("isAuthorized") {
        let input = self.generateTestUser()
        self.testIsAuthorized(gateway: userGateway, inputUser: input)
      }
    }
  }
  
  func testOnAppearAction(gateway: UserProfileGatewayMock, inputUser: UserProfile?, outputUser: UserProfile?) {
    
    gateway.loadCurrentUserReturnValue = Future({ (subscriber: @escaping (Result<UserProfile?,Error>) -> Void) in
      subscriber(.success(inputUser))
    }).eraseToAnyPublisher()
    
    viewModel.apply(.onAppear)
    
    expect(gateway.loadCurrentUserCalled).to(beTrue())
    expect(gateway.loadCurrentUserCallsCount) == 1
    expect(self.viewModel.output.userProfile).notTo(beNil())
    expect(self.viewModel.output.userProfile?.id) == outputUser?.id
  }
  
  func testIsAuthorized(gateway: UserProfileGatewayMock, inputUser: UserProfile?) {
    
    gateway.loadCurrentUserReturnValue = Future({ (subscriber: @escaping (Result<UserProfile?,Error>) -> Void) in
         subscriber(.success(inputUser))
    }).eraseToAnyPublisher()
    
    expect(self.viewModel.isAuthorized).to(beFalse())
    viewModel.apply(.onAppear)
    expect(self.viewModel.output.userProfile).notTo(beNil())
    expect(self.viewModel.isAuthorized).to(beTrue())
  }
  
  private func generateTestUser() -> UserProfile? {
    return UserProfile(id: 231233)
  }
}
