import CoreData

/// A protocol providing Core Data helpers for `NSManagedObject` subclasses.
protocol Managed: AnyObject, NSFetchRequestResult {
    /// The `NSEntityDescription` for the object.
    static var entity: NSEntityDescription { get }

    /// The entity name, must match the one in the `.xcdatamodeld` file.
    static var entityName: String { get }

    /// Default sort descriptors used in fetch requests.
    static var defaultSortDescriptors: [NSSortDescriptor] { get }

    /// Default predicate applied to fetch requests.
    static var defaultPredicate: NSPredicate { get }

    /// The object’s managed object context.
    var managedObjectContext: NSManagedObjectContext? { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] { [] }
    static var defaultPredicate: NSPredicate { NSPredicate(value: true) }

    /// Returns a fetch request sorted and filtered with default values.
    /// - Returns: A configured `NSFetchRequest`.
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = defaultPredicate
        return request
    }

    /// Returns a fetch request using the default sort descriptors and an additional predicate.
    /// - Parameter predicate: Additional filtering predicate.
    /// - Returns: A configured `NSFetchRequest`.
    static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        guard let existingPredicate = request.predicate else {
            fatalError("must have predicate")
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
        return request
    }

    /// Creates a compound predicate from a format string and arguments.
    /// - Parameters:
    ///   - format: Format string.
    ///   - args: Arguments for the format string.
    /// - Returns: A compound predicate including the default predicate.
    static func predicate(format: String, _ args: CVarArg...) -> NSPredicate {
        let predicate = withVaList(args) {
            NSPredicate(format: format, arguments: $0)
        }
        return self.predicate(predicate)
    }

    /// Combines default predicate with a given predicate.
    /// - Parameter predicate: Custom predicate.
    /// - Returns: Compound predicate.
    static func predicate(_ predicate: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [defaultPredicate, predicate])
    }
}

extension Managed where Self: NSManagedObject {
    static var entity: NSEntityDescription { entity() }

    static var entityName: String {
        entity.name!
    }

    /// Creates and configures a new object in the context.
    /// - Parameters:
    ///   - context: Core Data context.
    ///   - configure: Configuration block.
    /// - Returns: Newly created object.
    static func create(in context: NSManagedObjectContext, configure: (Self) -> Void) -> Self {
        let newObject: Self = context.insertObject()
        configure(newObject)
        return newObject
    }

    /// Finds or creates an object matching a predicate.
    /// - Parameters:
    ///   - context: Core Data context.
    ///   - predicate: Search predicate.
    ///   - configure: Configuration block for newly created object.
    /// - Returns: Existing or newly created object.
    static func findOrCreate(
        in context: NSManagedObjectContext,
        matching predicate: NSPredicate,
        configure: (Self) -> Void
    ) -> Self {
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }

    /// Finds or creates any existing object without predicate.
    /// - Parameters:
    ///   - context: Core Data context.
    ///   - configure: Configuration block.
    /// - Returns: Existing or newly created object.
    static func findOrCreate(in context: NSManagedObjectContext, configure: (Self) -> Void) -> Self {
        guard let object = findOrFetch(in: context) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }

    /// Finds a materialized or fetched object matching a predicate.
    /// - Parameters:
    ///   - context: Core Data context.
    ///   - predicate: Predicate to match.
    /// - Returns: The found object, or `nil`.
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) {
                $0.predicate = predicate
                $0.returnsObjectsAsFaults = false
                $0.fetchLimit = 1
            }.first
        }
        return object
    }

    /// Finds a materialized or fetched object without predicate.
    /// - Parameter context: Core Data context.
    /// - Returns: The found object, or `nil`.
    static func findOrFetch(in context: NSManagedObjectContext) -> Self? {
        guard let object = materializedObject(in: context) else {
            return fetch(in: context) {
                $0.returnsObjectsAsFaults = false
                $0.fetchLimit = 1
            }.first
        }
        return object
    }

    /// Performs a fetch request.
    /// - Parameters:
    ///   - context: Core Data context.
    ///   - configurationBlock: Configuration block for the request.
    /// - Returns: Fetched objects.
    static func fetch(
        in context: NSManagedObjectContext,
        configurationBlock: (
            NSFetchRequest<Self>
        ) -> Void = { _ in }
    ) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        // swiftlint:disable:next force_try
        return try! context.fetch(request)
    }

    /// Returns the count of objects matching the fetch request.
    /// - Parameters:
    ///   - context: Core Data context.
    ///   - configure: Configuration block for the request.
    /// - Returns: Object count.
    static func count(in context: NSManagedObjectContext, configure: (NSFetchRequest<Self>) -> Void = { _ in }) -> Int {
        let request = NSFetchRequest<Self>(entityName: entityName)
        configure(request)
        // swiftlint:disable:next force_try
        return try! context.count(for: request)
    }

    /// Returns an object from the context’s registered objects matching predicate.
    /// - Parameters:
    ///   - context: Core Data context.
    ///   - predicate: Match condition.
    /// - Returns: The object if found.
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }

    /// Returns any object from the context’s registered objects.
    /// - Parameter context: Core Data context.
    /// - Returns: The object if found.
    static func materializedObject(in context: NSManagedObjectContext) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self else { continue }
            return result
        }
        return nil
    }

    /// Deletes the object from the context.
    /// - Parameter context: Core Data context.
    func delete(in context: NSManagedObjectContext) {
        context.performChanges {
            context.deleteObject(self)
        }
    }

    /// Deletes all objects using batch delete (no FRC updates).
    /// - Parameter context: Core Data context.
    static func deleteAll(in context: NSManagedObjectContext) {
        context.performChanges {
            let fetchRequest = Self.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? context.execute(deleteRequest)
        }
    }

    /// Deletes all objects in background and merges changes to current context.
    /// - Parameters:
    ///   - currentContext: Context to merge deletions into (e.g., `viewContext`).
    ///   - backgroundContext: Background context to perform deletion.
    static func deleteAll(currentContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        backgroundContext.perform {
            let fetchRequest = Self.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs

            do {
                if let result = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult,
                   let objectIDs = result.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [currentContext])
                }
            } catch {
                assertionFailure("Batch delete failed: \(error)")
            }
        }
    }
}
