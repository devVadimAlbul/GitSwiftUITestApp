import Foundation
import CoreData
import Combine

protocol CoreDataRepresentable: Identifiable {
   associatedtype CoreDataType: Persistable
   
   func update(entity: CoreDataType)
}

protocol Persistable: NSFetchRequestResult, DomainConvertibleType {
    static var entityName: String { get }
    static func fetchRequest() -> NSFetchRequest<Self>
}
 
extension CoreDataRepresentable {
    func sync(in context: NSManagedObjectContext) -> AnyPublisher<CoreDataType, Error> {
        return context.sync(entity: self, update: update)
    }
}

extension Sequence where Iterator.Element: CoreDataRepresentable {
   func sync(in context: NSManagedObjectContext) -> AnyPublisher<[Element.CoreDataType], Error> {
      return context.sync(entities: Array(self), update: {$0.update(entity: $1)})
   }
}
