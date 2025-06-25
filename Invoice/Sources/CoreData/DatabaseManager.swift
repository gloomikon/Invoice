import CombineExt
import CoreData
import Depin

class DatabaseManager: ObservableObject {

    @Injected private var coreDataStack: CoreDataStack

    @MainActor @Published var clients: [CD_Client] = []
    @MainActor @Published var businesses: [CD_Business] = []

    private var context: NSManagedObjectContext {
        coreDataStack.managedContext
    }

    private var clientsFRC: NSFetchedResultsController<CD_Client>?
    private var businessesFRC: NSFetchedResultsController<CD_Business>?

    // MARK: - Public

    func load() async throws {
        try await coreDataStack.load()
        observeClients()
        observeBusinesses()
    }

    func createClient(
        name: String,
        email: Email?,
        phone: String?,
        address: String?
    ) {
        context.performChanges { [self] in
            CD_Client.create(
                in: context,
                name: name,
                email: email,
                phone: phone,
                address: address
            )
        }
    }

    func createBusiness(
        name: String,
        contactName: String?,
        contactEmail: Email?,
        contactPhone: String?,
        contactAddress: String?,
        logoURLString: String?
    ) {
        context.performChanges { [self] in
            CD_Business.create(
                in: context,
                name: name,
                contactName: contactName,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                contactAddress: contactAddress,
                logoURLString: logoURLString
            )
        }
    }
}

// MARK: - Private

private extension DatabaseManager {

    func observeClients() {
        let request = CD_Client.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "clients"
        )
        self.clientsFRC = frc
        let stream = stream(for: frc)
        Task { @MainActor [weak self] in
            for await _ in stream {
                guard let self else { return }
                updateClientsMeta()
            }
        }
    }

    func observeBusinesses() {
        let request = CD_Business.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "businesses"
        )
        self.businessesFRC = frc
        let stream = stream(for: frc)
        Task { @MainActor [weak self] in
            for await _ in stream {
                guard let self else { return }
                updateBusinessesMeta()
            }
        }
    }

    @MainActor
    func updateClientsMeta() {
        guard let clients = clientsFRC?.sections?.first?.objects as? [CD_Client] else {
            return
        }
        self.clients = clients
    }

    @MainActor
    func updateBusinessesMeta() {
        guard let businesses = businessesFRC?.sections?.first?.objects as? [CD_Business] else {
            return
        }
        self.businesses = businesses
    }
}
