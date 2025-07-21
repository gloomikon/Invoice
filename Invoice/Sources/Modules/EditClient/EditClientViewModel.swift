import Combine
import Depin
import FoundationExt

@MainActor
class EditClientViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    private let router: EditClientRouter
    private let client: CD_Client

    // MARK: - Public properties

    @Published var name: String
    @Published var email: String
    @Published var phone: String
    @Published var address: String

    init(router: EditClientRouter, client: CD_Client) {
        self.router = router

        self.client = client
        self.name = client.name
        self.email = client.email?.email ?? ""
        self.phone = client.phone ?? ""
        self.address = client.address ?? ""
    }

    func close() {
        router.closeEditClient()
    }

    func save() {
        databaseManager.updateClient(
            client,
            name: name,
            email: Email(email),
            phone: phone.nilIfEmpty,
            address: address.nilIfEmpty
        )
        router.closeEditClient()
    }

    func delete() {
        databaseManager.deleteClient(with: client.id)
        router.closeEditClient()
    }
}
