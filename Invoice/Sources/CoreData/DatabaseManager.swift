import CombineExt
import CoreData
import Depin

class DatabaseManager: ObservableObject {

    @Injected private var coreDataStack: CoreDataStack

    @MainActor @Published var clients: [CD_Client] = []
    @MainActor @Published var businesses: [CD_Business] = []
    @MainActor @Published var workItems: [CD_WorkItem] = []

    private var context: NSManagedObjectContext {
        coreDataStack.managedContext
    }

    private var clientsFRC: NSFetchedResultsController<CD_Client>?
    private var businessesFRC: NSFetchedResultsController<CD_Business>?
    private var workItemsFRC: NSFetchedResultsController<CD_WorkItem>?

    // MARK: - Public

    func load() async throws {
        try await coreDataStack.load()
        observeClients()
        observeBusinesses()
        observeWorkItems()
    }

    // MARK: - Clients

    func createClient(
        id: String? = nil,
        name: String,
        email: Email?,
        phone: String?,
        address: String?
    ) {
        context.performChanges { [self] in
            CD_Client.create(
                in: context,
                id: id,
                name: name,
                email: email,
                phone: phone,
                address: address
            )
        }
    }

    @MainActor
    func updateClient(
        _ client: CD_Client,
        name: String,
        email: Email?,
        phone: String?,
        address: String?
    ) {
        context.performChanges {
            client.update(
                name: name,
                email: email,
                phone: phone,
                address: address
            )
        }
    }

    @MainActor
    func deleteClient(with id: String) {
        guard let target = clients.first(where: { $0.id == id }) else { return }

        context.performChanges { [self] in
            target.delete(in: context)
        }
    }

    // MARK: - Businesses

    func createBusiness(
        name: String,
        contactName: String?,
        contactEmail: Email?,
        contactPhone: String?,
        contactAddress: String?,
        signatureFileName: String?
    ) {
        context.performChanges { [self] in
            CD_Business.create(
                in: context,
                name: name,
                contactName: contactName,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                contactAddress: contactAddress,
                signatureFileName: signatureFileName
            )
        }
    }

    func updateBusiness(
        _ business: CD_Business,
        name: String,
        contactName: String?,
        contactEmail: Email?,
        contactPhone: String?,
        contactAddress: String?,
        signatureFileName: String?
    ) {
        context.performChanges {
            business.update(
                name: name,
                contactName: contactName,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                contactAddress: contactAddress,
                signatureFileName: signatureFileName
            )
        }
    }

    @MainActor
    func deleteBusiness(with id: UUID) {
        guard let target = businesses.first(where: { $0.id == id }) else { return }

        context.performChanges { [self] in
            target.delete(in: context)
        }
    }

    // MARK: - Items

    func createWorkItem(
        name: String,
        description: String?,
        price: Double,
        quantity: Int,
        unitType: WorkItem.UnitType?,
        discount: DiscountType?,
        taxable: Bool
    ) {
        context.performChanges { [self] in
            CD_WorkItem.create(
                in: context,
                name: name,
                description: description,
                price: price,
                quantity: quantity,
                unitType: unitType,
                discount: discount,
                taxable: taxable
            )
        }
    }

    func updateWorkItem(
        _ item: CD_WorkItem,
        name: String,
        description: String?,
        price: Double,
        quantity: Int,
        unitType: WorkItem.UnitType?,
        discount: DiscountType?,
        taxable: Bool
    ) {
        context.performChanges {
            item.update(
                name: name,
                description: description,
                price: price,
                quantity: quantity,
                unitType: unitType,
                discount: discount,
                taxable: taxable
            )
        }
    }

    @MainActor
    func deleteWorkItem(with id: UUID) {
        guard let target = workItems.first(where: { $0.id == id }) else { return }

        context.performChanges { [self] in
            target.delete(in: context)
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
        let stream = FetchResultStream.make(for: frc)
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
        let stream = FetchResultStream.make(for: frc)
        Task { @MainActor [weak self] in
            for await _ in stream {
                guard let self else { return }
                updateBusinessesMeta()
            }
        }
    }

    func observeWorkItems() {
        let request = CD_WorkItem.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "work_items"
        )
        self.workItemsFRC = frc
        let stream = FetchResultStream.make(for: frc)
        Task { @MainActor [weak self] in
            for await _ in stream {
                guard let self else { return }
                updateWorkItemsMeta()
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

    @MainActor
    func updateWorkItemsMeta() {
        guard let items = workItemsFRC?.sections?.first?.objects as? [CD_WorkItem] else {
            return
        }
        self.workItems = items
    }
}
