import Foundation

struct GitRepository: Identifiable, Equatable, Hashable {
  var id: Int64
  var fullName: String = ""
  var name: String = ""
  var openIssuesCount: Int = 0
  var size: Int = 0
  var descriptionField: String? = nil
  var stargazersCount: Int = 0
  var language: String? = nil
  var updatedAt: Date? = nil
  var createdAt: Date = Date()
  var urlString: String = ""
  var watchersCount: Int = 0
  var htmlURL: URL? = nil
  
  var url: URL {
    return URL(string: urlString)!
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(fullName)
    hasher.combine(name)
    hasher.combine(openIssuesCount)
    hasher.combine(size)
    hasher.combine(descriptionField)
    hasher.combine(stargazersCount)
    hasher.combine(language)
    hasher.combine(updatedAt)
    hasher.combine(createdAt)
    hasher.combine(urlString)
    hasher.combine(watchersCount)
    hasher.combine(htmlURL)
  }
  
  static func == (lhs: GitRepository, rhs: GitRepository) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
