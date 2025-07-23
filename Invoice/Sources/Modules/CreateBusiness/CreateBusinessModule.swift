import SwiftUIExt

struct CreateBusinessModule: Module {

    let router: CreateBusinessRouter

    func build() -> UIViewController {
        let viewModel = CreateBusinessViewModel(
            router: router
        )
        let view = CreateBusinessView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
