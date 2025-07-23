import CoreData

// MARK: - CD_Client

@objc(CD_Client)
class CD_Client: NSManagedObject, Managed, Identifiable {

    static var dateModifiedSortDescriptor: NSSortDescriptor {
        NSSortDescriptor(key: #keyPath(CD_Client.dateModified), ascending: false)
    }

    static var nameSortDescriptor: NSSortDescriptor {
        NSSortDescriptor(
            key: #keyPath(CD_Client.name),
            ascending: true,
            selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
        )
    }

    static var defaultSortDescriptors: [NSSortDescriptor] {
        [nameSortDescriptor]
    }

    @NSManaged private(set) var id: String

    @NSManaged private(set) var name: String

    @NSManaged private var primitiveEmail: String?
    private static let emailKey = "email"

    var email: Email? {
        get {
            willAccessValue(forKey: Self.emailKey)
            let value = primitiveEmail.flatMap { Email($0) }
            didAccessValue(forKey: Self.emailKey)
            return value
        }
        set {
            willChangeValue(forKey: Self.emailKey)
            primitiveEmail = newValue?.email
            didChangeValue(forKey: Self.emailKey)
        }
    }

    @NSManaged private(set) var phone: String?
    @NSManaged private(set) var address: String?

    @NSManaged private(set) var dateCreated: Date
    @NSManaged private(set) var dateModified: Date
}

// MARK: - Helper methods

extension CD_Client {

    @discardableResult
    static func create(
        in context: NSManagedObjectContext,
        id: String?,
        name: String,
        email: Email?,
        phone: String?,
        address: String?
    ) -> Self {
        Self.create(in: context) { client in
            client.id = id ?? UUID().uuidString
            client.name = name
            client.email = email
            client.phone = phone
            client.address = address
            client.dateCreated = Date()
            client.dateModified = Date()
        }
    }

    func update(
        in context: NSManagedObjectContext,
        name: String,
        email: Email?,
        phone: String?,
        address: String?
    ) {
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.dateModified = Date()
    }
}
