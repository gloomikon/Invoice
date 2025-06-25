import CoreData

// MARK: - CD_Business

@objc(CD_Business)
class CD_Business: NSManagedObject, Managed, Identifiable {

    static var dateModifiedSortDescriptor: NSSortDescriptor {
        NSSortDescriptor(key: #keyPath(CD_Business.dateModified), ascending: false)
    }

    static var defaultSortDescriptors: [NSSortDescriptor] {
        [dateModifiedSortDescriptor]
    }

    @NSManaged private(set) var id: UUID

    @NSManaged private(set) var name: String

    @NSManaged private var primitiveContactEmail: String?
    private static let contactEmailKey = "contactEmail"

    var contactEmail: Email? {
        get {
            willAccessValue(forKey: Self.contactEmailKey)
            let value = primitiveContactEmail.flatMap { Email($0) }
            didAccessValue(forKey: Self.contactEmailKey)
            return value
        }
        set {
            willChangeValue(forKey: Self.contactEmailKey)
            primitiveContactEmail = newValue?.email
            didChangeValue(forKey: Self.contactEmailKey)
        }
    }

    @NSManaged private(set) var contactName: String?
    @NSManaged private(set) var contactPhone: String?
    @NSManaged private(set) var contactAddress: String?
    @NSManaged private(set) var logoURLString: String?

    @NSManaged private(set) var dateCreated: Date
    @NSManaged private(set) var dateModified: Date
}

// MARK: - Helper methods

extension CD_Business {

    @discardableResult
    static func create(
        in context: NSManagedObjectContext,
        name: String,
        contactName: String?,
        contactEmail: Email?,
        contactPhone: String?,
        contactAddress: String?,
        logoURLString: String?
    ) -> Self {
        Self.create(in: context) { business in
            business.id = UUID()
            business.name = name
            business.contactName = contactName
            business.contactEmail = contactEmail
            business.contactPhone = contactPhone
            business.contactAddress = contactAddress
            business.logoURLString = logoURLString
            business.dateCreated = Date()
            business.dateModified = Date()
        }
    }
}
