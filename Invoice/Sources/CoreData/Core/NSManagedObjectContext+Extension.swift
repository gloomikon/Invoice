import CoreData

extension NSManagedObjectContext {

    private var store: NSPersistentStore {
        guard let psc = persistentStoreCoordinator else {
            fatalError("PSC missing")
        }
        guard let store = psc.persistentStores.first else {
            fatalError("No Store")
        }
        return store
    }

    var metaData: [String: AnyObject] {
        get {
            guard let psc = persistentStoreCoordinator else {
                fatalError("must have PSC")
            }
            return psc.metadata(for: store) as [String: AnyObject]
        }
        set {
            performChanges {
                guard let psc = self.persistentStoreCoordinator else {
                    fatalError("PSC missing")
                }
                psc.setMetadata(newValue, for: self.store)
            }
        }
    }

    func setMetaData(object: AnyObject?, forKey key: String) {
        var metaData = metaData
        metaData[key] = object
        self.metaData = metaData
    }

    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return obj
    }

    func deleteObject<A: NSManagedObject>(_ object: A) {
        delete(object)
    }

    @discardableResult
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    func performSaveOrRollback() {
        perform {
            _ = self.saveOrRollback()
        }
    }

    func performChanges(block: @escaping () -> Void) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
