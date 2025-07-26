import XCoordinator

enum PaywallRoute: Route {

    case paywall
    case privacyPolicy
    case termsOfService
    case main
}

enum PaywallTrigger {
    case onboarding
    case splash
    case settings
}

class PaywallCoordinator: NavigationCoordinator<PaywallRoute> {

    private let paywallTrigger: PaywallTrigger

    init(rootViewController: UINavigationController, paywallTrigger: PaywallTrigger) {
        self.paywallTrigger = paywallTrigger
        super.init(rootViewController: rootViewController)
        trigger(.paywall)
    }

    override func prepareTransition(for route: PaywallRoute) -> NavigationTransition {
        switch route {

        case .paywall:
            let module = PaywallModule(router: self)
            return .present(module.build(), modalPresentationStyle: .fullScreen, animation: .fade)

        case .privacyPolicy:
            guard let navController = rootViewController.presentedViewController as? UINavigationController else {
                return .none()
            }
            return .none(WebPageCoordinator(
                rootViewController: navController,
                url: AppConstant.privacyPolicy,
                title: String(localized: "Privacy Policy")
            ))

        case .termsOfService:
            guard let navController = rootViewController.presentedViewController as? UINavigationController else {
                return .none()
            }
            return .none(WebPageCoordinator(
                rootViewController: navController,
                url: AppConstant.termsOfUse,
                title: String(localized: "Terms of Service")
            ))

        case .main:
            switch paywallTrigger {
            case .onboarding, .splash:
                return .multiple(
                    .none(MainCoordinator(rootViewController: rootViewController)),
                    .dismiss()
                )
            case .settings:
                return .dismiss()
            }
        }
    }
}

// MARK: - PaywallRouter

extension PaywallCoordinator: PaywallRouter {
    func openMainScreen() {
        trigger(.main)
    }

    func openPrivacyPolicy() {
        trigger(.privacyPolicy)
    }

    func openTermsOfService() {
        trigger(.termsOfService)
    }
}
