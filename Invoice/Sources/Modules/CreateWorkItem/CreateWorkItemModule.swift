import SwiftUIExt

struct CreateWorkItemModule: Module {

    let router: CreateWorkItemRouter

    func build() -> UIViewController {
        let viewModel = CreateWorkItemViewModel(
            router: router
        )
        let view = CreateWorkItemView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
