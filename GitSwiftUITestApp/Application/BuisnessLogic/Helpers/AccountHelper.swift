import SwiftUI
import Combine

class AccountHelper: ObservableObject {
  
  @Published var userProfile: UserProfile? = nil

  init() {
  
  }
  
}
