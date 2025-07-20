import Combine
import Depin

@MainActor
class ClientsListViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    private let router: ClientsListRouter

    // MARK: - Public properties

    @Published var clients: [CD_Client] = []

    init(router: ClientsListRouter) {
        self.router = router

        bind()
    }

    private func bind() {
        databaseManager.$clients
            .assign(to: &$clients)
    }

    func close() {
        router.close()
    }

    func importedContacts(_ contacts: [Contact]) {
        contacts.forEach { contact in
            databaseManager.createClient(
                id: contact.id,
                name: contact.familyName + " " + contact.givenName,
                email: contact.email.flatMap { Email($0) },
                phone: contact.phone,
                address: contact.address
            )
        }
    }

    func deleteClient(with id: String) {
        databaseManager.deleteClient(with: id)
    }
}
