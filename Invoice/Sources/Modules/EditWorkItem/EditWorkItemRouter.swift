import XCoordinator

@MainActor protocol EditWorkItemRouter {

    func closeEditWorkItem()
}

enum EditWorkItemRoute: Route {

    case editWorkItem(CD_WorkItem)
    case dismiss
}

class EditWorkItemCoordinator: NavigationCoordinator<EditWorkItemRoute> {

    init(rootViewController: UINavigationController, workItem: CD_WorkItem) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.editWorkItem(workItem))
    }

    override func prepareTransition(for route: EditWorkItemRoute) -> NavigationTransition {
        switch route {

        case let .editWorkItem(workItem):
            let module = EditWorkItemModule(
                router: self,
                workItem: workItem
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

// MARK: - EditWorkItemRouter

extension EditWorkItemCoordinator: EditWorkItemRouter {

    func closeEditWorkItem() {
        trigger(.dismiss)
    }
}
