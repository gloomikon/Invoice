import UIKit
import XCoordinator

enum AppRoute: Route {

    case splash
    case onboarding
    case paywall
    case main
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    init() {
        super.init(rootViewController: UINavigationController())
        trigger(.splash)
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {

        case .splash:
            let module = SplashModule(router: self)
            return .set(module.build())

        case .onboarding:
            let module = OnboardingModule(router: self)
            return .set(module.build(), animation: .fade)

        case .paywall:
            return .none(PaywallCoordinator(rootViewController: rootViewController, paywallTrigger: .onboarding))

        case .main:
            return .none(MainCoordinator(rootViewController: rootViewController))
        }
    }
}

// MARK: - SplashRouter

extension AppCoordinator: SplashRouter {

    func openIntroFromSplash() {
        trigger(.onboarding)
    }

    func openHome() {
        trigger(.main)
    }
}

// MARK: - OnboardingRouter

extension AppCoordinator: OnboardingRouter {

    func openMainFromOnboarding() {
        trigger(.main)
    }
}
