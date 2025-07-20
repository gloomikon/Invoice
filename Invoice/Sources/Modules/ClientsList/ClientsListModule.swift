import SwiftUIExt

struct ClientsListModule: Module {

    let router: ClientsListRouter

    func build() -> UIViewController {
        let viewModel = ClientsListViewModel(
            router: router
        )
        let view = ClientsListView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
