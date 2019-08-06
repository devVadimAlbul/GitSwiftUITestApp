import Foundation
import CoreData

@objc(CoreUserProfile)
final class CoreUserProfile: NSManagedObject {

}

extension CoreUserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreUserProfile> {
        return NSFetchRequest<CoreUserProfile>(entityName: "CoreUserProfile")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var bio: String?
    @NSManaged public var blog: String?
    @NSManaged public var collaborators: Int64
    @NSManaged public var company: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?

}

extension CoreUserProfile: DomainConvertibleType {
 
   func asDomain() -> UserProfile {
    return UserProfile(
      id: self.id,
      email: self.email ?? "",
      login: self.login ?? "",
      name: self.name ?? "",
      avatarUrl: self.avatarUrl,
      bio: self.bio,
      blog: self.blog,
      collaborators: Int(self.collaborators),
      company: self.company,
      createdAt: self.createdAt ?? Date(),
      type: self.type,
      url: self.url)
   }
}

extension CoreUserProfile: Persistable {
  static var entityName: String {
    return "CoreUserProfile"
  }
}

extension UserProfile: CoreDataRepresentable {
  
  func update(entity: CoreUserProfile) {
    entity.id = id
    entity.email = email
    entity.login = login
    entity.name = name
    entity.avatarUrl = avatarUrl
    entity.bio = bio
    entity.blog = blog
    entity.collaborators = Int64(collaborators ?? 0)
    entity.company = company
    entity.createdAt = createdAt
    entity.type = type
    entity.url = url
  }
}
