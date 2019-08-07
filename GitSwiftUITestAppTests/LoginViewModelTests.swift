import Quick
import Nimble
import SwiftUI
import Combine
@testable import GitSwiftUITestApp

class LoginViewModelTests: QuickSpec {
  var viewModel: LoginViewModel!
  
  override func spec() {
    var userGateway: UserProfileGatewayMock!
    
    beforeEach {
      userGateway = UserProfileGatewayMock()
      self.viewModel = LoginViewModel(userGateway: userGateway)
    }
    
    afterEach {
      self.viewModel = nil
      Constants.accountHelper.userProfile = nil
    }
    
    describe("login view modal") {
      it("is Valid Change") {
        self.testValidChange()
      }
      
      it("on Submit Action") {
        let auth = AuthUser(username: "test", password: "test")
        let user = UserProfile(id: 231, login: "test")
        self.testOnSubmitAction(gateway: userGateway, needInputAuth: auth, outputUser: user)
      }
      
      it("on Submit Error") {
        let auth = AuthUser(username: "test", password: "test")
        self.testOnSubmitError(gateway: userGateway, needInputAuth: auth, ouputError: ApiError.dataNotFound)
      }
    }
  }
  
  func testValidChange() {
    expect(self.viewModel.output.isValid).to(beFalse())
    self.viewModel.username = "test"
    self.viewModel.password = "test"
    expect(self.viewModel.output.isValid).to(beTrue())
    self.viewModel.password = ""
    expect(self.viewModel.output.isValid).to(beFalse())
  }
  
  func testOnSubmitAction(gateway: UserProfileGatewayMock, needInputAuth auth: AuthUser, outputUser: UserProfile) {
    
    gateway.loginAuthReturnValue = Future({ (subscriber: @escaping (Result<UserProfile,Error>) -> Void) in
      subscriber(.success(outputUser))
    }).eraseToAnyPublisher()
    self.viewModel.username = auth.username
    self.viewModel.password = auth.password
    
    self.viewModel.apply(.onSubmit)
    
    expect(gateway.loginAuthCalled).to(beTrue())
    expect(gateway.loginAuthCallsCount) == 1
    expect(gateway.loginAuthReceivedAuth?.username) == auth.username
    expect(gateway.loginAuthReceivedAuth?.password) == auth.password
    expect(Constants.accountHelper.userProfile?.id) == outputUser.id
  }
  
  func testOnSubmitError(gateway: UserProfileGatewayMock, needInputAuth auth: AuthUser, ouputError: Error) {
    gateway.loginAuthReturnValue = Future({ (subscriber: @escaping (Result<UserProfile,Error>) -> Void) in
        subscriber(.failure(ouputError))
      }).eraseToAnyPublisher()
    self.viewModel.username = auth.username
    self.viewModel.password = auth.password
    
    self.viewModel.apply(.onSubmit)
    expect(gateway.loginAuthCalled).to(beTrue())
    expect(gateway.loginAuthCallsCount) == 1
    expect(Constants.accountHelper.userProfile).to(beNil())
    expect(self.viewModel.output.isErrorShown).to(beTrue())
    expect(self.viewModel.output.errorMessage) == ouputError.localizedDescription
  }
}
