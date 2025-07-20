import XCoordinator

protocol SettingsRouter {

    func close()
    func openPrivacyPolicy()
    func openTermsOfUse()
    func openClientsList()
    func openIssuersList()
    func openItemsList()
}

enum SettingsRoute: Route {
    case settings
    case pop
    case clientsList
    case issuerList
    case itemsList
    case termsOfUse
    case privacyPolicy
}

class SettingsCoordinator: NavigationCoordinator<SettingsRoute> {

    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.settings)
    }

    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {

        case .settings:
            let module = SettingsModule(router: self)
            return .push(module.build())

        case .pop:
            return .pop()

        case .clientsList:
            return .push(UIViewController())

        case .issuerList:
            return .push(UIViewController())

        case .itemsList:
            return .push(UIViewController())

        case .termsOfUse:
            return .none(WebPageCoordinator(
                rootViewController: rootViewController,
                url: AppConstant.termsOfUse,
                title: String(localized: "Terms of Service")
            ))

        case .privacyPolicy:
            return .none(WebPageCoordinator(
                rootViewController: rootViewController,
                url: AppConstant.privacyPolicy,
                title: String(localized: "Privacy Policy")
            ))
        }
    }
}

extension SettingsCoordinator: SettingsRouter {

    func close() {
        trigger(.pop)
    }

    func openPrivacyPolicy() {
        trigger(.privacyPolicy)
    }

    func openTermsOfUse() {
        trigger(.termsOfUse)
    }

    func openClientsList() {
        trigger(.clientsList)
    }

    func openIssuersList() {
        trigger(.issuerList)
    }

    func openItemsList() {
        trigger(.itemsList)
    }
}
