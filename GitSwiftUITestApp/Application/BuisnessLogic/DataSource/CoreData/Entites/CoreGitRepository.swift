import Foundation
import CoreData

@objc(CoreGitRepository)
final class CoreGitRepository: NSManagedObject {

}

extension CoreGitRepository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreGitRepository> {
        return NSFetchRequest<CoreGitRepository>(entityName: "CoreGitRepository")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var descriptionField: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: Int64
    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var openIssuesCount: Int32
    @NSManaged public var size: Int32
    @NSManaged public var stargazersCount: Int32
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: String?
    @NSManaged public var watchersCount: Int32
    @NSManaged public var htmlURL: String?
}

extension CoreGitRepository {
  enum Attributes: String {
    case id
    case createdAt
    case descriptionField
    case fullName
    case language
    case name
    case openIssuesCount
    case size
    case stargazersCount
    case updatedAt
    case url
    case watchersCount
    case htmlURL
  }
}

extension CoreGitRepository: DomainConvertibleType {

  func asDomain() -> GitRepository {
    GitRepository(
      id: id,
      fullName: fullName ?? "",
      name: name ?? "",
      openIssuesCount: Int(openIssuesCount),
      size: Int(size),
      descriptionField: descriptionField,
      stargazersCount: Int(stargazersCount),
      language: language,
      updatedAt: updatedAt,
      createdAt: createdAt ?? Date(),
      urlString: url ?? "",
      watchersCount: Int(watchersCount),
      htmlURL: URL(string: htmlURL ?? "")
    )
  }
}

extension CoreGitRepository: Persistable {
  static var entityName: String {
    return "CoreGitRepository"
  }
}

extension GitRepository: CoreDataRepresentable {
  
  func update(entity: CoreGitRepository) {
    entity.id = id
    entity.name = name
    entity.fullName = fullName
    entity.openIssuesCount = Int32(openIssuesCount)
    entity.size = Int32(size)
    entity.descriptionField = descriptionField
    entity.stargazersCount = Int32(stargazersCount)
    entity.language = language
    entity.createdAt = createdAt
    entity.updatedAt = updatedAt
    entity.url = urlString
    entity.watchersCount = Int32(watchersCount)
    entity.htmlURL = htmlURL?.absoluteString
  }
}
