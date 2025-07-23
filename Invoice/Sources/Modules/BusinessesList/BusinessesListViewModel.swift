import Combine
import Depin
import Foundation

@MainActor
class BusinessesListViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    private let router: BusinessesListRouter
    private let onBusinessSelected: (CD_Business) -> Void

    // MARK: - Public properties

    @Published private var allBusinesses: [Business] = []
    @Published var searchText = ""

    var businesses: [Business] {
        guard !searchText.isEmpty else { return allBusinesses }

        let query = searchText.lowercased(with: .current)

        return allBusinesses.filter { business in
            let nameContains = business.name.localizedCaseInsensitiveContains(query)
            let contactNameContains = business.contactName?.localizedCaseInsensitiveContains(query) == true
            let emailContains = business.contactEmail?.email.localizedCaseInsensitiveContains(query) == true
            let phoneContains = business.contactPhone?.contains(query) == true

            return nameContains || contactNameContains || emailContains || phoneContains
        }
    }

    init(
        router: BusinessesListRouter,
        onBusinessSelected: @escaping (CD_Business) -> Void
    ) {
        self.router = router
        self.onBusinessSelected = onBusinessSelected

        bind()
    }

    private func bind() {
        databaseManager.$businesses
            .map { $0.map(Business.init) }
            .assign(to: &$allBusinesses)
    }

    func close() {
        router.close()
    }

    func businessSelected(_ business: Business) {
        onBusinessSelected(business.cdBusiness)
    }

    func openCreateBusiness() {
        router.openCreateBusiness()
    }

    func deleteBusiness(with id: UUID) {
        databaseManager.deleteBusiness(with: id)
    }
}
