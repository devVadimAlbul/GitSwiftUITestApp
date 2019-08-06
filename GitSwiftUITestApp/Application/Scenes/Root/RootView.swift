import SwiftUI

struct RootView: View {
    @EnvironmentObject var accountHelper: AccountHelper
    @ObservedObject var viewModel: RootViewModel
  
    var body: some View {
      VStack {
        if viewModel.isAuthorized {
          ListRepositoriesView(
            viewModel: ListRepositoriesViewModel(
              repositoryGateway: RepositoryGatewayImpl(api: ApiGitGatewayImpl(),
                                                       storage: CoreProvider(persistentContainer: CoreDataStack.shared.persistentContainer)),
              userName: accountHelper.userProfile!.login
            )
          )
        } else {
           LoginView(viewModel: LoginViewModel(
            userGateway: UserProfileGatewayImpl(api: ApiGitGatewayImpl(),
                                                storage: CoreProvider()))
          )
        }
      }
      .onAppear(perform: {
        self.viewModel.apply(.onAppear)
      })
    }
}
