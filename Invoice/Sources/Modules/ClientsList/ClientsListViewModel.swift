import CombineExt
import Depin

@MainActor
class ClientsListViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    private let router: ClientsListRouter
    private let onClientSelected: (CD_Client) -> Void

    // MARK: - Public properties

    @Published var clients: [Client] = []

    init(
        router: ClientsListRouter,
        onClientSelected: @escaping (CD_Client) -> Void
    ) {
        self.router = router
        self.onClientSelected = onClientSelected

        bind()
    }

    private func bind() {
        databaseManager.$clients
            .map { $0.map(Client.init) }
            .assign(to: &$clients)
    }

    func close() {
        router.close()
    }

    func clientSelected(_ client: Client) {
        onClientSelected(client.cdClient)
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

    func openCreateClient() {
        router.openCreateClient()
    }

    func deleteClient(with id: String) {
        databaseManager.deleteClient(with: id)
    }
}
