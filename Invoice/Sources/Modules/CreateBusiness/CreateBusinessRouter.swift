import XCoordinator

@MainActor protocol CreateBusinessRouter {

    func closeCreateBusiness()
    func openSignature(
        completion: @escaping (UIImage) -> Void
    )
}

enum CreateBusinessRoute: Route {

    case createBusiness
    case dismiss
    case signature(
        completion: (UIImage) -> Void
    )
}

class CreateBusinessCoordinator: NavigationCoordinator<CreateBusinessRoute> {

    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.createBusiness)
    }

    override func prepareTransition(for route: CreateBusinessRoute) -> NavigationTransition {
        switch route {

        case .createBusiness:
            let module = CreateBusinessModule(
                router: self
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

// MARK: - CreateBusinessRouter

extension CreateBusinessCoordinator: CreateBusinessRouter {

    func closeCreateBusiness() {
        trigger(.dismiss)
    }

    func openSignature(
        completion: @escaping (UIImage) -> Void
    ) {
        trigger(.signature(completion: completion))
    }
}
