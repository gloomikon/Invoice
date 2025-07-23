import SwiftUIExt

struct SignatureModule: Module {

    let router: SignatureRouter
    let onCreateSignature: (UIImage) -> Void

    func build() -> UIViewController {
        let viewModel = SignatureViewModel(
            router: router,
            onCreateSignature: onCreateSignature
        )
        let view = SignatureView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
