import SwiftUI

struct RootView: View {
    @EnvironmentObject var accountHelper: AccountHelper
  
    var body: some View {
      VStack {
        if accountHelper.isAuthorized {
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
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
      RootView().environmentObject(AccountHelper())
    }
}
#endif
