import Combine
import Depin

class OnboardingViewModel: ObservableObject {

    // MARK: - Injected properties

    private let router: OnboardingRouter

    @Published private(set) var page = 0

    init(router: OnboardingRouter) {
        self.router = router
    }

    func openNextPage() {
        if 0...1 ~= page {
            page += 1
            // TODO: - Ask for push, ask for rating
        } else {
            router.openMainFromOnboarding()
        }
    }
}
