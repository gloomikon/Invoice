import Combine
import Depin

class SplashViewModel: ObservableObject {

    // MARK: - Injected properties

    private let router: SplashRouter

    init(router: SplashRouter) {
        self.router = router
    }

    func openOnboarding() {
        router.openOnboardingFromSplash()
    }
}
