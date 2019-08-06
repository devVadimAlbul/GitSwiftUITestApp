import Foundation

struct GitRepository: Identifiable {
  var id: Int64
  var fullName: String
  var name: String
  var openIssuesCount: Int
  var size: Int
  var descriptionField: String?
  var stargazersCount: Int = 0
  var language: String?
  var updatedAt: Date?
  var createdAt: Date
  var urlString: String
  var watchersCount: Int = 0
  var htmlURL: URL?
  
  var url: URL {
    return URL(string: urlString)!
  }
}
