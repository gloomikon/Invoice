import XCoordinator

@MainActor
protocol SignatureRouter {

    func close()
}

enum SignatureRoute: Route {

    case signature(
        onCreateSignature: (UIImage) -> Void
    )
    case dismiss
}

class SignatureCoordinator: NavigationCoordinator<SignatureRoute> {

    init(
        rootViewController: UINavigationController,
        onCreateSignature: @escaping (UIImage) -> Void
    ) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.signature(onCreateSignature: onCreateSignature))
    }

    override func prepareTransition(for route: SignatureRoute) -> NavigationTransition {
        switch route {

        case let .signature(onCreateSignature):
            let module = SignatureModule(
                router: self,
                onCreateSignature: onCreateSignature
            )
            return .present(module.build(), modalPresentationStyle: .fullScreen)

        case .dismiss:
            return .dismiss()
        }
    }
}

// MARK: - SignatureRouter

extension SignatureCoordinator: SignatureRouter {

    func close() {
        trigger(.dismiss)
    }
}
