import SwiftUIExt

struct ClientsListModule: Module {

    let router: ClientsListRouter
    let onClientSelected: (CD_Client) -> Void

    func build() -> UIViewController {
        let viewModel = ClientsListViewModel(
            router: router,
            onClientSelected: onClientSelected
        )
        let view = ClientsListView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
