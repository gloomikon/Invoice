import XCoordinator

protocol SettingsRouter {

    func close()
    func openPrivacyPolicy()
    func openTermsOfUse()
    func openClientsList()
    func openBusinessesList()
    func openItemsList()
    func openPaywall()
}

enum SettingsRoute: Route {
    case settings
    case pop
    case clientsList
    case businessesList
    case itemsList
    case termsOfUse
    case privacyPolicy
    case editClient(CD_Client)
    case editBusiness(CD_Business)
    case editWorkItem(CD_WorkItem)
    case paywall
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
            return .none(ClientsListCoordinator(
                rootViewController: rootViewController,
                onClientSelected: { [unowned self] client in
                    trigger(.editClient(client))
                }
            ))

        case .businessesList:
            return .none(BusinessesListCoordinator(
                rootViewController: rootViewController,
                onBusinessSelected: { [unowned self] business in
                    trigger(.editBusiness(business))
                }
            ))

        case .itemsList:
            return .none(WorkItemsListCoordinator(
                rootViewController: rootViewController,
                onWorkItemSelected: { [unowned self] workItem in
                    trigger(.editWorkItem(workItem))
                }
            ))

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

        case let .editClient(client):
            return .none(EditClientCoordinator(
                rootViewController: rootViewController,
                client: client
            ))

        case let .editBusiness(business):
            return .none(EditBusinessCoordinator(
                rootViewController: rootViewController,
                business: business
            ))

        case let .editWorkItem(workItem):
            return .none(EditWorkItemCoordinator(
                rootViewController: rootViewController,
                workItem: workItem
            ))

        case .paywall:
            return .none(PaywallCoordinator(
                rootViewController: rootViewController,
                paywallTrigger: .settings
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

    func openBusinessesList() {
        trigger(.businessesList)
    }

    func openItemsList() {
        trigger(.itemsList)
    }

    func openPaywall() {
        trigger(.paywall)
    }
}
