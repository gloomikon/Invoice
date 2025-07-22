import SwiftUIExt

struct EditClientModule: Module {

    let router: EditClientRouter
    let client: CD_Client

    func build() -> UIViewController {
        let viewModel = EditClientViewModel(
            router: router,
            client: client
        )
        let view = EditClientView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
