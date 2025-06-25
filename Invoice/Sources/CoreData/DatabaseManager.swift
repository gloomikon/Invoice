import CombineExt
import CoreData
import Depin

class DatabaseManager: ObservableObject {

    @Injected private var coreDataStack: CoreDataStack

    @MainActor @Published var clients: [CD_Client] = []

    private var context: NSManagedObjectContext {
        coreDataStack.managedContext
    }

    private var clientsFRC: NSFetchedResultsController<CD_Client>?

    // MARK: - Public

    func load() async throws {
        try await coreDataStack.load()
        observeClients()
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

    @MainActor
    func updateClientsMeta() {
        guard let clients = clientsFRC?.sections?.first?.objects as? [CD_Client] else {
            print("Could not reload clients")
            return
        }
        self.clients = clients
    }
}
