import Combine
import Depin

class PaywallViewModel: ObservableObject {

    // MARK: - Injected properties

    private let router: PaywallRouter

    init(router: PaywallRouter) {
        self.router = router
    }

    func close() {
        router.closePaywall()
    }
}
