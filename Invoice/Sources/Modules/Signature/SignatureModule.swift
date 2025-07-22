import SwiftUIExt

struct SignatureModule: Module {

    func build() -> UIViewController {
        let view = SignatureView(viewModel: SignatureViewModel())
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
