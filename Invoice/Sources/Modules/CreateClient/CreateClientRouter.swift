import XCoordinator

@MainActor protocol CreateClientRouter {

    func closeCreateClient()
}

enum CreateClientRoute: Route {

    case createClient
    case dismiss
}

class CreateClientCoordinator: NavigationCoordinator<CreateClientRoute> {

    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.createClient)
    }

    override func prepareTransition(for route: CreateClientRoute) -> NavigationTransition {
        switch route {

        case .createClient:
            let module = CreateClientModule(
                router: self
            )
            return .present(
                module.build(),
                modalPresentationStyle: .fullScreen
            )

        case .dismiss:
            return .dismiss()
        }
    }
}

// MARK: - CreateClientRouter

extension CreateClientCoordinator: CreateClientRouter {

    func closeCreateClient() {
        trigger(.dismiss)
    }
}
