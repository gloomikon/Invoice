import XCoordinator

@MainActor protocol CreateWorkItemRouter {

    func closeCreateWorkItem()
    func openSignature(
        completion: @escaping (UIImage) -> Void
    )
}

enum CreateWorkItemRoute: Route {

    case createWorkItem
    case dismiss
    case signature(
        completion: (UIImage) -> Void
    )
}

class CreateWorkItemCoordinator: NavigationCoordinator<CreateWorkItemRoute> {

    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.createWorkItem)
    }

    override func prepareTransition(for route: CreateWorkItemRoute) -> NavigationTransition {
        switch route {

        case .createWorkItem:
            let module = CreateWorkItemModule(
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

// MARK: - CreateWorkItemRouter

extension CreateWorkItemCoordinator: CreateWorkItemRouter {

    func closeCreateWorkItem() {
        trigger(.dismiss)
    }

    func openSignature(
        completion: @escaping (UIImage) -> Void
    ) {
        trigger(.signature(completion: completion))
    }
}
