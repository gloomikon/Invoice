import SwiftUIExt

struct BusinessesListModule: Module {

    let router: BusinessesListRouter
    let onBusinessSelected: (CD_Business) -> Void

    func build() -> UIViewController {
        let viewModel = BusinessesListViewModel(
            router: router,
            onBusinessSelected: onBusinessSelected
        )
        let view = BusinessesListView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
