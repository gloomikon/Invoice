import SwiftUIExt

struct PaywallModule: Module {

    let router: PaywallRouter

    func build() -> UIViewController {
        let viewModel = PaywallViewModel(
            router: router
        )
        let view = PaywallView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
