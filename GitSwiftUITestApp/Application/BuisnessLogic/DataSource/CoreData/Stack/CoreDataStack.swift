import Foundation
import CoreData

class CoreDataStack {

  static let shared = CoreDataStack()
  private(set) var persistentContainer: NSPersistentContainer!
  
  private init() {
     self.bindStore()
   }

  private func bindStore() {
    self.persistentContainer = NSPersistentContainer(name: "GitSwiftUITestApp")
      
    persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
      guard let error = error as NSError? else { return }
      fatalError("Unresolved error: \(error), \(error.userInfo)")
    })
    
    persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    persistentContainer.viewContext.undoManager = nil
    persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true
    
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
  }
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}
