import Depin
import UIKit

struct PaywallModule: Module {

    @Injected private var provider: InAppPaywallProvider
    let router: PaywallRouter

    func build() -> UIViewController {
        provider
            .paywall()
            .init(router: router)
            .build()
    }
}
