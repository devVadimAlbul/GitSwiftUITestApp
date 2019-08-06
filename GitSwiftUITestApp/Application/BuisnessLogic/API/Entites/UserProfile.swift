import Foundation

struct UserProfile: Identifiable {
  
  var id: Int64
  var email: String
  var login: String
  var name: String
  var avatarUrl: String?
  var bio: String?
  var blog: String?
  var collaborators : Int?
  var company: String?
  var createdAt: Date
  var type: String?
  var url: String?
  
}


