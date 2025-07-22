import Combine
import Depin

@MainActor
class CreateClientViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var address: String = ""

    private let router: CreateClientRouter

    init(router: CreateClientRouter) {
        self.router = router
    }

    func close() {
        router.closeCreateClient()
    }

    func save() {
        databaseManager.createClient(
            name: name,
            email: Email(email),
            phone: phone.nilIfEmpty,
            address: address.nilIfEmpty
        )
        router.closeCreateClient()
    }

    func importedContact(_ contact: Contact) {
        name = contact.familyName + " " + contact.givenName
        email = contact.email ?? ""
        phone = contact.phone ?? ""
        address = contact.address ?? ""
    }
}
