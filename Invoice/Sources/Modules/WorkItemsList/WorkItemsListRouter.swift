import XCoordinator

@MainActor protocol WorkItemsListRouter {

    func close()
    func openCreateWorkItem()
}

enum WorkItemsListRoute: Route {

    case workItemsList((CD_WorkItem) -> Void)
    case dismiss
    case createWorkItem
}

class WorkItemsListCoordinator: NavigationCoordinator<WorkItemsListRoute> {

    init(
        rootViewController: UINavigationController,
        onWorkItemSelected: @escaping (CD_WorkItem) -> Void
    ) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.workItemsList(onWorkItemSelected))
    }

    override func prepareTransition(for route: WorkItemsListRoute) -> NavigationTransition {
        switch route {

        case let .workItemsList(onWorkItemSelected):
            let module = WorkItemsListModule(
                router: self,
                onWorkItemSelected: onWorkItemSelected
            )
            return .present(module.build(), modalPresentationStyle: .fullScreen)

        case .dismiss:
            return .dismiss()

        case .createWorkItem:
            return .none()
//            return .none(CreateWorkItemCoordinator(
//                rootViewController: rootViewController
//            ))
        }
    }
}

// MARK: - WorkItemsListRouter

extension WorkItemsListCoordinator: WorkItemsListRouter {

    func close() {
        trigger(.dismiss)
    }

    func openCreateWorkItem() {
        trigger(.createWorkItem)
    }
}
