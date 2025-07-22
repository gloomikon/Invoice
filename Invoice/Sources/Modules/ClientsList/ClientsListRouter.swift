import XCoordinator

protocol ClientsListRouter {

    func close()
    func openCreateClient()
}

enum ClientListRoute: Route {

    case clientsList((CD_Client) -> Void)
    case dismiss
    case createClient
}

class ClientsListCoordinator: NavigationCoordinator<ClientListRoute> {

    init(
        rootViewController: UINavigationController,
        onClientSelected: @escaping (CD_Client) -> Void
    ) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.clientsList(onClientSelected))
    }

    override func prepareTransition(for route: ClientListRoute) -> NavigationTransition {
        switch route {

        case let .clientsList(onClientSelected):
            let module = ClientsListModule(
                router: self,
                onClientSelected: onClientSelected
            )
            return .present(module.build(), modalPresentationStyle: .fullScreen)

        case .dismiss:
            return .dismiss()

        case .createClient:
            return .none(CreateClientCoordinator(
                rootViewController: rootViewController
            ))
        }
    }
}

// MARK: - ClientsListRouter

extension ClientsListCoordinator: ClientsListRouter {

    func close() {
        trigger(.dismiss)
    }

    func openCreateClient() {
        trigger(.createClient)
    }
}
