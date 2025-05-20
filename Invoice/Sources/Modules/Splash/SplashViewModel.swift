import CombineExt
import Core
import Depin
import UIKit

class SplashViewModel: ObservableObject {

    // MARK: - Injected properties

    private let router: SplashRouter

    // MARK: - Private properties

    private var bag = CancelBag()

    init(router: SplashRouter) {
        self.router = router

        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .first()
            .void()
            .sink { [weak self] in
                Task { await self?.start() }
            }
            .store(in: &bag)
    }

    private func start() async {
        await ATTManager.requestAuthorization()
    }

    func openOnboarding() {
        router.openOnboardingFromSplash()
    }
}
