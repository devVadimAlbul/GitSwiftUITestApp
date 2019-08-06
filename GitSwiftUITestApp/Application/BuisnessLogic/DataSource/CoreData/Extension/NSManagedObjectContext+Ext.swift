import Foundation
import CoreData
import Combine

extension NSManagedObjectContext {
  func create<T: NSFetchRequestResult>() -> T {
    guard let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self),
                                                           into: self) as? T else {
                                                            fatalError()
    }
    return entity
  }
}

extension NSManagedObjectContext {
  
  func entities<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>) -> AnyPublisher<[T], Error> {
    
    let subject = Future { (subscriber: @escaping (Result<[T],Error>) -> Void) in
      do {
        let feath = try self.fetch(fetchRequest)
        subscriber(.success(feath))
      } catch {
        subscriber(.failure(error))
      }
    }
    
    return subject.eraseToAnyPublisher()
  }
  
  
  func savePubliser() -> AnyPublisher<Void, Error> {
    let subject = Future { (subscriber: @escaping (Result<Void,Error>) -> Void) in
      do {
        try self.save()
        subscriber(.success(()))
      } catch {
        subscriber(.failure(error))
      }
    }
    
    return subject.eraseToAnyPublisher()
  }
  
  func deletePubliser<T: NSManagedObject>(entity: T) -> AnyPublisher<Void, Error> {
    let subject = Future { (subscriber: @escaping (Result<Void,Error>) -> Void) in
      self.delete(entity)
      subscriber(.success(()))
    }
    
    return subject.eraseToAnyPublisher()
  }
  
  func first<T: Persistable>(ofType: T.Type = T.self, with predicate: NSPredicate) -> AnyPublisher<T?, Error> {
    
    let subject = Future { (subscriber: @escaping (Result<T?,Error>) -> Void) in
      let request = NSFetchRequest<T>(entityName: T.entityName)
      request.predicate = predicate
      do {
        let result = try self.fetch(request).first
        subscriber(.success(result))
      } catch {
        subscriber(.failure(error))
      }
    }
    
    return subject.eraseToAnyPublisher()
  }
  
  func sync<C: CoreDataRepresentable, P>(entity: C,
                                         update: @escaping (P) -> Void) -> AnyPublisher<P,Error> where C.CoreDataType == P {
    let predicate: NSPredicate = NSPredicate(format: "id == \(entity.id)")
    return first(ofType: P.self, with: predicate)
      .flatMap({
        return UpdateEntityPublisher(context: self, input: $0, update: update)
      })
      .eraseToAnyPublisher()
  }
  
  func sync<C: CoreDataRepresentable, P>(entities: [C],
                                         update: @escaping (C, P) -> Void) -> AnyPublisher<[P],Error> where C.CoreDataType == P {
    let sort = NSSortDescriptor(key: "id", ascending: true)
    let request = NSFetchRequest<P>(entityName: C.CoreDataType.entityName)
    request.sortDescriptors = [sort]
    return self.entities(fetchRequest: request)
      .flatMap { (items) in
        UpdateEntitiesPublisher(context: self, inputItems: entities, entities: items, update: update)
    }
    .eraseToAnyPublisher()
  }
  
  struct UpdateEntityPublisher<P>: Publisher where P: Persistable {
    
    public typealias Failure = Error
    public typealias Output = P
    
    var context: NSManagedObjectContext
    var input: Output?
    var update: (Output) -> Void
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
      let object = input ?? context.create()
      update(object)
      _ = subscriber.receive(object)
      subscriber.receive(completion: .finished)
    }
  }
  
  struct UpdateEntitiesPublisher<C: CoreDataRepresentable, P>: Publisher where C.CoreDataType == P {
    
    public typealias Failure = Error
    public typealias Output = [P]
    
    var context: NSManagedObjectContext
    var inputItems: [C]
    var entities: [P]
    var update: (C, P) -> Void
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
      let objects = inputItems.map({ [entities, context] item -> P in
        let object = entities.first(where: {$0.id.hashValue == item.id.hashValue}) ?? context.create()
        self.update(item, object)
        return object
      })
      _ = subscriber.receive(objects)
      subscriber.receive(completion: .finished)
    }
  }
}
