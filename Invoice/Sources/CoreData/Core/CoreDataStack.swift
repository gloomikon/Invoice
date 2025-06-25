import CoreData

class CoreDataStack {

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Invoice")
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = {
        container.viewContext
    }()

    @MainActor func load() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { _, error in
                if let error {
                    print("Failed to load persistent container with error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    #if DEBUG
                    fatalError()
                    #endif
                } else {
                    print("Persistent container loaded successfully")
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
