import Foundation

struct ApiGitRepository: Decodable {
  var id: Int64
  var fullName: String
  var name: String
  var openIssuesCount: Int
  var size: Int
  var descriptionField: String?
  var stargazersCount: Int = 0
  var language: String?
  var updatedAt: String?
  var createdAt : String?
  var url: String
  var watchersCount: Int = 0
  var htmlUrl: String
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case fullName = "fullName"
    case name = "name"
    case openIssuesCount = "openIssuesCount"
    case size = "size"
    case descriptionField = "description"
    case stargazersCount = "stargazersCount"
    case language = "language"
    case createdAt = "createdAt"
    case updatedAt = "updatedAt"
    case url = "url"
    case watchersCount = "watchersCount"
    case htmlUrl = "htmlUrl"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    guard values.contains(.id) else {
      let error = try ApiParseError(from: decoder)
      throw error
    }
    id = try values.decode(Int64.self, forKey: .id)

    fullName = try values.decode(String.self, forKey: .fullName)
    name = try values.decode(String.self, forKey: .name)
    let issuesCount = try values.decodeIfPresent(Int.self, forKey: .openIssuesCount)
    openIssuesCount = issuesCount ?? 0
    size = try values.decode(Int.self, forKey: .size)
    descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
    let stargCount = try values.decodeIfPresent(Int.self, forKey: .stargazersCount)
    stargazersCount = stargCount ?? 0
    language = try values.decodeIfPresent(String.self, forKey: .language)
    updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    let wCount = try values.decodeIfPresent(Int.self, forKey: .watchersCount)
    watchersCount = wCount ?? 0
    url = try values.decode(String.self, forKey: .url)
    htmlUrl = try values.decode(String.self, forKey: .htmlUrl)
  }
}

extension ApiGitRepository: DomainConvertibleType {
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    return formatter
  }()
  
  func asDomain() -> GitRepository {
    return GitRepository(
      id: id,
      fullName: fullName,
      name: name,
      openIssuesCount: openIssuesCount,
      size: size,
      descriptionField: descriptionField,
      stargazersCount: stargazersCount,
      language: language,
      updatedAt: self.updatedAt != nil ? Self.dateFormatter.date(from: self.updatedAt!) : nil,
      createdAt: (self.createdAt != nil ? Self.dateFormatter.date(from: self.createdAt!) : nil) ?? Date(),
      urlString: url,
      watchersCount: watchersCount,
      htmlURL: URL(string: htmlUrl)
    )
  }
}


extension ApiGitRepository: ApiConvertibleType {
  typealias DomainType = GitRepository
  
  init(with domain: GitRepository) {
    self.id = domain.id
    self.fullName = domain.fullName
    self.name = domain.name
    self.openIssuesCount = domain.openIssuesCount
    self.size = domain.size
    self.descriptionField = domain.descriptionField
    self.stargazersCount = domain.stargazersCount
    self.language = domain.language
    self.updatedAt = domain.updatedAt != nil ? Self.dateFormatter.string(from: domain.updatedAt!) : nil
    self.createdAt = Self.dateFormatter.string(from: domain.createdAt)
    self.url = domain.urlString
    self.watchersCount = domain.watchersCount
    self.htmlUrl = domain.htmlURL?.absoluteString ?? ""
  }
}
