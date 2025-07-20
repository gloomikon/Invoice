import XCoordinator

enum MainRoute: Route {
    case main
    case settings
}

class MainCoordinator: NavigationCoordinator<MainRoute> {

    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.main)
    }

    override func prepareTransition(for route: MainRoute) -> NavigationTransition {
        switch route {

        case .main:
            let module = MainModule(router: self)
            return .set(module.build())

        case .settings:
            return .none(SettingsCoordinator(rootViewController: rootViewController))
        }
    }
}

// MARK: - MainRouter

extension MainCoordinator: MainRouter {

    func openSettings() {
        trigger(.settings)
    }
}
