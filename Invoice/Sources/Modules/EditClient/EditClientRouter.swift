import XCoordinator

@MainActor
protocol EditClientRouter {

    func closeEditClient()
}


enum EditClientRoute: Route {

    case editClient(CD_Client)
    case dismiss
}

class EditClientCoordinator: NavigationCoordinator<EditClientRoute> {

    init(rootViewController: UINavigationController, client: CD_Client) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.editClient(client))
    }

    override func prepareTransition(for route: EditClientRoute) -> NavigationTransition {
        switch route {

        case let .editClient(client):
            let module = EditClientModule(
                router: self,
                client: client
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

// MARK: - EditClientRouter

extension EditClientCoordinator: EditClientRouter {

    func closeEditClient() {
        trigger(.dismiss)
    }
}
