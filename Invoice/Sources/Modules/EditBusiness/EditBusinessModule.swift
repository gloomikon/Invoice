import SwiftUIExt

struct EditBusinessModule: Module {

    let router: EditBusinessRouter
    let business: CD_Business

    func build() -> UIViewController {
        let viewModel = EditBusinessViewModel(
            router: router,
            business: business
        )
        let view = EditBusinessView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
