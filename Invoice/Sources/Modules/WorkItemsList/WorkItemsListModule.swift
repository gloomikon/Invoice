import SwiftUIExt

struct WorkItemsListModule: Module {

    let router: WorkItemsListRouter
    let onWorkItemSelected: (CD_WorkItem) -> Void

    func build() -> UIViewController {
        let viewModel = WorkItemsListViewModel(
            router: router,
            onWorkItemSelected: onWorkItemSelected
        )
        let view = WorkItemsListView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
