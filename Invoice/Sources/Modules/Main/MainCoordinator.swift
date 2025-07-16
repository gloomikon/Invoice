import XCoordinator

enum MainRoute: Route {
    case main
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
        }
    }
}

// MARK: - MainRouter

extension MainCoordinator: MainRouter {

}
