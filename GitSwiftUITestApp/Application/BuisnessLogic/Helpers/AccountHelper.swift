import SwiftUI

class AccountHelper: ObservableObject {
  
  var isAuthorized: Bool {
    return userProfile != nil
  }
  @Published var userProfile: UserProfile? = nil
  
  init() {
    
  }
}
