import SwiftUI

struct ListRepositoriesView: View {
  
  @ObservedObject var viewModel: ListRepositoriesViewModel
  @EnvironmentObject var accountHelper: AccountHelper
  
  var body: some View {
    NavigationView {
      List(viewModel.repositories) { repository in
        VStack {
          if repository.htmlURL != nil {
             NavigationLink(destination: WebView(url: repository.htmlURL!)
              .navigationBarTitle(Text(repository.name), displayMode: .inline) ) {
               RepositoryRowView(repository: repository)
             }
          } else {
           RepositoryRowView(repository: repository)
          }
        }
      }
      .navigationBarTitle(Text("Repositories"), displayMode: .automatic)
    }
    .onAppear(perform: {
        self.viewModel.apply(.onAppear)
    })
    .alert(isPresented: $viewModel.isErrorShown) { () -> Alert in
      Alert(title: Text("Error"), message: Text(viewModel.output.errorMessage))
    }
  }
}
