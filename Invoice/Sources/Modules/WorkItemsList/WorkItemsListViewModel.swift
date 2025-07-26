import Combine
import Depin
import Foundation

@MainActor
class WorkItemsListViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    private let router: WorkItemsListRouter
    private let onWorkItemSelected: (CD_WorkItem) -> Void

    // MARK: - Public properties

    @Published private var allWorkItems: [WorkItem] = []
    @Published var searchText = ""

    var workItems: [WorkItem] {
        guard !searchText.isEmpty else { return allWorkItems }

        let query = searchText.lowercased(with: .current)

        return allWorkItems.filter { workItem in
            let nameContains = workItem.name.localizedCaseInsensitiveContains(query)

            return nameContains
        }
    }

    init(
        router: WorkItemsListRouter,
        onWorkItemSelected: @escaping (CD_WorkItem) -> Void
    ) {
        self.router = router
        self.onWorkItemSelected = onWorkItemSelected

        bind()
    }

    private func bind() {
        databaseManager.$workItems
            .map { $0.map(WorkItem.init) }
            .assign(to: &$allWorkItems)
    }

    func close() {
        router.close()
    }

    func workItemSelected(_ workItem: WorkItem) {
        // TODO: - Fix
        onWorkItemSelected(workItem.cdWorkItem!)
    }

    func openCreateWorkItem() {
        router.openCreateWorkItem()
    }

    func deleteWorkItem(with id: UUID) {
        databaseManager.deleteWorkItem(with: id)
    }
}
