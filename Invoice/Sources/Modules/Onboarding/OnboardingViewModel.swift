import Combine
import Depin

class OnboardingViewModel: ObservableObject {

    // MARK: - Injected properties

    private let router: OnboardingRouter

    init(router: OnboardingRouter) {
        self.router = router
    }

    func openPaywall() {
        router.openPaywallFromOnboarding()
    }
}
