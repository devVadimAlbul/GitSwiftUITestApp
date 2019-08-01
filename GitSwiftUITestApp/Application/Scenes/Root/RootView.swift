import SwiftUI

struct RootView: View {
  @EnvironmentObject var acountHelper: AccountHelper
  
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
      RootView().environmentObject(AccountHelper())
    }
}
#endif
