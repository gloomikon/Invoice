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
            return .set(module)

        case .onboarding:
            let module = OnboardingModule(router: self)
            return .set(module, animation: .fade)

        case .paywall:
            let module = PaywallModule(router: self)
            return .present(module, modalPresentationStyle: .fullScreen)

        case .main:
            let module = MainModule(router: self)
            return .multiple(.set(module), .dismiss())
        }
    }
}

// MARK: - SplashRouter

extension AppCoordinator: SplashRouter {

    func openOnboardingFromSplash() {
        trigger(.onboarding)
    }
}

// MARK: - OnboardingRouter

extension AppCoordinator: OnboardingRouter {

    func openPaywallFromOnboarding() {
        trigger(.paywall)
    }
}

// MARK: - PaywallRouter

extension AppCoordinator: PaywallRouter {

    func closePaywall() {
        trigger(.main)
    }
}

// MARK: - MainRouter

extension AppCoordinator: MainRouter {

}
