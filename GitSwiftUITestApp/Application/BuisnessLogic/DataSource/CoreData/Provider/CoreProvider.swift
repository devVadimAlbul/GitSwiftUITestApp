import Foundation
import CoreData
import Combine

protocol AbstractProvider {
  associatedtype T
  func query(with predicate: NSPredicate?,
             sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<[T], Error>
  func save(entity: T) -> AnyPublisher<Void, Error>
  func save(entities: [T]) -> AnyPublisher<Void, Error>
  func delete(entity: T) -> AnyPublisher<Void, Error>
}

class CoreProvider<T: CoreDataRepresentable>: AbstractProvider where T == T.CoreDataType.DomainType {
  
  private let persistentContainer: NSPersistentContainer
  private var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  init(persistentContainer: NSPersistentContainer = CoreDataStack.shared.persistentContainer) {
    self.persistentContainer = persistentContainer
  }
  
  func query(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<[T], Error> {
    let featch = T.CoreDataType.fetchRequest()
    featch.predicate = predicate
    featch.sortDescriptors = sortDescriptors
    return context.entities(fetchRequest: featch)
      .mapToDomain()
      .eraseToAnyPublisher()
  }
  
  func save(entity: T) -> AnyPublisher<Void, Error> {
    return entity.sync(in: context)
      .map({_ in })
      .flatMap(context.savePubliser)
      .eraseToAnyPublisher()
  }
  
  func save(entities: [T]) -> AnyPublisher<Void, Error> {
    return entities.sync(in: context)
      .map({ _ in })
      .flatMap(context.savePubliser)
      .eraseToAnyPublisher()
  }
  
  func delete(entity: T) -> AnyPublisher<Void, Error> {
    return entity.sync(in: context)
      .map({$0 as! NSManagedObject})
      .flatMap(context.deletePubliser)
      .eraseToAnyPublisher()
  }
  
}
