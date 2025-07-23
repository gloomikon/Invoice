import XCoordinator

@MainActor protocol EditBusinessRouter {

    func closeEditBusiness()
    func openSignature(
        completion: @escaping (UIImage) -> Void
    )
}

enum EditBusinessRoute: Route {

    case editBusiness(CD_Business)
    case dismiss
    case signature(
        completion: (UIImage) -> Void
    )
}

class EditBusinessCoordinator: NavigationCoordinator<EditBusinessRoute> {

    init(rootViewController: UINavigationController, business: CD_Business) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.editBusiness(business))
    }

    override func prepareTransition(for route: EditBusinessRoute) -> NavigationTransition {
        switch route {

        case let .editBusiness(business):
            let module = EditBusinessModule(
                router: self,
                business: business
            )
            return .present(
                module.build(),
                modalPresentationStyle: .fullScreen
            )

        case .dismiss:
            return .dismiss()

        case let .signature(completion):
            return .none(SignatureCoordinator(
                rootViewController: rootViewController,
                onCreateSignature: completion
            ))
        }
    }
}

// MARK: - EditBusinessRouter

extension EditBusinessCoordinator: EditBusinessRouter {

    func closeEditBusiness() {
        trigger(.dismiss)
    }

    func openSignature(
        completion: @escaping (UIImage) -> Void
    ) {
        trigger(.signature(completion: completion))
    }
}
