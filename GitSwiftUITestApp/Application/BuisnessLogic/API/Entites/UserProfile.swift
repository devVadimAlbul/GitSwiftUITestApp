import Foundation

struct UserProfile: Identifiable {
  
  var id: Int64
  var email: String = ""
  var login: String = ""
  var name: String = ""
  var avatarUrl: String? = nil
  var bio: String? = nil
  var blog: String? = nil
  var collaborators: Int? = nil
  var company: String? = nil
  var createdAt: Date = Date()
  var type: String? = nil
  var url: String? = nil
  
}


