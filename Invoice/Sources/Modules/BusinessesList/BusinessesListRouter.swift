import XCoordinator

@MainActor protocol BusinessesListRouter {

    func close()
    func openCreateBusiness()
}

enum BusinessesListRoute: Route {

    case businessesList((CD_Business) -> Void)
    case dismiss
    case createBusiness
}

class BusinessesListCoordinator: NavigationCoordinator<BusinessesListRoute> {

    init(
        rootViewController: UINavigationController,
        onBusinessSelected: @escaping (CD_Business) -> Void
    ) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.businessesList(onBusinessSelected))
    }

    override func prepareTransition(for route: BusinessesListRoute) -> NavigationTransition {
        switch route {

        case let .businessesList(onBusinessSelected):
            let module = BusinessesListModule(
                router: self,
                onBusinessSelected: onBusinessSelected
            )
            return .present(module.build(), modalPresentationStyle: .fullScreen)

        case .dismiss:
            return .dismiss()

        case .createBusiness:
            return .none(CreateBusinessCoordinator(
                rootViewController: rootViewController
            ))
        }
    }
}

// MARK: - BusinessesListRouter

extension BusinessesListCoordinator: BusinessesListRouter {

    func close() {
        trigger(.dismiss)
    }

    func openCreateBusiness() {
        trigger(.createBusiness)
    }
}
