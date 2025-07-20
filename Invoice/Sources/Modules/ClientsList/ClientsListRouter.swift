import XCoordinator

protocol ClientsListRouter {

    func close()
//    func openImportFromContacts()
}

enum ClientListRoute: Route {

    case clientsList((CD_Client) -> Void)
    case dismiss
//    case importFromContacts
//    case addClient
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
            let module = ClientsListModule(router: self)
            return .present(module.build(), modalPresentationStyle: .fullScreen)

        case .dismiss:
            return .dismiss()
        }
    }
}

// MARK: - ClientsListRouter

extension ClientsListCoordinator: ClientsListRouter {

    func close() {
        trigger(.dismiss)
    }
}
