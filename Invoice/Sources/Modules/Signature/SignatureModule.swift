import SwiftUIExt

struct SignatureModule: Module {

    let router: SignatureRouter

    func build() -> UIViewController {
        let view = SignatureView(viewModel: SignatureViewModel(router: router))
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
