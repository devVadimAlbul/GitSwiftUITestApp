import Foundation


struct ApiUserProfile: Decodable {
  let id: Int64
  let email: String
  let login: String
  let name: String
  let avatarUrl: String?
  let bio: String?
  let blog: String?
  let collaborators : Int?
  let company: String?
  let createdAt: String?
  let type: String?
  let url: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case email = "email"
    case login = "login"
    case name = "name"
    case avatarUrl = "avatar_url"
    case bio = "bio"
    case blog = "blog"
    case collaborators = "collaborators"
    case company = "company"
    case createdAt = "created_at"
    case type = "type"
    case url = "url"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    if !values.contains(.id) {
      let error = try ApiParseError(from: decoder)
      throw error
    }
    id = try values.decode(Int64.self, forKey: .id)
    email = try values.decode(String.self, forKey: .email)
    login = try values.decode(String.self, forKey: .login)
    name = try values.decode(String.self, forKey: .name)
    avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
    bio = try values.decodeIfPresent(String.self, forKey: .bio)
    blog = try values.decodeIfPresent(String.self, forKey: .blog)
    collaborators = try values.decodeIfPresent(Int.self, forKey: .collaborators)
    company = try values.decodeIfPresent(String.self, forKey: .company)
    createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    type = try values.decodeIfPresent(String.self, forKey: .type)
    url = try values.decodeIfPresent(String.self, forKey: .url)
  }
}

extension ApiUserProfile: DomainConvertibleType {
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    return formatter
  }()
  
  func asDomain() -> UserProfile {
    return UserProfile(
      id: self.id,
      email: self.email,
      login: self.login,
      name: self.email,
      avatarUrl: self.avatarUrl,
      bio: self.bio,
      blog: self.blog,
      collaborators: self.collaborators,
      company: self.company,
      createdAt: (self.createdAt != nil ? Self.dateFormatter.date(from: self.createdAt!) : nil) ?? Date(),
      type: self.type,
      url: self.url
    )
  }
}


extension ApiUserProfile: ApiConvertibleType {
  
  init(with domain: UserProfile) {
    self.id = domain.id
    self.email = domain.email
    self.login = domain.login
    self.name = domain.name
    self.avatarUrl = domain.avatarUrl
    self.bio = domain.bio
    self.blog = domain.blog
    self.collaborators = domain.collaborators
    self.company = domain.company
    self.createdAt = Self.dateFormatter.string(from: domain.createdAt)
    self.type = domain.type
    self.url = domain.url
  }
}
