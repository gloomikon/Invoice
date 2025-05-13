import SwiftUI

class DebugPanelCoordinator {

    private weak var rootViewController: UIViewController?
    private let groups: [Group]

    init(rootViewController: UIViewController, groups: [Group]) {
        self.rootViewController = rootViewController
        self.groups = groups
    }

    func start() {
        let viewModel = DebugPanelViewModel(groups: groups)
        let view = DebugPanelView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        rootViewController?.present(viewController, animated: true)
    }
}
