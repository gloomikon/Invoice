import SwiftUIExt

struct CreateClientModule: Module {

    let router: CreateClientRouter

    func build() -> UIViewController {
        let viewModel = CreateClientViewModel(
            router: router
        )
        let view = CreateClientView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
