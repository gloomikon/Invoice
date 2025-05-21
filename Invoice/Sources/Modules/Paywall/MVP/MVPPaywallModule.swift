import SwiftUIExt
import UIKitExt

struct MVPPaywallModule: Paywall {

    static let name = "mvp"

    static let offering = "mvp_offering"

    let router: PaywallRouter

    func build() -> UIViewController {
        let viewModel = MVPPaywallViewModel(router: router, paywall: self)
        let view = MVPPaywallView(viewModel: viewModel)
        return HostingController(rootView: view).wrappedInNavigationController
    }
}
