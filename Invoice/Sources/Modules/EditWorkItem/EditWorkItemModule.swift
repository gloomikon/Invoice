import SwiftUIExt

struct EditWorkItemModule: Module {

    let router: EditWorkItemRouter
    let workItem: CD_WorkItem

    func build() -> UIViewController {
        let viewModel = EditWorkItemViewModel(
            router: router,
            workItem: workItem
        )
        let view = EditWorkItemView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
