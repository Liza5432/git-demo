import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Ошибка CoreData: \(error)") }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    func save() {
        if context.hasChanges { try? context.save() }
    }
}
