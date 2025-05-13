import XCoordinator

extension XCoordinator.Transition {

    static func present(
        _ presentable: Presentable,
        modalPresentationStyle: UIModalPresentationStyle = .automatic,
        modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
        animation: Animation? = nil
    ) -> Transition {
        // swiftlint:disable:next force_unwrapping
        let viewController = presentable.viewController!
        viewController.modalPresentationStyle = modalPresentationStyle
        viewController.modalTransitionStyle = modalTransitionStyle
        return .present(viewController, animation: animation)
    }

    static func presentOnRoot(
        _ presentable: Presentable,
        modalPresentationStyle: UIModalPresentationStyle = .automatic,
        modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
        animation: Animation? = nil
    ) -> Transition {
        // swiftlint:disable:next force_unwrapping
        let viewController = presentable.viewController!
        viewController.modalPresentationStyle = modalPresentationStyle
        viewController.modalTransitionStyle = modalTransitionStyle
        return .presentOnRoot(viewController, animation: animation)
    }

    static func none(_: Presentable) -> Transition {
        .none()
    }
}

extension XCoordinator.Transition where RootViewController: UINavigationController {

    static func set(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        .set([presentable], animation: animation)
    }
}
